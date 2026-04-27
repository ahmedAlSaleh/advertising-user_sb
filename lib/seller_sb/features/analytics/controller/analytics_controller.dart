import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../../uses_app_sb/core/server/helper_api.dart';
import '../../../../uses_app_sb/core/shared/models/user.dart';
import '../../../../uses_app_sb/core/shared/widgets/snacl_bar/snackbar_manager.dart';
import '../../../core/server/server_config.dart';
import '../../../core/shared/models/analytics_model.dart';

class AnalyticsController extends GetxController {
  // Loading states
  RxBool isLoadingOverview = true.obs;
  RxBool isLoadingAds = false.obs;
  RxBool isLoadingChart = false.obs;

  // Data
  Rx<AnalyticsOverviewModel?> overview = Rx<AnalyticsOverviewModel?>(null);
  RxList<AdAnalyticsModel> adsAnalytics = <AdAnalyticsModel>[].obs;
  Rx<ChartDataModel?> chartData = Rx<ChartDataModel?>(null);

  // Selected period for chart
  RxString selectedPeriod = 'week'.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllAnalytics();
  }

  /// Load All Analytics Data
  Future<void> loadAllAnalytics() async {
    await Future.wait([
      getOverview(),
      getAdsAnalytics(),
      getChartData(selectedPeriod.value),
    ]);
  }

  /// Get Analytics Overview
  /// GET /api/trader/analytics/overview
  Future<void> getOverview() async {
    try {
      isLoadingOverview.value = true;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: ServerConstApis.getAnalyticsOverview,
        method: "GET",
        token: token,
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error loading overview: ${apiException.message}");
          }
          SnackbarManager.showSnackbar(
            apiException.message,
            backgroundColor: appTheme.error,
          );
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            overview.value = AnalyticsOverviewModel.fromJson(apiResponse.data!);

            if (kDebugMode) {
              print("Overview loaded successfully");
            }
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Exception loading overview: $e");
      }
    } finally {
      isLoadingOverview.value = false;
    }
  }

  /// Get Ads Analytics
  /// GET /api/trader/analytics/ads
  Future<void> getAdsAnalytics() async {
    try {
      isLoadingAds.value = true;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: ServerConstApis.getAdsAnalytics,
        method: "GET",
        token: token,
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error loading ads analytics: ${apiException.message}");
          }
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            // Extract the list from the response
            final dataList = apiResponse.data!['data'] ?? [];

            adsAnalytics.value = List<AdAnalyticsModel>.from(
              dataList.map((x) => AdAnalyticsModel.fromJson(x)),
            );

            if (kDebugMode) {
              print("Ads analytics loaded: ${adsAnalytics.length} ads");
            }
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Exception loading ads analytics: $e");
      }
    } finally {
      isLoadingAds.value = false;
    }
  }

  /// Get Chart Data
  /// GET /api/trader/analytics/chart?period={period}
  Future<void> getChartData(String period) async {
    try {
      isLoadingChart.value = true;
      selectedPeriod.value = period;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: '${ServerConstApis.getChartData}?period=$period',
        method: "GET",
        token: token,
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error loading chart data: ${apiException.message}");
          }
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            chartData.value = ChartDataModel.fromJson(apiResponse.data!);

            if (kDebugMode) {
              print("Chart data loaded for period: $period");
            }
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Exception loading chart data: $e");
      }
    } finally {
      isLoadingChart.value = false;
    }
  }

  /// Refresh All Data
  Future<void> refreshAll() async {
    await loadAllAnalytics();
  }

  /// Helper: Get top performing ads (sorted by views)
  List<AdAnalyticsModel> get topAds {
    final sorted = List<AdAnalyticsModel>.from(adsAnalytics);
    sorted.sort((a, b) => b.viewsCount.compareTo(a.viewsCount));
    return sorted.take(5).toList();
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../../uses_app_sb/core/server/helper_api.dart';
import '../../../../uses_app_sb/core/shared/models/store_model.dart';
import '../../../../uses_app_sb/core/shared/models/user.dart';
import '../../../../uses_app_sb/core/shared/widgets/snacl_bar/snackbar_manager.dart';
import '../../../core/server/server_config.dart';

class StoreHoursController extends GetxController {
  // Loading states
  RxBool isLoadingHours = true.obs;
  RxBool isUpdating = false.obs;

  // Data
  RxList<StoreHoursModel> storeHours = <StoreHoursModel>[].obs;

  // Days of week
  final List<String> daysOfWeek = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  @override
  void onInit() {
    super.onInit();
    _initializeDefaultHours();
    getStoreHours();
  }

  /// Initialize default hours for all days
  void _initializeDefaultHours() {
    storeHours.value = daysOfWeek.map((day) {
      return StoreHoursModel(
        day: day,
        opensAt: '09:00',
        closesAt: '21:00',
        isClosed: day == 'Friday', // Friday closed by default
      );
    }).toList();
  }

  /// Get Store Hours
  /// GET /api/trader/store/hours
  Future<void> getStoreHours() async {
    try {
      isLoadingHours.value = true;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: ServerConstApis.getStoreHours,
        method: "GET",
        token: token,
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error fetching store hours: ${apiException.message}");
          }
          // Keep default hours if API fails
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            final dynamic responseData = apiResponse.data;
            final List<dynamic> dataList = responseData is List
                ? responseData
                : (responseData is Map ? (responseData['data'] ?? []) : []);

            if (dataList.isNotEmpty) {
              storeHours.value = List<StoreHoursModel>.from(
                dataList.map((x) => StoreHoursModel.fromJson(x)),
              );
            }

            if (kDebugMode) {
              print("Store hours loaded: ${storeHours.length} days");
            }
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error loading store hours: $e");
      }
    } finally {
      isLoadingHours.value = false;
    }
  }

  /// Update Store Hours
  /// POST /api/trader/store/hours
  Future<void> updateStoreHours() async {
    try {
      isUpdating.value = true;

      final hoursData = {
        'hours': storeHours.map((hour) => hour.toJson()).toList(),
      };

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: ServerConstApis.updateStoreHours,
        method: "POST",
        token: token,
        data: hoursData,
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error updating store hours: ${apiException.message}");
          }
          SnackbarManager.showSnackbar(
            apiException.message,
            icon: Icon(Icons.error_outline, color: appTheme.primaryText),
            backgroundColor: appTheme.error,
          );
        },
        (apiResponse) {
          if (apiResponse.isSuccess) {
            SnackbarManager.showSnackbar(
              apiResponse.message ?? "تم تحديث أوقات العمل بنجاح",
              icon: Icon(Icons.check_circle, color: appTheme.primaryText),
              backgroundColor: Colors.green,
            );

            // Reload hours to get updated IDs
            getStoreHours();
          } else {
            SnackbarManager.showSnackbar(
              apiResponse.message ?? "فشل تحديث أوقات العمل",
              icon: Icon(Icons.error_outline, color: appTheme.primaryText),
              backgroundColor: appTheme.error,
            );
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error updating store hours: $e");
      }
      SnackbarManager.showSnackbar(
        "حدث خطأ في تحديث أوقات العمل",
        icon: Icon(Icons.error_outline, color: appTheme.primaryText),
        backgroundColor: appTheme.error,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  /// Toggle day closed status
  void toggleDayClosed(int index) {
    final hour = storeHours[index];
    storeHours[index] = hour.copyWith(isClosed: !hour.isClosed);
  }

  /// Update day hours
  void updateDayHours(int index, String opensAt, String closesAt) {
    final hour = storeHours[index];
    storeHours[index] = hour.copyWith(
      opensAt: opensAt,
      closesAt: closesAt,
    );
  }

  /// Set all days to same hours
  void applyToAllDays(String opensAt, String closesAt) {
    storeHours.value = storeHours.map((hour) {
      if (!hour.isClosed) {
        return hour.copyWith(opensAt: opensAt, closesAt: closesAt);
      }
      return hour;
    }).toList();
  }

  /// Reset to default hours
  void resetToDefault() {
    _initializeDefaultHours();
  }

  /// Get hours for specific day
  StoreHoursModel? getHoursForDay(String day) {
    try {
      return storeHours.firstWhere(
        (hour) => hour.day.toLowerCase() == day.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Check if store is open now
  bool isStoreOpenNow() {
    final now = DateTime.now();
    final dayName = _getDayName(now.weekday);
    final todayHours = getHoursForDay(dayName);

    if (todayHours == null) return false;
    return todayHours.isOpenNow();
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 7:
        return 'Sunday';
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      default:
        return '';
    }
  }

  /// Format time for display
  String formatTime(String? time) {
    if (time == null) return '--:--';
    return time;
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../core/server/helper_api.dart';
import '../../../core/server/server_config.dart';
import '../../../core/shared/models/rating_model.dart';
import '../../../core/shared/models/user.dart';
import '../../../core/shared/widgets/snacl_bar/snackbar_manager.dart';

class RatingController extends GetxController {
  // Loading states
  RxBool isSubmittingRating = false.obs;
  RxBool isLoadingRatings = true.obs;

  // Data
  Rx<StoreRatingsModel?> storeRatings = Rx<StoreRatingsModel?>(null);

  /// Submit Rating
  /// POST /api/user/rate
  Future<void> submitRating({
    required int storeId,
    required int rating,
    String? comment,
  }) async {
    try {
      isSubmittingRating.value = true;

      final ratingRequest = RatingRequest(
        ratedId: storeId,
        ratedType: 'store',
        rate: rating,
        comment: comment,
      );

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: ServerConstApis.submitRating,
        method: "POST",
        token: token,
        data: ratingRequest.toJson(),
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error submitting rating: ${apiException.message}");
          }
          SnackbarManager.showSnackbar(
            apiException.message,
            backgroundColor: appTheme.error,
          );
        },
        (apiResponse) async {
          if (apiResponse.isSuccess) {
            SnackbarManager.showSnackbar(
              apiResponse.message ?? 'تم إضافة التقييم بنجاح',
              backgroundColor: Colors.green,
            );

            if (kDebugMode) {
              print("Rating submitted successfully");
            }

            // Refresh ratings after submission
            await getStoreRatings(storeId);
          } else {
            SnackbarManager.showSnackbar(
              apiResponse.message ?? 'فشل إضافة التقييم',
              backgroundColor: appTheme.error,
            );
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Exception submitting rating: $e");
      }
      SnackbarManager.showSnackbar(
        'حدث خطأ أثناء إضافة التقييم',
        backgroundColor: appTheme.error,
      );
    } finally {
      isSubmittingRating.value = false;
    }
  }

  /// Get Store Ratings
  /// GET /api/user/rate/{store_id}
  Future<void> getStoreRatings(int storeId) async {
    try {
      isLoadingRatings.value = true;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: '${ServerConstApis.getStoreRatings}/$storeId',
        method: "GET",
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error loading ratings: ${apiException.message}");
          }
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            storeRatings.value = StoreRatingsModel.fromJson(apiResponse.data!);

            if (kDebugMode) {
              print("Store ratings loaded: ${storeRatings.value?.totalRatings} ratings");
              print("Average rating: ${storeRatings.value?.averageRating}");
            }
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Exception loading ratings: $e");
      }
    } finally {
      isLoadingRatings.value = false;
    }
  }

  /// Helper: Get rating distribution (5 stars, 4 stars, etc.)
  Map<int, int> getRatingDistribution() {
    if (storeRatings.value == null) {
      return {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    }

    final distribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};

    for (var rating in storeRatings.value!.ratings) {
      if (rating.rate >= 1 && rating.rate <= 5) {
        distribution[rating.rate] = (distribution[rating.rate] ?? 0) + 1;
      }
    }

    return distribution;
  }

  /// Helper: Get percentage for each star rating
  Map<int, double> getRatingPercentages() {
    final distribution = getRatingDistribution();
    final total = storeRatings.value?.totalRatings ?? 0;

    if (total == 0) {
      return {5: 0.0, 4: 0.0, 3: 0.0, 2: 0.0, 1: 0.0};
    }

    return {
      5: (distribution[5]! / total) * 100,
      4: (distribution[4]! / total) * 100,
      3: (distribution[3]! / total) * 100,
      2: (distribution[2]! / total) * 100,
      1: (distribution[1]! / total) * 100,
    };
  }

  /// Clear ratings
  void clearRatings() {
    storeRatings.value = null;
    isLoadingRatings.value = false;
  }
}

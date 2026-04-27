
import 'package:advertising_user/main.dart';
import 'package:advertising_user/uses_app_sb/core/server/helper_api.dart';
import 'package:advertising_user/uses_app_sb/core/shared/models/user.dart';
import 'package:advertising_user/uses_app_sb/features/adverizing/model/advertise_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../core/server/server_config.dart';
import '../../../core/shared/widgets/snacl_bar/snackbar_manager.dart';
import '../../adverizing/controlller/advertizing_controller.dart';
class FavoritesController extends GetxController {
  var favoriteItems = <Advertise>[].obs; // List to hold favorite items
  var isLoading = false.obs; // Loading state
  var isError = false.obs; // Error state
  var needLogin = false.obs; // حالة تطلب تسجيل الدخول

  @override
  void onInit() {
    super.onInit();
     checkTokenAndFetch();
  }

   void checkTokenAndFetch() {
    if (token.isEmpty) {
      needLogin.value = true;
      isLoading.value = false;
    } else {
      needLogin.value = false;
      fetchFavorites();
    }
  }

   fetchFavorites() async {
    // التحقق من التوكن قبل جلب البيانات
    if (token.isEmpty) {
      needLogin.value = true;
      return;
    }

    isLoading.value = true;
    isError.value = false;
    needLogin.value = false;

    try {
      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: ServerConstApis.getFavoriteAds,
        method: 'GET',
        token: token,
      );

      response.fold(
        (apiException) {
          // Handle error response
          if (kDebugMode) {
            print("Error fetching favorites: ${apiException.message}");
          }
          isError.value = true;
          favoriteItems.clear();
        },
        (apiResponse) {
          // Handle success response
          if (apiResponse.isSuccess && apiResponse.data != null) {
            // Handle paginated response structure
            if (apiResponse.data!['data'] is Map &&
                apiResponse.data!['data']['data'] != null) {
              // Paginated response
              List<dynamic> data = apiResponse.data!['data']['data'];
              favoriteItems.value =
                  data.map((json) => Advertise.fromJson(json)).toList();
            } else if (apiResponse.data!['data'] is List) {
              // Simple list response (fallback for non-paginated)
              List<dynamic> data = apiResponse.data!['data'];
              favoriteItems.value =
                  data.map((json) => Advertise.fromJson(json)).toList();
            } else {
              favoriteItems.clear();
            }
          } else {
            favoriteItems.clear();
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Exception fetching favorites: $e");
      }
      isError.value = true;
      favoriteItems.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh the data
  refreshFavorites() async {
    checkTokenAndFetch();
  }

  Future<void> removeFromFavorite(int advertiseId, int advertiseIndex) async {
    // التحقق من التوكن قبل الحذف
    if (token.isEmpty) {
      SnackbarManager.showSnackbar("يرجى تسجيل الدخول أولاً",
          backgroundColor: appTheme.error);
      return;
    }

    try {
      // Make the API request to add or remove from favorite
      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
          targetRout: "${ServerConstApis.toggleAdFavorite}/$advertiseId",
          method: "Get",
          token: token);

      response.fold(
        (apiException) {
          // Handle error response
          if (kDebugMode) {
            print("Error: ${apiException.message}");
          }
          SnackbarManager.showSnackbar(apiException.message,
              backgroundColor: appTheme.error);
        },
        (apiResponse) {
          // Handle success response
          if (apiResponse.isSuccess) {
            // Toggle the favorite status in the local item list
            favoriteItems.removeAt(advertiseIndex);
            favoriteItems.refresh();
            // Optionally show a success message
            SnackbarManager.showSnackbar(
                apiResponse.message ?? "تم الحذف من المفضلة بنجاح",
                backgroundColor: appTheme.success);

            try {
              Get.find<AdvertiseController>().refreshController();
            } catch (e) {
              // Controller not found
            }
          }
        },
      );
    } catch (e) {
      // Handle any exceptions
      if (kDebugMode) {
        print("Exception: $e");
      }
      SnackbarManager.showSnackbar("حدث خطأ غير متوقع",
          backgroundColor: appTheme.error);
    }
  }
}
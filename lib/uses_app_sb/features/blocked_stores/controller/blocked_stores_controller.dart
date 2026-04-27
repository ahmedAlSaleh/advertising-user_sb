import 'package:advertising_user/main.dart';
import 'package:advertising_user/uses_app_sb/core/server/helper_api.dart';
import 'package:advertising_user/uses_app_sb/core/server/server_config.dart';
import 'package:advertising_user/uses_app_sb/core/shared/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/blocked_store_model.dart';

class BlockedStoresController extends GetxController {
  RxList<BlockedStore> blockedStores = <BlockedStore>[].obs;
  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  RxBool isNotAuthenticated = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Check if user is logged in before fetching data
    if (token.isEmpty) {
      isNotAuthenticated.value = true;
      isLoading.value = false;
    } else {
      getBlockedStores();
    }
  }

  Future<void> getBlockedStores() async {
    try {
      // Check authentication before making API call
      if (token.isEmpty) {
        isNotAuthenticated.value = true;
        isLoading.value = false;
        return;
      }

      isLoading.value = true;
      isError.value = false;
      isNotAuthenticated.value = false;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: ServerConstApis.getBlockedStores,
        method: "GET",
        token: token,
      );

      response.fold(
        (apiException) {
          // Handle error response
          if (kDebugMode) {
            print("Error fetching blocked stores: ${apiException.message}");
          }

          // Handle 401 Unauthenticated error
          if (apiException.message.contains('Unauthenticated') ||
              apiException.message.contains('401')) {
            isNotAuthenticated.value = true;
            blockedStores.value = [];
          } else {
            isError.value = true;
          }
        },
        (apiResponse) {
          // Handle success response
          if (apiResponse.isSuccess && apiResponse.data != null) {
            if (apiResponse.data!['stores'] != null) {
              // Handle paginated response structure
              if (apiResponse.data!['stores'] is Map &&
                  apiResponse.data!['stores']['data'] != null) {
                // Paginated response
                List<dynamic> storesJson = apiResponse.data!['stores']['data'];
                blockedStores.value = storesJson
                    .map((json) => BlockedStore.fromJson(json))
                    .toList();
              } else if (apiResponse.data!['stores'] is List) {
                // Simple list response (fallback)
                List<dynamic> storesJson = apiResponse.data!['stores'];
                blockedStores.value = storesJson
                    .map((json) => BlockedStore.fromJson(json))
                    .toList();
              } else {
                blockedStores.value = [];
              }
            } else {
              blockedStores.value = [];
            }
            isError.value = false;
            isNotAuthenticated.value = false;
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Exception in getBlockedStores: $e");
      }
      isError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> unblockStore(int storeId, int index) async {
    try {
      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: "${ServerConstApis.blockStore}/$storeId",
        method: "GET",
        token: token,
      );

      response.fold(
        (apiException) {
          // Handle error response
          if (kDebugMode) {
            print("Error unblocking store: ${apiException.message}");
          }
          Get.snackbar(
            'Error'.tr,
            apiException.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: appTheme.error,
            colorText: Colors.white,
          );
        },
        (apiResponse) {
          // Handle success response
          if (apiResponse.data != null &&
              apiResponse.data!['status'] == false &&
              apiResponse.data!['message'] == "Store removed from blocked") {
            // Remove the store from the list
            blockedStores.removeAt(index);
            Get.snackbar(
              'Success'.tr,
              apiResponse.data!['message'],
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: appTheme.primary,
              colorText: Colors.white,
            );
          } else {
            Get.snackbar(
              'Error'.tr,
              apiResponse.message ?? "Failed to unblock store",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: appTheme.error,
              colorText: Colors.white,
            );
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Exception unblocking store: $e");
      }
      Get.snackbar(
        'Error'.tr,
        'An error occurred'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: appTheme.error,
        colorText: Colors.white,
      );
    }
  }
}

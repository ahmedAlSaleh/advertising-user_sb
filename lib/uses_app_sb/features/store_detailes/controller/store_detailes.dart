import 'package:advertising_user/main.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/server/api_exception.dart';
import '../../../core/server/api_response.dart';
import '../../../core/server/helper_api.dart';
import '../../../core/server/server_config.dart';
import '../../../core/shared/controllers/pagination_controller.dart';
import '../../../core/shared/models/user.dart';
import '../../adverizing/model/advertise_model.dart';
import '../../favorite/controller/favorites_controller.dart';
import '../model/store_detailes_model.dart';

class StoreDetailesController extends GetxController {
  Store? store;
  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  RxBool isFavoriteLoading = false.obs;
  late int storeId;

  @override
  onInit() async {
    storeId = Get.arguments;
    await getStoreDetailes();
    super.onInit();
  }

  toggleStoreFavorite() async {
    if (token.isEmpty) {
      // Show auth required dialog
      return false;
    }

    if (store == null) return false;

    try {
      isFavoriteLoading.value = true;
      update();

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
          targetRout: "${ServerConstApis.toggleStoreFavorite}/$storeId",
          method: "Get",
          token: token);

      bool success = false;
      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error toggling favorite: ${apiException.message}");
          }
          Get.snackbar(
            "خطأ",
            apiException.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: appTheme.error,
            colorText: Colors.white,
          );
        },
        (apiResponse) {
          if (apiResponse.isSuccess) {
            // API returns status:true when adding, status:false when removing
            // Both are successful operations, so toggle the state
            store!.isFavourite = !store!.isFavourite;
            success = true;

            if (kDebugMode) {
              print("Favorite toggled successfully: ${apiResponse.message}");
            }
          }
        },
      );

      isFavoriteLoading.value = false;
      update();
      return success;
    } catch (e) {
      if (kDebugMode) {
        print("Exception toggling favorite: $e");
      }
      isFavoriteLoading.value = false;
      update();
    }
    return false;
  }

  Future<Map<String, dynamic>> blockStore() async {
    if (token.isEmpty) {
      return {
        'success': false,
        'message': 'Authentication required',
      };
    }

    try {
      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
          targetRout: "${ServerConstApis.blockStore}/$storeId",
          method: "GET",
          token: token);

      Map<String, dynamic> result = {
        'success': false,
        'message': 'An error occurred',
      };

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error blocking store: ${apiException.message}");
          }
          result = {
            'success': false,
            'message': apiException.message,
          };
        },
        (apiResponse) {
          if (apiResponse.isSuccess) {
            if (kDebugMode) {
              print("Store blocked successfully: ${apiResponse.message}");
            }
            result = {
              'success': true,
              'message': apiResponse.message ?? "Store blocked successfully",
            };
          } else {
            result = {
              'success': false,
              'message': apiResponse.message ?? "Failed to block store",
            };
          }
        },
      );

      return result;
    } catch (e) {
      if (kDebugMode) {
        print("Exception blocking store: $e");
      }
      return {
        'success': false,
        'message': 'An error occurred',
      };
    }
  }

  getStoreDetailes() async {
    try {
      isLoading.value = true;

      // ✅ Check if token exists and use appropriate endpoint
      String apiUrl;
      String? apiToken;

      if (token.isEmpty) {
        apiUrl = '${ServerConstApis.showStoreGuest}/$storeId';
        apiToken = null;
      } else {
        apiUrl = '${ServerConstApis.showStore}/$storeId';
        apiToken = token;
      }

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
          targetRout: apiUrl,
          method: "Get",
          token: apiToken);

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error fetching store details: ${apiException.message}");
          }
          isError.value = true;
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            if (kDebugMode) {
              print("Response data: ${apiResponse.data}");
            }

            // Parse using new StoreDetailsModel structure
            StoreDetailsModel storeDetailsModel = StoreDetailsModel.fromJson(apiResponse.data!);
            store = storeDetailsModel.store;

            Get.put(AdverizeForStoreController());

            isError.value = false;
          } else {
            isError.value = true;
          }
        },
      );
    } catch (e) {
      print("Exception in getStoreDetailes: $e");
      isError.value = true;
    } finally {
      isLoading.value = false;
    }
  }
}

class AdverizeForStoreController extends PaginationController<Advertise> {
  AdverizeForStoreController()
      : super(fetchDataCallback: _fetchData, cacheKey: "advertizeforstore");

  static Future<Either<ApiException, ApiResponse<dynamic>>> _fetchData(
      String url, int page, Map<String, dynamic> additionalParams) async {
    int storeId = Get.find<StoreDetailesController>().storeId;
    String apiUrl = "${ServerConstApis.getStoreAdvertises}/$storeId?page=$page";

    return ApiHelper.makeRequest(
      targetRout: apiUrl,
      method: "get",
      token: token,
    );
  }

  @override
  handleDataSuccess(dynamic handlingResponse) {
    List<dynamic> postListJson = handlingResponse['data']['data'];
    lastPageId = handlingResponse['data']['last_page'];

    var postList =
    postListJson.map((jsonItem) => Advertise.fromJson(jsonItem)).toList();
    itemList.addAll(postList);

    if (pageId == lastPageId) {
      hasMoreData.value = false;
    }
    pageId++;
    isLoading.value = false;
    isLoadingMoreData.value = false;
  }

  Future<void> addToFavorite(int advertiseId, int advertiseIndex) async {
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
          Get.snackbar(
            "خطأ",
            apiException.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: appTheme.error,
            colorText: Colors.white,
          );
        },
        (apiResponse) {
          // Handle success response
          if (apiResponse.isSuccess) {
            // Toggle the favorite status in the local item list
            var updatedAdvertise = itemList[advertiseIndex];
            updatedAdvertise.isFavorite = !updatedAdvertise.isFavorite;

            // Update the item in the list
            itemList[advertiseIndex] = updatedAdvertise;
            itemList.refresh();

            try {
              Get.find<FavoritesController>().refreshFavorites();
            } catch (e) {
              // FavoritesController not found
            }

            Get.snackbar(
              "نجح",
              apiResponse.message ?? "تم التحديث بنجاح",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: appTheme.success,
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
            );
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Exception: $e");
      }
      Get.snackbar(
        "خطأ",
        "حدث خطأ غير متوقع",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: appTheme.error,
        colorText: Colors.white,
      );
    }
  }
}
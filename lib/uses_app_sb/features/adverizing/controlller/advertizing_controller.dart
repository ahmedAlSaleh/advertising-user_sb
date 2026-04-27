// File: advertise_controller.dart
import 'package:advertising_user/uses_app_sb/core/server/api_exception.dart';
import 'package:advertising_user/uses_app_sb/core/server/api_response.dart';
import 'package:advertising_user/uses_app_sb/core/server/helper_api.dart';
import 'package:advertising_user/uses_app_sb/core/server/server_config.dart';
import 'package:advertising_user/uses_app_sb/core/shared/controllers/pagination_controller.dart';
import 'package:advertising_user/uses_app_sb/core/shared/models/store_category.dart';
import 'package:advertising_user/uses_app_sb/core/shared/models/user.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../favorite/controller/favorites_controller.dart';
import '../model/advertise_model.dart';

class AdvertiseController extends GetxController {
  RxList<Datum> storesCategory = <Datum>[].obs;
  Rx<Datum?> selectedCategory = Rx<Datum?>(null);

  RxBool isLoadingFetchingCateogires = false.obs;
  @override
  void onInit() {
    getStoresCategory();
    super.onInit();
  }

  getStoresCategory() async {
    try {
      isLoadingFetchingCateogires.value = true; // Start loading

      // Make the API request
      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: ServerConstApis.getStoresCategories,
        method: "Get",
      );

      response.fold(
        (apiException) {
          // Handle error response
          if (kDebugMode) {
            print("Error fetching categories: ${apiException.message}");
          }
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            // Parsing the required files from the response
            StoreCategory storeCategoryResponse = StoreCategory.fromJson(apiResponse.data!);

            // Mapping the JSON data to a list of Datum objects
            storesCategory.value = storeCategoryResponse.data;

            // Set the first category as selected if available
            if (storesCategory.isNotEmpty) {
              selectedCategory.value = storesCategory.first;
            }
          }
        },
      );
    } catch (e) {
      // Handle error here, e.g. showing a message or logging it
      if (kDebugMode) {
        print("Exception fetching categories: $e");
      }
    } finally {
      isLoadingFetchingCateogires.value = false; // End loading
    }
  }

  // Slider variables
  var currentPage = 0.obs;
  var isSliding = false.obs;

  // Carousel page change method
  void onPageChanged(int index) {
    currentPage.value = index;
  }

  // Category selection method
  void selectCategory(Datum category) async {
    selectedCategory.value = category;
    isLoadingFetchingCateogires.value = true;
    // Refresh data in pagination controllers with the selected category ID
    await normalAdverizeController
        .refreshData(para: {"category_id": category.id.toString()});
    await specialAdverizeController
        .refreshData(para: {"category_id": category.id.toString()});
    isLoadingFetchingCateogires.value = false;
  }

  refreshController() {
    normalAdverizeController.refreshData();
    specialAdverizeController.refreshData();
  }

   final NormalAdverizeController normalAdverizeController = Get.find();
  final SpecialAdverizeController specialAdverizeController = Get.find();
}

class NormalAdverizeController extends PaginationController<Advertise> {
  NormalAdverizeController()
      : super(fetchDataCallback: _fetchData, cacheKey: "normalAdvertiseList");

  static Future<Either<ApiException, ApiResponse<dynamic>>> _fetchData(
      String url, int page, Map<String, dynamic> additionalParams) async {


    String apiEndpoint = (token.isNotEmpty)
        ? ServerConstApis.getAdvertize
        : ServerConstApis.getAdvertizeGuest;

    String apiUrl = "$apiEndpoint?page=$page";

    Map<String, dynamic> data = {'type': 'normal'};
    if (additionalParams.isNotEmpty) {
      data['category_id'] = additionalParams['category_id'];
    } else {
      data['category_id'] = 1;
    }

    // إرسال التوكن فقط إذا كان متوفر
    return ApiHelper.makeRequest(
        targetRout: apiUrl,
        method: "Post",
        token: (token.isNotEmpty) ? token : null,
        data: data);
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
    // التحقق من وجود التوكن أولاً
    if (token.isEmpty) {
      Get.snackbar(
        "تسجيل الدخول مطلوب",
        "يرجى تسجيل الدخول أولاً لإضافة العناصر للمفضلة",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.context != null
            ? Theme.of(Get.context!).colorScheme.error
            : Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
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

          Get.snackbar(
            "خطأ",
            apiException.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.context != null
                ? Theme.of(Get.context!).colorScheme.error
                : Colors.red,
            colorText: Colors.white,
          );
        },
        (apiResponse) {
          if (apiResponse.isSuccess) {
            var updatedAdvertise = itemList[advertiseIndex];
            updatedAdvertise.isFavorite = !updatedAdvertise.isFavorite;

            itemList[advertiseIndex] = updatedAdvertise;
            itemList.refresh(); // Notify UI of changes

            try {
              Get.find<FavoritesController>().refreshFavorites();
            } catch (e) {
              // FavoritesController not found
            }

            // Show success message
            Get.snackbar(
              "نجح",
              apiResponse.message ?? "تم تحديث المفضلة بنجاح",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
            );
          }
        },
      );
    } catch (e) {
      // Handle any exceptions
      if (kDebugMode) {
        print("Exception: $e");
      }

      Get.snackbar(
        "خطأ",
        "حدث خطأ غير متوقع",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

class SpecialAdverizeController extends PaginationController<Advertise> {
  SpecialAdverizeController()
      : super(fetchDataCallback: _fetchData, cacheKey: "specialAdvertiseList");

  static Future<Either<ApiException, ApiResponse<dynamic>>> _fetchData(
      String url, int page, Map<String, dynamic> additionalParams) async {
    if (kDebugMode) {
      print("Fetching special advertise data: $additionalParams");
    }

    // اختيار API حسب وجود التوكن
    String apiEndpoint = (token.isNotEmpty)
        ? ServerConstApis.getAdvertize
        : ServerConstApis.getAdvertizeGuest;

    String apiUrl = "$apiEndpoint?page=$page";

    Map<String, dynamic> data = {'type': 'special'};
    if (additionalParams.isNotEmpty) {
      data['category_id'] = additionalParams['category_id'];
    } else {
      data['category_id'] = 1;
    }

    // إرسال التوكن فقط إذا كان متوفر
    return ApiHelper.makeRequest(
        targetRout: apiUrl,
        method: "Post",
        token: (token.isNotEmpty) ? token : null,
        data: data);
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
}

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../core/server/helper_api.dart';
import '../../../core/server/server_config.dart';
import '../../../core/shared/models/advertisement_model.dart';
import '../../../core/shared/models/store_model.dart';
import '../../../core/shared/models/user.dart';
import '../../../core/shared/widgets/snacl_bar/snackbar_manager.dart';

class StoresController extends GetxController {
  // Loading states
  RxBool isLoadingStores = true.obs;
  RxBool isLoadingStoreDetails = false.obs;
  RxBool isLoadingPosts = false.obs;
  RxBool isLoadingAds = false.obs;
  RxBool isSearching = false.obs;

  // Data
  RxList<StoreModel> stores = <StoreModel>[].obs;
  Rx<StoreModel?> selectedStore = Rx<StoreModel?>(null);
  RxList<StorePostModel> storePosts = <StorePostModel>[].obs;
  RxList<AdvertisementModel> storeAdvertisements = <AdvertisementModel>[].obs;

  // Search filter
  Rx<StoreSearchFilter> searchFilter = StoreSearchFilter().obs;

  @override
  void onInit() {
    super.onInit();
  }

  /// Get Stores by Category
  /// GET /api/user/getStore_byCat/{category_id}
  Future<void> getStoresByCategory(int categoryId, {bool isGuest = false}) async {
    try {
      isLoadingStores.value = true;

      final endpoint = isGuest
          ? '${ServerConstApis.getStoresByCategoryGuest}/$categoryId'
          : '${ServerConstApis.getStoresByCategory}/$categoryId';

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: endpoint,
        method: "GET",
        token: isGuest ? null : token,
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error fetching stores: ${apiException.message}");
          }
          SnackbarManager.showSnackbar(
            apiException.message,
            backgroundColor: appTheme.error,
          );
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            final dynamic responseData = apiResponse.data;
            final List<dynamic> dataList = responseData is List
                ? responseData
                : (responseData is Map ? (responseData['data'] ?? []) : []);

            stores.value = List<StoreModel>.from(
              dataList.map((x) => StoreModel.fromJson(x)),
            );

            if (kDebugMode) {
              print("Stores loaded: ${stores.length} items");
            }
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error loading stores: $e");
      }
      SnackbarManager.showSnackbar(
        "حدث خطأ في تحميل المتاجر",
        backgroundColor: appTheme.error,
      );
    } finally {
      isLoadingStores.value = false;
    }
  }

  /// Show Store Details
  /// GET /api/user/show_store/{store_id}
  Future<void> showStoreDetails(int storeId, {bool isGuest = false}) async {
    try {
      isLoadingStoreDetails.value = true;

      final endpoint = isGuest
          ? '${ServerConstApis.showStoreGuest}/$storeId'
          : '${ServerConstApis.showStore}/$storeId';

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: endpoint,
        method: "GET",
        token: isGuest ? null : token,
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error fetching store details: ${apiException.message}");
          }
          SnackbarManager.showSnackbar(
            apiException.message,
            backgroundColor: appTheme.error,
          );
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            selectedStore.value = StoreModel.fromJson(apiResponse.data!);

            if (kDebugMode) {
              print("Store details loaded: ${selectedStore.value}");
            }
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error loading store details: $e");
      }
      SnackbarManager.showSnackbar(
        "حدث خطأ في تحميل تفاصيل المتجر",
        backgroundColor: appTheme.error,
      );
    } finally {
      isLoadingStoreDetails.value = false;
    }
  }

  /// Search Store
  /// POST /api/user/search/store
  Future<void> searchStores({
    StoreSearchFilter? customFilter,
    bool isGuest = false,
  }) async {
    try {
      isSearching.value = true;

      final filterToUse = customFilter ?? searchFilter.value;

      final endpoint = isGuest
          ? ServerConstApis.searchStoreGuest
          : ServerConstApis.searchStore;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: endpoint,
        method: "POST",
        token: isGuest ? null : token,
        data: filterToUse.toJson(),
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error searching stores: ${apiException.message}");
          }
          SnackbarManager.showSnackbar(
            apiException.message,
            backgroundColor: appTheme.error,
          );
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            final dynamic responseData = apiResponse.data;
            final List<dynamic> dataList = responseData is List
                ? responseData
                : (responseData is Map ? (responseData['data'] ?? []) : []);

            stores.value = List<StoreModel>.from(
              dataList.map((x) => StoreModel.fromJson(x)),
            );

            if (kDebugMode) {
              print("Search results: ${stores.length} items");
            }
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error searching stores: $e");
      }
      SnackbarManager.showSnackbar(
        "حدث خطأ في البحث عن المتاجر",
        backgroundColor: appTheme.error,
      );
    } finally {
      isSearching.value = false;
    }
  }

  /// Get Store Posts
  /// GET /api/user/getStore_Post/{store_id}
  Future<void> getStorePosts(int storeId) async {
    try {
      isLoadingPosts.value = true;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: '${ServerConstApis.getStorePosts}/$storeId',
        method: "GET",
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error fetching store posts: ${apiException.message}");
          }
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            final dynamic responseData = apiResponse.data;
            final List<dynamic> dataList = responseData is List
                ? responseData
                : (responseData is Map ? (responseData['data'] ?? []) : []);

            storePosts.value = List<StorePostModel>.from(
              dataList.map((x) => StorePostModel.fromJson(x)),
            );

            if (kDebugMode) {
              print("Store posts loaded: ${storePosts.length} items");
            }
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error loading store posts: $e");
      }
    } finally {
      isLoadingPosts.value = false;
    }
  }

  /// Get Store Advertisements
  /// GET /api/user/getStore_Ads/{store_id}
  Future<void> getStoreAdvertisements(int storeId, {bool isGuest = false}) async {
    try {
      isLoadingAds.value = true;

      final endpoint = isGuest
          ? '${ServerConstApis.getStoreAdvertisesGuest}/$storeId'
          : '${ServerConstApis.getStoreAdvertises}/$storeId';

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: endpoint,
        method: "GET",
        token: isGuest ? null : token,
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error fetching store ads: ${apiException.message}");
          }
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            final dynamic responseData = apiResponse.data;
            final List<dynamic> dataList = responseData is List
                ? responseData
                : (responseData is Map ? (responseData['data'] ?? []) : []);

            storeAdvertisements.value = List<AdvertisementModel>.from(
              dataList.map((x) => AdvertisementModel.fromJson(x)),
            );

            if (kDebugMode) {
              print("Store ads loaded: ${storeAdvertisements.length} items");
            }
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error loading store advertisements: $e");
      }
    } finally {
      isLoadingAds.value = false;
    }
  }

  /// Get Store by Advertisement
  /// GET /api/user/getStore_pyAdv/{advertisement_id}
  Future<void> getStoreByAdvertisement(int advertisementId) async {
    try {
      isLoadingStoreDetails.value = true;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: '${ServerConstApis.getStoreByAdvertisement}/$advertisementId',
        method: "GET",
        token: token,
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error fetching store by ad: ${apiException.message}");
          }
          SnackbarManager.showSnackbar(
            apiException.message,
            backgroundColor: appTheme.error,
          );
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            selectedStore.value = StoreModel.fromJson(apiResponse.data!);

            if (kDebugMode) {
              print("Store loaded: ${selectedStore.value}");
            }
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error loading store by advertisement: $e");
      }
      SnackbarManager.showSnackbar(
        "حدث خطأ في تحميل المتجر",
        backgroundColor: appTheme.error,
      );
    } finally {
      isLoadingStoreDetails.value = false;
    }
  }

  /// Apply search filter
  Future<void> applyFilter(StoreSearchFilter filter, {bool isGuest = false}) async {
    searchFilter.value = filter;
    await searchStores(customFilter: filter, isGuest: isGuest);
  }

  /// Reset filter
  Future<void> resetFilter({bool isGuest = false}) async {
    searchFilter.value = StoreSearchFilter();
    stores.clear();
  }

  /// Refresh stores
  Future<void> refreshStores(int categoryId, {bool isGuest = false}) async {
    await getStoresByCategory(categoryId, isGuest: isGuest);
  }

  /// Clear selected store
  void clearSelectedStore() {
    selectedStore.value = null;
    storePosts.clear();
    storeAdvertisements.clear();
  }
}

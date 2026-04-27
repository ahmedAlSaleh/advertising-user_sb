import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../core/server/helper_api.dart';
import '../../../core/server/server_config.dart';
import '../../../core/shared/models/advertisement_model.dart';
import '../../../core/shared/models/store_model.dart';
import '../../../core/shared/models/user.dart';
import '../../../core/shared/widgets/snacl_bar/snackbar_manager.dart';

class FavoritesController extends GetxController {
  // Loading states
  RxBool isLoadingAds = true.obs;
  RxBool isLoadingStores = true.obs;
  RxBool isTogglingAd = false.obs;
  RxBool isTogglingStore = false.obs;

  // Data
  RxList<AdvertisementModel> favoriteAds = <AdvertisementModel>[].obs;
  RxList<StoreModel> favoriteStores = <StoreModel>[].obs;

  // Track favorites by ID for quick lookup
  RxSet<int> favoriteAdIds = <int>{}.obs;
  RxSet<int> favoriteStoreIds = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  /// Load all favorites
  Future<void> loadFavorites() async {
    await Future.wait([
      getFavoriteAds(),
      getFavoriteStores(),
    ]);
  }

  /// Toggle Advertisement Favorite
  /// GET /api/user/add_to_favorite/{advertisement_id}
  Future<void> toggleAdFavorite(int advertisementId) async {
    try {
      isTogglingAd.value = true;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: '${ServerConstApis.toggleAdFavorite}/$advertisementId',
        method: "GET",
        token: token,
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error toggling ad favorite: ${apiException.message}");
          }
          SnackbarManager.showSnackbar(
            apiException.message,
            backgroundColor: appTheme.error,
          );
        },
        (apiResponse) {
          if (apiResponse.isSuccess) {
            // Update local state
            if (favoriteAdIds.contains(advertisementId)) {
              favoriteAdIds.remove(advertisementId);
              favoriteAds.removeWhere((ad) => ad.id == advertisementId);
            } else {
              favoriteAdIds.add(advertisementId);
            }

            SnackbarManager.showSnackbar(
              apiResponse.message ?? "تم التحديث بنجاح",
              icon: Icon(Icons.favorite, color: appTheme.primaryText),
              backgroundColor: Colors.green,
            );

            if (kDebugMode) {
              print("Ad favorite toggled: $advertisementId");
            }
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error toggling ad favorite: $e");
      }
      SnackbarManager.showSnackbar(
        "حدث خطأ في تحديث المفضلة",
        backgroundColor: appTheme.error,
      );
    } finally {
      isTogglingAd.value = false;
    }
  }

  /// Toggle Store Favorite
  /// GET /api/user/add_store_to_favorite/{store_id}
  Future<void> toggleStoreFavorite(int storeId) async {
    try {
      isTogglingStore.value = true;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: '${ServerConstApis.toggleStoreFavorite}/$storeId',
        method: "GET",
        token: token,
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error toggling store favorite: ${apiException.message}");
          }
          SnackbarManager.showSnackbar(
            apiException.message,
            backgroundColor: appTheme.error,
          );
        },
        (apiResponse) {
          if (apiResponse.isSuccess) {
            // Update local state
            if (favoriteStoreIds.contains(storeId)) {
              favoriteStoreIds.remove(storeId);
              favoriteStores.removeWhere((store) => store.id == storeId);
            } else {
              favoriteStoreIds.add(storeId);
            }

            SnackbarManager.showSnackbar(
              apiResponse.message ?? "تم التحديث بنجاح",
              icon: Icon(Icons.favorite, color: appTheme.primaryText),
              backgroundColor: Colors.green,
            );

            if (kDebugMode) {
              print("Store favorite toggled: $storeId");
            }
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error toggling store favorite: $e");
      }
      SnackbarManager.showSnackbar(
        "حدث خطأ في تحديث المفضلة",
        backgroundColor: appTheme.error,
      );
    } finally {
      isTogglingStore.value = false;
    }
  }

  /// Get Favorite Advertisements
  /// GET /api/user/favoriteAdv
  Future<void> getFavoriteAds() async {
    try {
      isLoadingAds.value = true;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: ServerConstApis.getFavoriteAds,
        method: "GET",
        token: token,
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error fetching favorite ads: ${apiException.message}");
          }
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            final dynamic responseData = apiResponse.data;
            final List<dynamic> dataList = responseData is List
                ? responseData
                : (responseData is Map ? (responseData['data'] ?? []) : []);

            favoriteAds.value = List<AdvertisementModel>.from(
              dataList.map((x) => AdvertisementModel.fromJson(x)),
            );

            // Update IDs set
            favoriteAdIds.assignAll(favoriteAds.map((ad) => ad.id).toSet());

            if (kDebugMode) {
              print("Favorite ads loaded: ${favoriteAds.length} items");
            }
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error loading favorite ads: $e");
      }
    } finally {
      isLoadingAds.value = false;
    }
  }

  /// Get Favorite Stores
  /// GET /api/user/favoriteStores
  Future<void> getFavoriteStores() async {
    try {
      isLoadingStores.value = true;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: ServerConstApis.getFavoriteStores,
        method: "GET",
        token: token,
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error fetching favorite stores: ${apiException.message}");
          }
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            final dynamic responseData = apiResponse.data;
            final List<dynamic> dataList = responseData is List
                ? responseData
                : (responseData is Map ? (responseData['data'] ?? []) : []);

            favoriteStores.value = List<StoreModel>.from(
              dataList.map((x) => StoreModel.fromJson(x)),
            );

            // Update IDs set
            favoriteStoreIds.assignAll(favoriteStores.map((s) => s.id).toSet());

            if (kDebugMode) {
              print("Favorite stores loaded: ${favoriteStores.length} items");
            }
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error loading favorite stores: $e");
      }
    } finally {
      isLoadingStores.value = false;
    }
  }

  /// Check if ad is favorite
  bool isAdFavorite(int adId) {
    return favoriteAdIds.contains(adId);
  }

  /// Check if store is favorite
  bool isStoreFavorite(int storeId) {
    return favoriteStoreIds.contains(storeId);
  }

  /// Refresh all favorites
  Future<void> refreshFavorites() async {
    await loadFavorites();
  }

  /// Clear all favorites (logout)
  void clearFavorites() {
    favoriteAds.clear();
    favoriteStores.clear();
    favoriteAdIds.clear();
    favoriteStoreIds.clear();
  }
}

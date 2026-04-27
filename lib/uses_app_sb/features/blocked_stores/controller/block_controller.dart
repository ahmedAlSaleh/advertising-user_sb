import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../core/server/helper_api.dart';
import '../../../core/server/server_config.dart';
import '../../../core/shared/models/user.dart';
import '../../../core/shared/widgets/snacl_bar/snackbar_manager.dart';

class BlockController extends GetxController {
  // Loading states
  RxBool isLoadingBlockedStores = true.obs;
  RxBool isToggling = false.obs;

  // Data
  RxList<BlockedStoreModel> blockedStores = <BlockedStoreModel>[].obs;

  // Track blocked IDs for quick lookup
  RxSet<int> blockedStoreIds = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    getBlockedStores();
  }

  /// Toggle Store Block
  /// GET /api/user/block/store/{store_id}
  Future<void> toggleBlock(int storeId) async {
    try {
      isToggling.value = true;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: '${ServerConstApis.blockStore}/$storeId',
        method: "GET",
        token: token,
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error toggling block: ${apiException.message}");
          }
          SnackbarManager.showSnackbar(
            apiException.message,
            backgroundColor: appTheme.error,
          );
        },
        (apiResponse) {
          if (apiResponse.isSuccess) {
            // Update local state
            if (blockedStoreIds.contains(storeId)) {
              blockedStoreIds.remove(storeId);
              blockedStores.removeWhere((store) => store.id == storeId);
            } else {
              blockedStoreIds.add(storeId);
            }

            SnackbarManager.showSnackbar(
              apiResponse.message ?? "تم التحديث بنجاح",
              icon: Icon(Icons.block, color: appTheme.primaryText),
              backgroundColor: Colors.green,
            );

            if (kDebugMode) {
              print("Store block toggled: $storeId");
            }
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error toggling block: $e");
      }
      SnackbarManager.showSnackbar(
        "حدث خطأ في تحديث الحظر",
        backgroundColor: appTheme.error,
      );
    } finally {
      isToggling.value = false;
    }
  }

  /// Get Blocked Stores
  /// GET /api/user/blocked/stores
  Future<void> getBlockedStores() async {
    try {
      isLoadingBlockedStores.value = true;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: ServerConstApis.getBlockedStores,
        method: "GET",
        token: token,
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error fetching blocked stores: ${apiException.message}");
          }
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            final dynamic responseData = apiResponse.data;
            final List<dynamic> dataList = responseData is List
                ? responseData
                : (responseData is Map ? (responseData['data'] ?? []) : []);

            blockedStores.value = List<BlockedStoreModel>.from(
              dataList.map((x) => BlockedStoreModel.fromJson(x)),
            );

            // Update IDs set
            blockedStoreIds.assignAll(blockedStores.map((s) => s.id).toSet());

            if (kDebugMode) {
              print("Blocked stores loaded: ${blockedStores.length} items");
            }
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error loading blocked stores: $e");
      }
    } finally {
      isLoadingBlockedStores.value = false;
    }
  }

  /// Check if store is blocked
  bool isStoreBlocked(int storeId) {
    return blockedStoreIds.contains(storeId);
  }

  /// Unblock store
  Future<void> unblockStore(int storeId) async {
    await toggleBlock(storeId);
    await getBlockedStores(); // Refresh list
  }

  /// Refresh blocked stores
  Future<void> refreshBlockedStores() async {
    await getBlockedStores();
  }

  /// Clear blocked stores (logout)
  void clearBlockedStores() {
    blockedStores.clear();
    blockedStoreIds.clear();
  }
}

/// Blocked Store Model
class BlockedStoreModel {
  final int id;
  final String storeName;
  final String? storeOwnerName;
  final String? image;
  final DateTime? blockedAt;

  BlockedStoreModel({
    required this.id,
    required this.storeName,
    this.storeOwnerName,
    this.image,
    this.blockedAt,
  });

  factory BlockedStoreModel.fromJson(Map<String, dynamic> json) {
    return BlockedStoreModel(
      id: json['id'] ?? 0,
      storeName: json['store_name'] ?? '',
      storeOwnerName: json['store_owner_name'],
      image: json['image'],
      blockedAt: json['blocked_at'] != null
          ? DateTime.tryParse(json['blocked_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_name': storeName,
      'store_owner_name': storeOwnerName,
      'image': image,
      'blocked_at': blockedAt?.toIso8601String(),
    };
  }
}

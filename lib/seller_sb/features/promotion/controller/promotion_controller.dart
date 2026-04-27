import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../../uses_app_sb/core/server/helper_api.dart';
import '../../../../uses_app_sb/core/shared/models/user.dart';
import '../../../../uses_app_sb/core/shared/widgets/snacl_bar/snackbar_manager.dart';
import '../../../core/server/server_config.dart';
import '../../../core/shared/models/promotion_model.dart';

class PromotionController extends GetxController {
  // Loading states
  RxBool isLoadingPackages = true.obs;
  RxBool isPromoting = false.obs;

  // Data
  RxList<PromotionPackageModel> packages = <PromotionPackageModel>[].obs;
  Rx<PromotionResultModel?> lastPromotionResult = Rx<PromotionResultModel?>(null);

  @override
  void onInit() {
    super.onInit();
    getPackages();
  }

  /// Get Promotion Packages
  /// GET /api/promotion-packages (no auth required)
  Future<void> getPackages() async {
    try {
      isLoadingPackages.value = true;

      final response = await ApiHelper.makeRequest<List<dynamic>>(
        targetRout: ServerConstApis.getPromotionPackages,
        method: "GET",
        // No token - public endpoint
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error loading packages: ${apiException.message}");
          }
          SnackbarManager.showSnackbar(
            apiException.message,
            backgroundColor: appTheme.error,
          );
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            packages.value = List<PromotionPackageModel>.from(
              apiResponse.data!.map((x) => PromotionPackageModel.fromJson(x)),
            );

            if (kDebugMode) {
              print("Packages loaded: ${packages.length}");
            }
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Exception loading packages: $e");
      }
      SnackbarManager.showSnackbar(
        'حدث خطأ أثناء تحميل الباقات',
        backgroundColor: appTheme.error,
      );
    } finally {
      isLoadingPackages.value = false;
    }
  }

  /// Promote Advertisement
  /// POST /api/trader/ads/{advertisement_id}/promote
  Future<bool> promoteAd({
    required int advertisementId,
    required int packageId,
  }) async {
    try {
      isPromoting.value = true;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: '${ServerConstApis.promoteAd}/$advertisementId/promote',
        method: "POST",
        token: token,
        data: {
          'package_id': packageId,
        },
      );

      bool success = false;

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error promoting ad: ${apiException.message}");
          }
          SnackbarManager.showSnackbar(
            apiException.message,
            backgroundColor: appTheme.error,
          );
          success = false;
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            lastPromotionResult.value = PromotionResultModel.fromJson(apiResponse.data!);

            SnackbarManager.showSnackbar(
              lastPromotionResult.value!.successMessage,
              backgroundColor: appTheme.success,
            );

            if (kDebugMode) {
              print("Ad promoted successfully");
              print("Points deducted: ${lastPromotionResult.value!.pointsDeducted}");
              print("Promoted until: ${lastPromotionResult.value!.promotedUntil}");
            }

            success = true;
          }
        },
      );

      return success;
    } catch (e) {
      if (kDebugMode) {
        print("Exception promoting ad: $e");
      }
      SnackbarManager.showSnackbar(
        'حدث خطأ أثناء ترويج الإعلان',
        backgroundColor: appTheme.error,
      );
      return false;
    } finally {
      isPromoting.value = false;
    }
  }

  /// Show promotion confirmation dialog
  Future<bool> showPromotionConfirmation({
    required BuildContext context,
    required String adTitle,
    required PromotionPackageModel package,
  }) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('تأكيد الترويج'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الإعلان: $adTitle'),
            const SizedBox(height: 8),
            Text('الباقة: ${package.name}'),
            const SizedBox(height: 8),
            Text('المدة: ${package.formattedDuration}'),
            const SizedBox(height: 8),
            Text(
              'التكلفة: ${package.formattedPrice}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'سيتم خصم النقاط من رصيدك. هل تريد المتابعة؟',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: appTheme.primary,
            ),
            child: const Text('تأكيد الترويج'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  /// Helper: Get package by ID
  PromotionPackageModel? getPackageById(int id) {
    try {
      return packages.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Helper: Check if packages are available
  bool get hasPackages => packages.isNotEmpty;
}

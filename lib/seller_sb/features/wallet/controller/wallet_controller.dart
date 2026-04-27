import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../../uses_app_sb/core/server/helper_api.dart';
import '../../../../uses_app_sb/core/shared/models/user.dart';
import '../../../../uses_app_sb/core/shared/widgets/snacl_bar/snackbar_manager.dart';
import '../../../core/server/server_config.dart';
import '../../../core/shared/models/wallet_model.dart';

class WalletController extends GetxController {
  // Loading states
  RxBool isLoadingWallet = true.obs;
  RxBool isLoadingPoints = false.obs;
  RxBool isLoadingRecharge = false.obs;

  // Data
  Rx<WalletModel?> wallet = Rx<WalletModel?>(null);
  RxInt points = 0.obs;

  // Form for recharge
  final TextEditingController rechargeCodeController = TextEditingController();
  late GlobalKey<FormState> rechargeFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    loadWalletData();
  }

  @override
  void onClose() {
    rechargeCodeController.dispose();
    super.onClose();
  }

  /// Load Wallet Data on init
  Future<void> loadWalletData() async {
    await getWallet();
  }

  /// Get Wallet - API
  /// GET /api/get/wallet
  Future<void> getWallet() async {
    try {
      isLoadingWallet.value = true;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: ServerConstApis.getWallet,
        method: "GET",
        token: token,
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error fetching wallet: ${apiException.message}");
          }
          SnackbarManager.showSnackbar(
            apiException.message,
            backgroundColor: appTheme.error,
          );
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            wallet.value = WalletModel.fromJson(apiResponse.data!);
            points.value = wallet.value!.points;

            if (kDebugMode) {
              print("Wallet loaded: ${wallet.value}");
            }
          } else {
            SnackbarManager.showSnackbar(
              apiResponse.message ?? "Failed to load wallet",
              backgroundColor: appTheme.error,
            );
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error loading wallet: $e");
      }
      SnackbarManager.showSnackbar(
        "حدث خطأ في تحميل المحفظة",
        backgroundColor: appTheme.error,
      );
    } finally {
      isLoadingWallet.value = false;
    }
  }

  /// Get Points Only - API
  /// GET /api/get/point
  Future<void> getPoints() async {
    try {
      isLoadingPoints.value = true;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: ServerConstApis.getPoints,
        method: "GET",
        token: token,
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error fetching points: ${apiException.message}");
          }
          SnackbarManager.showSnackbar(
            apiException.message,
            backgroundColor: appTheme.error,
          );
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            PointsModel pointsModel = PointsModel.fromJson(apiResponse.data!);
            points.value = pointsModel.points;

            if (kDebugMode) {
              print("Points: ${pointsModel.points}");
            }
          } else {
            SnackbarManager.showSnackbar(
              apiResponse.message ?? "Failed to load points",
              backgroundColor: appTheme.error,
            );
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error loading points: $e");
      }
      SnackbarManager.showSnackbar(
        "حدث خطأ في تحميل النقاط",
        backgroundColor: appTheme.error,
      );
    } finally {
      isLoadingPoints.value = false;
    }
  }

  /// Recharge Points by Code - API
  /// POST /api/RechargeByCode
  Future<void> rechargeByCode() async {
    try {
      FormState? formdata = rechargeFormKey.currentState;
      if (formdata!.validate()) {
        formdata.save();

        isLoadingRecharge.value = true;

        final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
          targetRout: ServerConstApis.rechargeByCode,
          method: "POST",
          token: token,
          data: {
            'code': rechargeCodeController.text.trim(),
          },
        );

        response.fold(
          (apiException) {
            isLoadingRecharge.value = false;

            if (kDebugMode) {
              print("Recharge error: ${apiException.message}");
            }

            SnackbarManager.showSnackbar(
              apiException.message,
              icon: Icon(Icons.error_outline, color: appTheme.primaryText),
              backgroundColor: appTheme.error,
            );

            // Show validation errors if any
            if (apiException.isValidationError && apiException.errors != null) {
              if (kDebugMode) {
                apiException.errors!.forEach((field, messages) {
                  print("$field: ${messages.join(', ')}");
                });
              }
            }
          },
          (apiResponse) {
            isLoadingRecharge.value = false;

            if (apiResponse.isSuccess && apiResponse.data != null) {
              RechargeResultModel result = RechargeResultModel.fromJson(apiResponse.data!);

              if (kDebugMode) {
                print("Recharge successful: $result");
              }

              // Update local points
              points.value = result.newBalance;

              // Update wallet if exists
              if (wallet.value != null) {
                wallet.value = WalletModel(
                  balance: wallet.value!.balance,
                  points: result.newBalance,
                  traderId: wallet.value!.traderId,
                );
              }

              // Clear the code field
              rechargeCodeController.clear();

              // Show success message
              SnackbarManager.showSnackbar(
                "${apiResponse.message ?? "تم شحن النقاط بنجاح"}\n+${result.pointsAdded} نقطة",
                icon: Icon(Icons.check_circle, color: appTheme.primaryText),
                backgroundColor: Colors.green,
              );

              // Close dialog/screen
              Get.back();

              // Refresh wallet data
              getWallet();
            } else {
              SnackbarManager.showSnackbar(
                apiResponse.message ?? "فشل شحن النقاط",
                icon: Icon(Icons.error_outline, color: appTheme.primaryText),
                backgroundColor: appTheme.error,
              );
            }
          },
        );
      }
    } catch (e) {
      isLoadingRecharge.value = false;
      if (kDebugMode) {
        print("Recharge error: $e");
      }
      SnackbarManager.showSnackbar(
        "حدث خطأ في شحن النقاط",
        icon: Icon(Icons.error_outline, color: appTheme.primaryText),
        backgroundColor: appTheme.error,
      );
    }
  }

  /// Refresh wallet data
  Future<void> refreshWallet() async {
    await getWallet();
  }

  /// Format balance for display
  String getFormattedBalance() {
    if (wallet.value == null) return "0";
    return wallet.value!.balance.toStringAsFixed(0);
  }

  /// Get points for display
  String getFormattedPoints() {
    return points.value.toString();
  }
}

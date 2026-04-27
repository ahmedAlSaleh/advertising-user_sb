import 'package:advertising_user/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../uses_app_sb/core/server/helper_api.dart';
import '../../../../uses_app_sb/core/shared/models/user.dart';
import '../../../../uses_app_sb/core/shared/widgets/snacl_bar/snackbar_manager.dart';
import '../../../core/server/server_config.dart';

class SettingController extends GetxController {
  Locale language = const Locale('en');
  RxBool isLoading = false.obs;
  RxBool isLoadingDeleteAccount = false.obs;

  @override
  void onInit() {
    language = locale;
    super.onInit();
  }

  void changeLanguage(String langCode) async {
    Locale locale = Locale(langCode);

    Get.updateLocale(locale);
    await storeService.createString("language", langCode);

    language = locale;
    update(["updateLanguage"]);
    update();
    Get.back();
  }

  bool isDarkMode = false;

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    update(['theme']);
  }

  /// Logout - API الجديد
  Future<void> logout() async {
    try {
      isLoading.value = true;

      // استدعاء Logout API
      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: ServerConstApis.logout,
        method: "GET",
        token: token,
      );

      response.fold(
        (apiException) {
          // حتى لو فشل الـ API، سنقوم بتسجيل الخروج محلياً
          if (kDebugMode) {
            print("Logout API error: ${apiException.message}");
          }
        },
        (apiResponse) {
          if (kDebugMode) {
            print("Logout successful: ${apiResponse.message}");
          }
        },
      );

      // تسجيل الخروج محلياً في كل الأحوال
      String language = await storeService.readString('language') ?? 'ar';
      await storeService.clearStorage();
      await storeService.createString('language', language);
      token = '';
      Get.offAllNamed('/AccountTypeSelection');
    } catch (e) {
      if (kDebugMode) {
        print("Logout error: $e");
      }
      // تسجيل خروج محلي حتى لو حدث خطأ
      try {
        String language = await storeService.readString('language') ?? 'ar';
        await storeService.clearStorage();
        await storeService.createString('language', language);
        token = '';
        Get.offAllNamed('/AccountTypeSelection');
      } catch (e) {
        Get.back();
        SnackbarManager.showSnackbar(
          "Failed logout, Retry again.".tr,
          icon: Icon(Icons.logout, color: appTheme.primaryText),
          backgroundColor: appTheme.error,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete Account - API الجديد
  Future<void> deleteAccount() async {
    try {
      isLoadingDeleteAccount.value = true;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: ServerConstApis.deleteAccount,
        method: "DELETE",
        token: token,
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error deleting account: ${apiException.message}");
          }
          Get.back();
          SnackbarManager.showSnackbar(
            apiException.message,
            icon: Icon(Icons.delete_forever_outlined, color: appTheme.primaryText),
            backgroundColor: appTheme.error,
          );
        },
        (apiResponse) {
          if (apiResponse.isSuccess) {
            onUerDeleteAccount();
          } else {
            Get.back();
            SnackbarManager.showSnackbar(
              apiResponse.message ?? "Failed to delete account",
              icon: Icon(Icons.delete_forever_outlined, color: appTheme.primaryText),
              backgroundColor: appTheme.error,
            );
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Delete account error: $e");
      }
      Get.back();
      SnackbarManager.showSnackbar(
        "Failed delete account, Retry again.",
        icon: Icon(Icons.delete_forever_outlined, color: appTheme.primaryText),
        backgroundColor: appTheme.error,
      );
    } finally {
      isLoadingDeleteAccount.value = false;
    }
  }

  onUerDeleteAccount() async {
    String language = await storeService.readString('language') ?? 'ar';
    if (await storeService.clearStorage()) {
      await storeService.createString('language', language);
      token = '';
      Get.offAllNamed('/AccountTypeSelection');
    } else {
      Get.back();
      SnackbarManager.showSnackbar(
        "Failed delete account ,Retry again. ",
        icon: Icon(Icons.delete_forever_outlined, color: appTheme.primaryText),
        backgroundColor: appTheme.error,
      );
    }
  }
}
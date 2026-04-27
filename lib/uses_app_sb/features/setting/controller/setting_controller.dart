// uses_app_sb/features/setting/controller/setting_controller.dart
import 'package:advertising_user/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/server/helper_api.dart';
import '../../../core/server/server_config.dart';
import '../../../core/shared/models/user.dart';
import '../../../core/shared/widgets/snacl_bar/snackbar_manager.dart';

class SettingController extends GetxController {
  Locale language = Locale('en');

  RxBool isLoading = false.obs;
  RxBool isLoadingDeleteAccount = false.obs;

  RxBool isUserLoggedIn = false.obs;

  @override
  void onInit() {
    language = locale;
    checkLoginStatus();
    super.onInit();
  }

  Future<void> checkLoginStatus() async {
    try {
      bool hasToken = await storeService.isContainKey('token');
      if (hasToken) {
        String? storedToken = await storeService.readString('token');
        if (storedToken != null && storedToken.isNotEmpty) {
          isUserLoggedIn.value = true;
          if (token.isEmpty) {
            token = storedToken;
          }
        } else {
          isUserLoggedIn.value = false;
        }
      } else {
        isUserLoggedIn.value = false;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error checking login status: $e");
      }
      isUserLoggedIn.value = false;
    }
  }

  void onUserLogin(String userToken) {
    token = userToken;
    isUserLoggedIn.value = true;
    update();
  }

  void changeLanguage(String langCode) async {
    Locale locale = Locale(langCode);

    Get.updateLocale(locale);
    await storeService.createString("language", langCode);

    language = locale;
    print(language);
    update(["updateLanguage"]);
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
      isUserLoggedIn.value = false;
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
        isUserLoggedIn.value = false;
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
            onUserDeleteAccount();
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

  onUserDeleteAccount() async {
    String language = await storeService.readString('language') ?? 'ar';
    if (await storeService.clearStorage()) {
      await storeService.createString('language', language);
      isUserLoggedIn.value = false;
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

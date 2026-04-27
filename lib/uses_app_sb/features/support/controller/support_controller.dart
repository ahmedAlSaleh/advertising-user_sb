import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/server/helper_api.dart';
import '../../../core/server/server_config.dart';
import '../../../core/shared/models/support_model.dart';
import '../../../core/shared/widgets/snacl_bar/snackbar_manager.dart';

class SupportController extends GetxController {
  // Loading states
  RxBool isLoadingSupportInfo = false.obs;
  RxBool isLoadingVersion = false.obs;

  // Data
  Rx<SupportModel?> supportInfo = Rx<SupportModel?>(null);
  Rx<AppVersionModel?> appVersion = Rx<AppVersionModel?>(null);

  // Current app version (should be set from package info)
  String currentVersion = '1.0.0';
  int currentBuildNumber = 1;

  /// Get Support Information
  /// GET /api/support (no auth)
  Future<void> getSupportInfo() async {
    try {
      isLoadingSupportInfo.value = true;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: ServerConstApis.getSupportInfo,
        method: "GET",
        // No token - public endpoint
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error loading support info: ${apiException.message}");
          }
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            supportInfo.value = SupportModel.fromJson(apiResponse.data!);

            if (kDebugMode) {
              print("Support info loaded successfully");
            }
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Exception loading support info: $e");
      }
    } finally {
      isLoadingSupportInfo.value = false;
    }
  }

  /// Check App Version
  /// GET /api/version (no auth)
  Future<void> checkVersion() async {
    try {
      isLoadingVersion.value = true;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: ServerConstApis.version,
        method: "GET",
        // No token - public endpoint
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error checking version: ${apiException.message}");
          }
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            appVersion.value = AppVersionModel.fromJson(apiResponse.data!);

            if (kDebugMode) {
              print("Version checked: ${appVersion.value?.version}");
              print("Current version: $currentVersion");
              print("Force update: ${appVersion.value?.forceUpdate}");
            }
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Exception checking version: $e");
      }
    } finally {
      isLoadingVersion.value = false;
    }
  }

  /// Launch WhatsApp
  Future<void> launchWhatsApp() async {
    if (supportInfo.value == null) return;

    try {
      final url = Uri.parse(supportInfo.value!.whatsappUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        SnackbarManager.showSnackbar('تعذر فتح واتساب');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error launching WhatsApp: $e");
      }
      SnackbarManager.showSnackbar('تعذر فتح واتساب');
    }
  }

  /// Launch Telegram
  Future<void> launchTelegram() async {
    if (supportInfo.value == null) return;

    try {
      final url = Uri.parse(supportInfo.value!.telegramUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        SnackbarManager.showSnackbar('تعذر فتح تيليجرام');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error launching Telegram: $e");
      }
      SnackbarManager.showSnackbar('تعذر فتح تيليجرام');
    }
  }

  /// Make Phone Call
  Future<void> makePhoneCall() async {
    if (supportInfo.value == null) return;

    try {
      final url = Uri.parse(supportInfo.value!.phoneCallUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        SnackbarManager.showSnackbar('تعذر إجراء المكالمة');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error making phone call: $e");
      }
      SnackbarManager.showSnackbar('تعذر إجراء المكالمة');
    }
  }

  /// Send Email
  Future<void> sendEmail() async {
    if (supportInfo.value == null) return;

    try {
      final url = Uri.parse(supportInfo.value!.emailUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        SnackbarManager.showSnackbar('تعذر فتح البريد الإلكتروني');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error sending email: $e");
      }
      SnackbarManager.showSnackbar('تعذر فتح البريد الإلكتروني');
    }
  }

  /// Open Update URL
  Future<void> openUpdateUrl() async {
    if (appVersion.value == null) return;

    try {
      final url = Uri.parse(appVersion.value!.updateUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        SnackbarManager.showSnackbar('تعذر فتح رابط التحديث');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error opening update URL: $e");
      }
      SnackbarManager.showSnackbar('تعذر فتح رابط التحديث');
    }
  }

  /// Helper: Check if update is available
  bool get isUpdateAvailable {
    if (appVersion.value == null) return false;
    return appVersion.value!.isNewerThan(currentVersion);
  }

  /// Helper: Check if force update is required
  bool get isForceUpdateRequired {
    if (appVersion.value == null) return false;
    return appVersion.value!.forceUpdate && isUpdateAvailable;
  }

  /// Helper: Check if has support info
  bool get hasSupportInfo => supportInfo.value != null;
}

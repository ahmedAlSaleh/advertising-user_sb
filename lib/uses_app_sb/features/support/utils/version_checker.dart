import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

import '../controller/support_controller.dart';
import '../view/widgets/update_dialog.dart';

/// Version Checker Utility
class VersionChecker {
  /// Check version and show dialog if update is available
  static Future<void> checkVersionOnStartup() async {
    try {
      final SupportController controller = Get.put(SupportController());

      // Check version from server
      await controller.checkVersion();

      // Wait a bit to ensure UI is ready
      await Future.delayed(const Duration(milliseconds: 500));

      // Check if update is available
      if (controller.isUpdateAvailable) {
        if (controller.isForceUpdateRequired) {
          // Force update - show non-dismissible dialog
          showUpdateDialog(isForceUpdate: true);
        } else {
          // Optional update - show dismissible dialog
          showUpdateDialog(isForceUpdate: false);
        }
      } else {
        if (kDebugMode) {
          print("App is up to date: ${controller.currentVersion}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error checking version: $e");
      }
      // Don't show error to user - version check is optional
    }
  }

  /// Set current app version (should be called once on app start)
  static void setCurrentVersion({
    required String version,
    required int buildNumber,
  }) {
    final SupportController controller = Get.put(SupportController());
    controller.currentVersion = version;
    controller.currentBuildNumber = buildNumber;
  }
}

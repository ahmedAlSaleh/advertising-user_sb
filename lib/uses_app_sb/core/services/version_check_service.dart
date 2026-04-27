import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:advertising_user/uses_app_sb/core/server/helper_api.dart';
import 'package:advertising_user/uses_app_sb/core/server/api_exception.dart';
import 'package:advertising_user/uses_app_sb/core/server/api_response.dart';
import 'package:advertising_user/uses_app_sb/core/server/server_config.dart';

class VersionCheckService {
  static Future<bool> checkVersion() async {
    try {
      // Get current app version
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      if (kDebugMode) {
        print("Current app version: $currentVersion");
      }

      // Get version from API
      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: ServerConstApis.version,
        method: "Get",
      );

      bool isUpToDate = true;

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error fetching version: ${apiException.message}");
          }
          // If error fetching version, allow user to continue
          isUpToDate = true;
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            String apiVersion = apiResponse.data!['version']?.toString() ?? '1.0.0';

            if (kDebugMode) {
              print("API version: $apiVersion");
            }

            // Compare versions
            isUpToDate = _compareVersions(currentVersion, apiVersion);

            if (kDebugMode) {
              print("Is app up to date: $isUpToDate");
            }
          }
        },
      );

      return isUpToDate;
    } catch (e) {
      if (kDebugMode) {
        print("Error checking version: $e");
      }
      // If error, allow user to continue
      return true;
    }
  }

  /// Compare two version strings
  /// Returns true if currentVersion >= apiVersion
  /// Returns false if currentVersion < apiVersion (needs update)
  static bool _compareVersions(String currentVersion, String apiVersion) {
    try {
      List<int> current = currentVersion.split('.').map((e) => int.parse(e)).toList();
      List<int> api = apiVersion.split('.').map((e) => int.parse(e)).toList();

      // Ensure both have 3 parts (major.minor.patch)
      while (current.length < 3) {
        current.add(0);
      }
      while (api.length < 3) {
        api.add(0);
      }

      // Compare major version
      if (current[0] > api[0]) return true;
      if (current[0] < api[0]) return false;

      // Compare minor version
      if (current[1] > api[1]) return true;
      if (current[1] < api[1]) return false;

      // Compare patch version
      if (current[2] >= api[2]) return true;

      return false;
    } catch (e) {
      if (kDebugMode) {
        print("Error comparing versions: $e");
      }
      // If error parsing, assume up to date
      return true;
    }
  }
}

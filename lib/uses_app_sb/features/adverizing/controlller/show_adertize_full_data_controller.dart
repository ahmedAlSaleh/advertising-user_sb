// File: advertise_controller.dart

import 'package:advertising_user/uses_app_sb/core/server/helper_api.dart';
import 'package:advertising_user/uses_app_sb/core/server/server_config.dart';
import 'package:advertising_user/uses_app_sb/core/shared/models/user.dart';
import 'package:advertising_user/uses_app_sb/features/posts/model/trader_posts.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ShowAdertizeFullDataController extends GetxController {
  Owner? owner;
  RxBool isLoading = false.obs;

  getStoreForAdvertise(int advId) async {
    try {
      isLoading.value = true; // Start loading

      // Make the API request
      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
          targetRout: '${ServerConstApis.getStoreByAdvertisement}/$advId',
          method: "Get",
          token: token);

      response.fold(
        (apiException) {
          // Handle error response
          if (kDebugMode) {
            print("Error fetching store: ${apiException.message}");
          }
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            if (kDebugMode) {
              print("Store data: ${apiResponse.data}");
              print("Advertisement ID: $advId");
            }
            // Parsing the required files from the response
            owner = Owner.fromJson(apiResponse.data!['data']);
          }
        },
      );
    } catch (e) {
      // Handle error here, e.g. showing a message or logging it
      if (kDebugMode) {
        print("Exception fetching store: $e");
      }
    } finally {
      isLoading.value = false; // End loading
    }
  }
}

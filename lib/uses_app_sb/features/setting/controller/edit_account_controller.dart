import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:advertising_user/uses_app_sb/core/server/helper_api.dart';
import 'package:advertising_user/uses_app_sb/core/server/server_config.dart';
import 'package:advertising_user/uses_app_sb/core/shared/widgets/snacl_bar/snackbar_manager.dart';

import '../../../../main.dart';
import '../../../../uses_app_sb/core/shared/models/user.dart';

class EditAccountController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    await getProfileData();
  }

  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  RxBool isLoadingProfile = true.obs;
  late GlobalKey<FormState> formstate = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  /// Get User Profile - API الجديد
  Future<void> getProfileData() async {
    try {
      isLoadingProfile.value = true;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: ServerConstApis.getProfile,
        method: "GET",
        token: token,
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error fetching profile: ${apiException.message}");
          }
          SnackbarManager.showSnackbar(
            apiException.message,
            backgroundColor: appTheme.error,
          );
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            if (kDebugMode) {
              print("Profile response: ${apiResponse.data}");
            }

            // Populate form fields with profile data
            nameController.text = apiResponse.data!['name']?.toString() ?? '';
            phoneController.text = apiResponse.data!['phone']?.toString() ?? '';
            emailController.text = apiResponse.data!['email']?.toString() ?? '';
          } else {
            SnackbarManager.showSnackbar(
              apiResponse.message ?? "Failed to load profile data",
              backgroundColor: appTheme.error,
            );
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error loading profile: $e");
      }
      SnackbarManager.showSnackbar(
        "حدث خطأ في تحميل البيانات",
        backgroundColor: appTheme.error,
      );
    } finally {
      isLoadingProfile.value = false;
    }
  }

  /// Update User Profile - API الجديد
  Future<void> onPressUpdate() async {
    try {
      FormState? formdata = formstate.currentState;
      if (formdata!.validate()) {
        formdata.save();

        isLoading.value = true;
        isError.value = false;

        final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
          targetRout: ServerConstApis.updateProfile,
          method: "POST",
          token: token,
          data: {
            'name': nameController.text,
            'email': emailController.text,
          },
        );

        response.fold(
          (apiException) {
            isLoading.value = false;
            isError.value = true;

            SnackbarManager.showSnackbar(
              apiException.message,
              backgroundColor: appTheme.error,
            );

            // عرض validation errors
            if (apiException.isValidationError && apiException.errors != null) {
              if (kDebugMode) {
                apiException.errors!.forEach((field, messages) {
                  print("$field: ${messages.join(', ')}");
                });
              }
            }
          },
          (apiResponse) {
            isLoading.value = false;

            if (apiResponse.isSuccess) {
              SnackbarManager.showSnackbar(
                apiResponse.message ?? "تم تحديث الملف الشخصي بنجاح",
              );
              Get.back();
            } else {
              isError.value = true;
              SnackbarManager.showSnackbar(
                apiResponse.message ?? "فشل التحديث",
                backgroundColor: appTheme.error,
              );
            }
          },
        );
      }
    } catch (e) {
      isError.value = true;
      isLoading.value = false;
      if (kDebugMode) {
        print("Error during update: $e");
      }
      SnackbarManager.showSnackbar(
        "حدث خطأ في التحديث",
        backgroundColor: appTheme.error,
      );
    }
  }
}

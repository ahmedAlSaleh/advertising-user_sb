import 'package:advertising_user/uses_app_sb/core/server/helper_api.dart';
import 'package:advertising_user/uses_app_sb/core/server/server_config.dart';
import 'package:advertising_user/uses_app_sb/core/shared/models/user.dart';
import 'package:advertising_user/uses_app_sb/core/shared/widgets/snacl_bar/snackbar_manager.dart';
import 'package:advertising_user/uses_app_sb/features/setting/controller/setting_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../main.dart';

class SignUpController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  late GlobalKey<FormState> formstate = GlobalKey<FormState>();
  RxBool isAgreedOn = false.obs;
  RxBool isAgreedError = false.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  /// التسجيل بالطريقة الجديدة المتوافقة مع Backend الجديد
  onPressContinue() async {
    try {
      FormState? formdata = formstate.currentState;
      if (formdata!.validate()) {
        formdata.save();
        if (!isAgreedOn.value) {
          isAgreedError.value = true;
          return;
        } else {
          isAgreedError.value = false;
        }
        isLoading.value = true;
        isError.value = false;

        // الطريقة الجديدة: استخدام ApiResponse
        final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
          targetRout: ServerConstApis.register,
          method: "POST",
          data: {
            'name': nameController.text,
            'phone': phoneController.text,
            'email': emailController.text,
            'fcm_token': 'fcmToken',
            'password': passwordController.text
          },
        );

        // معالجة النتيجة
        response.fold(
          // في حالة الخطأ
          (apiException) {
            isLoading.value = false;
            isError.value = true;

            // عرض رسالة الخطأ
            SnackbarManager.showSnackbar(
              apiException.message,
              backgroundColor: appTheme.error,
            );

            // في حالة وجود أخطاء validation، يمكن عرضها بشكل منفصل
            if (apiException.isValidationError && apiException.errors != null) {
              print("Validation errors: ${apiException.errors}");
            }
          },
          // في حالة النجاح
          (apiResponse) {
            if (apiResponse.isSuccess && apiResponse.data != null) {
              whenResponseSuccess(apiResponse.data!);
            } else {
              isLoading.value = false;
              isError.value = true;
              SnackbarManager.showSnackbar(
                apiResponse.message ?? 'حدث خطأ في التسجيل',
                backgroundColor: appTheme.error,
              );
            }
          },
        );
      }
    } catch (e) {
      print("❌ Registration Error: $e");
      isError.value = true;
      isLoading.value = false;
      SnackbarManager.showSnackbar(
        'حدث خطأ في التسجيل',
        backgroundColor: appTheme.error,
      );
    }
  }

  whenResponseSuccess(Map<String, dynamic> data) async {
    try {
      await storeService.createString('token', data['token']);
      token = data['token'];

      await storeService.createString('account_type', 'user');

      try {
        if (Get.isRegistered<SettingController>()) {
          Get.find<SettingController>().onUserLogin(token);
        }
      } catch (e) {}

      SnackbarManager.showSnackbar("تم التسجيل بنجاح");
      isLoading.value = false;
      Get.offAllNamed('/UserMainBottomNavigationBarWidget');
    } catch (e) {
      print("Error saving token: $e");
      isLoading.value = false;
      isError.value = true;
      SnackbarManager.showSnackbar("تم التسجيل لكن فشل حفظ الجلسة");
    }
  }
}

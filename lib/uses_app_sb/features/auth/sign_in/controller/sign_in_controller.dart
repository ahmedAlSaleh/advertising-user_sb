import 'package:advertising_user/uses_app_sb/core/server/helper_api.dart';
import 'package:advertising_user/uses_app_sb/core/server/server_config.dart';
import 'package:advertising_user/uses_app_sb/core/shared/models/user.dart';
import 'package:advertising_user/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/shared/widgets/snacl_bar/snackbar_manager.dart';

class SignInController extends GetxController {
  RxBool isRemmberMeActive = false.obs;
  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  late GlobalKey<FormState> formstate = GlobalKey<FormState>();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  /// تسجيل الدخول بالطريقة الجديدة المتوافقة مع Backend الجديد
  onPressContinue() async {
    FormState? formdata = formstate.currentState;
    if (formdata!.validate()) {
      formdata.save();
      try {
        isLoading.value = true;

        // الطريقة الجديدة: استخدام ApiResponse
        final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
          targetRout: ServerConstApis.login,
          method: "POST",
          data: {
            "phone": phoneController.text,
            "password": passwordController.text,
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

            // معالجة خاصة للأخطاء
            if (apiException.isAuthError) {
              print("⚠️ Authentication error - session may have expired");
            }
          },
          // في حالة النجاح
          (apiResponse) {
            // التحقق من status في الـ response
            if (apiResponse.isSuccess && apiResponse.data != null) {
              whenResponseSuccess(apiResponse.data!);
            } else {
              // في حالة status = false
              isLoading.value = false;
              isError.value = true;
              SnackbarManager.showSnackbar(
                apiResponse.message ?? 'حدث خطأ غير متوقع',
                backgroundColor: appTheme.error,
              );
            }
          },
        );
      } catch (e) {
        print("❌ Login Error: $e");
        isLoading.value = false;
        isError.value = true;
        SnackbarManager.showSnackbar(
          'حدث خطأ في تسجيل الدخول',
          backgroundColor: appTheme.error,
        );
      }
    }
  }

  whenResponseSuccess(Map<String, dynamic> data) async {
    try {
      await storeService.createString('token', data['token']);
      token = data['token'];
      await storeService.createString('account_type', 'user');
      SnackbarManager.showSnackbar("تم تسجيل الدخول بنجاح");
      isLoading.value = false;
      Get.offAllNamed('/UserMainBottomNavigationBarWidget');
    } catch (e) {
      print("Error saving token: $e");
      isLoading.value = false;
      isError.value = true;
      SnackbarManager.showSnackbar("تم تسجيل الدخول لكن فشل حفظ الجلسة");
    }
  }
}

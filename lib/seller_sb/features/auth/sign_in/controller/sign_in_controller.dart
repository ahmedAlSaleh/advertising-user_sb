import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:advertising_user/seller_sb/core/server/server_config.dart';
import 'package:advertising_user/main.dart';

import '../../../../../uses_app_sb/core/server/helper_api.dart';
import '../../../../../uses_app_sb/core/shared/models/user.dart';
import '../../../../../uses_app_sb/core/shared/widgets/snacl_bar/snackbar_manager.dart';

class SignInController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  late GlobalKey<FormState> formstate = GlobalKey<FormState>();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  /// تسجيل دخول التاجر بالطريقة الجديدة المتوافقة مع Backend الجديد
  onPressContinue() async {
    try {
      FormState? formdata = formstate.currentState;
      if (formdata!.validate()) {
        formdata.save();

        isLoading.value = true;
        isError.value = false;

        // الطريقة الجديدة: استخدام ApiResponse
        final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
          targetRout: ServerConstApis.login,
          method: "POST",
          data: {
            'phone': phoneController.text,
            'password': passwordController.text,
            'fcm_token': 'fcmToken', // يمكنك تحديثه بالـ FCM Token الفعلي
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
              print("⚠️ Authentication error - Invalid credentials");
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
      }
    } catch (e) {
      print("❌ Trader Login Error: $e");
      isError.value = true;
      isLoading.value = false;
      SnackbarManager.showSnackbar(
        'حدث خطأ في تسجيل الدخول',
        backgroundColor: appTheme.error,
      );
    }
  }

  whenResponseSuccess(Map<String, dynamic> data) async {
    try {
      await storeService.createString('token', data['token']);
      token = data['token'];
      await storeService.createString('account_type', 'seller');
      SnackbarManager.showSnackbar("تم تسجيل الدخول بنجاح");
      isLoading.value = false;
      Get.offAllNamed('/SellerMainBottomNavigationBarWidget');
    } catch (e) {
      print("Error saving token: $e");
      isLoading.value = false;
      isError.value = true;
      SnackbarManager.showSnackbar("تم تسجيل الدخول لكن فشل حفظ الجلسة");
    }
  }
}

import 'package:advertising_user/AccountService.dart';
import 'package:advertising_user/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UniversalSignInController extends GetxController {
   final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

   late GlobalKey<FormState> formstate = GlobalKey<FormState>();

  RxBool isLoading = false.obs;
  RxBool isError = false.obs;

  AccountService get accountService => AccountService.instance;

  // تسجيل الدخول
  Future<void> signIn() async {
    FormState? formdata = formstate.currentState;
    if (formdata!.validate()) {
      formdata.save();

      try {
        isLoading.value = true;
        isError.value = false;

        await _simulateSignIn();

      } catch (e) {
        isError.value = true;
        _showErrorMessage('Login failed. Please try again.'.tr);
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> _simulateSignIn() async {

    await Future.delayed(Duration(seconds: 2));

     if (phoneController.text.isNotEmpty && passwordController.text.isNotEmpty) {


      String fakeToken = 'token_${DateTime.now().millisecondsSinceEpoch}';


      String? selectedAccountType = await storeService.readString('account_type');

      if (selectedAccountType != null) {
         await accountService.login(fakeToken, selectedAccountType);
        _showSuccessMessage('Successfully logged in'.tr);
      } else {
        throw Exception('Account type not found');
      }

    } else {
      throw Exception('Invalid credentials');
    }
  }

   void _showSuccessMessage(String message) {
    Get.snackbar(
      'Success'.tr,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
  }

   void _showErrorMessage(String message) {
    Get.snackbar(
      'Error'.tr,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
      duration: Duration(seconds: 3),
    );
  }

   @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
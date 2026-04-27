import 'package:advertising_user/seller_sb/features/auth/sign_in/controller/sign_in_controller.dart';
import 'package:get/get.dart';

class SignInBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInController>(() => SignInController());
  }
}

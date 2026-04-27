import 'package:advertising_user/uses_app_sb/features/auth/sign_up/controller/sign_up_controller.dart';
import 'package:get/get.dart';

class SignUpBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignUpController>(() => SignUpController());
  }
}

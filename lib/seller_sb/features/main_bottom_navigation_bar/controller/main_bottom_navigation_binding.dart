import 'package:advertising_user/seller_sb/features/main_bottom_navigation_bar/controller/main_bottom_navigation_controller.dart';
import 'package:advertising_user/seller_sb/features/setting/controller/setting_controller.dart';

import 'package:get/get.dart';
// Import your controller

class MainBottomNavigationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainBottomNavigationController>(
        () => MainBottomNavigationController());
    Get.lazyPut<SettingController>(() => SettingController());
  }
}

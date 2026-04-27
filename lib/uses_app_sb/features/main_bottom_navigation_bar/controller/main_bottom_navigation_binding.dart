

import 'package:get/get.dart';

import '../../adverizing/controlller/advertizing_controller.dart';
import '../../setting/controller/setting_controller.dart';
import 'main_bottom_navigation_controller.dart';

class MainBottomNavigationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainBottomNavigationController>(
        () => MainBottomNavigationController());
    Get.lazyPut<AdvertiseController>(() => AdvertiseController());
    Get.lazyPut<NormalAdverizeController>(() => NormalAdverizeController());
    Get.lazyPut<SpecialAdverizeController>(() => SpecialAdverizeController());
    Get.lazyPut<SettingController>(() => SettingController());
  }
}

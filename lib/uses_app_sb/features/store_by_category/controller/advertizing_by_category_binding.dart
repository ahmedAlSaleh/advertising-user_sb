
import 'package:get/get.dart';

import 'advertizing_by_category_controller.dart';

class AdvertizingByCategoryBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StoreController>(() => StoreController());
  }
}

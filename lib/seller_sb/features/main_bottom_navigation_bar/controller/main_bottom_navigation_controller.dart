import 'package:advertising_user/seller_sb/features/adverise/show_advertise/view/advertise_screen.dart';
import 'package:advertising_user/seller_sb/features/home/view/home_screen.dart';
import 'package:advertising_user/seller_sb/features/points/my_points/view/my_points_screen.dart';
import 'package:advertising_user/seller_sb/features/posts/my_posts/view/my_posts_screen.dart';
import 'package:advertising_user/seller_sb/features/setting/view/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainBottomNavigationController extends GetxController {
  @override
  void onInit() async {
    // await startTracking();

    super.onInit();
  }

  RxInt selectedPage = 0.obs;
  final List<Widget?> lazyLoadedScreens = [
    null,
    null,
    null,
    null,
    null,
  ]; // Assuming 5 tabs

  Widget getScreen(int index) {
    if (lazyLoadedScreens[index] == null) {
      // Initialize the screen if it hasn't been initialized yet
      switch (index) {
        case 0:
          lazyLoadedScreens[index] = const HomeScreen();
          break;
        case 1:
          lazyLoadedScreens[index] = AdvertiseScreen();
          break;
        case 2:
          lazyLoadedScreens[index] = const MyPostsScreen();
          break;
        case 4:
          lazyLoadedScreens[index] = MyPointsScreen();
          break;
        case 3:
          lazyLoadedScreens[index] = const SettingScreen();


        //
        // case 3:
        //   lazyLoadedScreens[index] = MyPointsScreen();
        //   break;
        // case 4:
        //   lazyLoadedScreens[index] = const SettingScreen();
      }
    }
    return lazyLoadedScreens[index]!;
  }

  changePage(int index) {
    selectedPage.value = index;
  }

  // Clear cached screens to force rebuild (useful for theme changes)
  void clearScreenCache() {
    for (int i = 0; i < lazyLoadedScreens.length; i++) {
      lazyLoadedScreens[i] = null;
    }
  }
}

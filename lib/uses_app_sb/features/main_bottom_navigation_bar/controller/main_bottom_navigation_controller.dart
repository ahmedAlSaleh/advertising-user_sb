
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../adverizing/view/advertizing_screen.dart';
import '../../favorite/view/favorites_screen.dart';
import '../../posts/view/posts_screen.dart';
import '../../search/controller/search_controller.dart';
import '../../search/view/search_screen.dart';
import '../../setting/view/setting_screen.dart';

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
          lazyLoadedScreens[index] = const PostsScreen();
          break;
        case 1:
          lazyLoadedScreens[index] = const AdvertiseScreen();
          break;
        case 2:
          lazyLoadedScreens[index] = FavoritesScreen();
          break;
        case 3:
          lazyLoadedScreens[index] = SearchScreen();
          break;
        case 4:
          lazyLoadedScreens[index] = const SettingScreen();
      }
    }
    return lazyLoadedScreens[index]!;
  }

  changePage(int index) {
    // Note: Search controller reset removed - method doesn't exist
    // If needed in the future, add resetData() method to SearchController class
    selectedPage.value = index;
  }

  // Clear cached screens to force rebuild (useful for theme changes)
  void clearScreenCache() {
    for (int i = 0; i < lazyLoadedScreens.length; i++) {
      lazyLoadedScreens[i] = null;
    }
  }
}

import 'package:advertising_user/main.dart';
import 'package:advertising_user/uses_app_sb/features/favorite/view/widgets/favorites_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/shared/widgets/empty_data/empty_data_widget.dart';
import '../controller/favorites_controller.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the FavoritesController
    final FavoritesController favoritesController =
        Get.put(FavoritesController());

    return Scaffold(
      backgroundColor: appTheme.primaryBackground,
      body: CustomScrollView(
        slivers: [
          // Hero Header Section
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    appTheme.primary,
                    appTheme.primary.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 32.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back Button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Get.back(),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Title and Icon
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'My Favorites'.tr,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Obx(() {
                                  final count = favoritesController.favoriteItems.length;
                                  return Text(
                                    count > 0
                                        ? '$count ${count == 1 ? 'item' : 'items'}'.tr
                                        : 'Your saved items'.tr,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.85),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.favorite_rounded,
                              color: Colors.white,
                              size: 32.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Content Section
          Obx(() {
            if (favoritesController.isLoading.value) {
              // Show a loading indicator while the data is loading
              return SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(
                    color: appTheme.primary,
                  ),
                ),
              );
            } else if (favoritesController.isError.value) {
              // Use EmptyData widget to show the error message
              return SliverFillRemaining(
                child: EmptyData(
                  icon: Icons.error_outline,
                  message: 'Error loading favorites. Please try again later.'.tr,
                  onTap: favoritesController.refreshFavorites,
                ),
              );
            } else if (favoritesController.favoriteItems.isEmpty) {
              // Use EmptyData widget to show "no favorite items found"
              return SliverFillRemaining(
                child: EmptyData(
                  onTap: () {
                    favoritesController.refreshFavorites();
                  },
                  icon: Icons.favorite_border_rounded,
                  message: 'No favorite items yet.\nStart adding items you love!'.tr,
                ),
              );
            } else {
              // Display the list of favorite items in a GridView
              return SliverPadding(
                padding: EdgeInsets.all(16.w),
                sliver: SliverGrid(
                  gridDelegate: _FavoritesGridDelegate(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 0.72,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = favoritesController.favoriteItems[index];
                      return RepaintBoundary(
                        key: ValueKey(item.id),
                        child: FavoriteItemWidget(
                          item: item,
                          index: index,
                        ),
                      );
                    },
                    childCount: favoritesController.favoriteItems.length,
                  ),
                ),
              );
            }
          }),
        ],
      ),
    );
  }
}

// Cache grid delegate to avoid recreation
class _FavoritesGridDelegate extends SliverGridDelegateWithFixedCrossAxisCount {
  const _FavoritesGridDelegate({
    required super.crossAxisCount,
    required super.crossAxisSpacing,
    required super.mainAxisSpacing,
    required super.childAspectRatio,
  });
}

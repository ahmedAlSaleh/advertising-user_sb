import 'package:advertising_user/uses_app_sb/core/shared/widgets/app_bar/general_app_bar.dart';
import 'package:advertising_user/uses_app_sb/core/shared/widgets/image/logo_app_widget.dart';
import 'package:advertising_user/uses_app_sb/features/adverizing/controlller/advertizing_controller.dart';
import 'package:advertising_user/uses_app_sb/features/adverizing/model/advertise_model.dart';
import 'package:advertising_user/uses_app_sb/features/adverizing/view/widgets/carousel_banner.dart';
import 'package:advertising_user/uses_app_sb/features/adverizing/view/widgets/category.dart';
import 'package:advertising_user/uses_app_sb/features/adverizing/view/widgets/trending_sections.dart';
import 'package:advertising_user/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/shared/widgets/loaders/combined_loaders.dart';

class AdvertiseScreen extends StatelessWidget {
  const AdvertiseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AdvertiseController controller = Get.find();

    return Scaffold(
      backgroundColor: appTheme.primaryBackground,
      body: Obx(
        () {
          if (controller.isLoadingFetchingCateogires.value) {
            return const Center(
              child: GlowingBoxLoader(message: 'Loading'),
            );
          }

          if (controller.storesCategory.isEmpty) {
            return Center(
              child: Text(
                'No Categories Available',
                style: appTheme.text16.copyWith(color: appTheme.error),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
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
                      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 24.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Discover".tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            "Find amazing deals and products".tr,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          // Category Filters
                          const CategoryFilters(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Main Content
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(height: 20.h),

                    // Image Carousel Banner with shimmer effect
                    _buildImageCarouselSection(controller),

                    SizedBox(height: 32.h),

                    // For You section with shimmer effect while loading
                    _buildForYouSection(controller),

                    SizedBox(height: 32.h),

                      SectionTitle(title: 'Offer categories'.tr),
                    SizedBox(height: 16.h),

                    // Category Grid View
                    const CategoryGridView(),

                    SizedBox(height: 24.h),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Build For You section with shimmer effect while loading
  Widget _buildForYouSection(AdvertiseController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: "For You"),
        SizedBox(height: 16.0.h),
        Obx(() {
          if (controller.normalAdverizeController.isLoading.value) {
            return _buildShimmerItemList();
          } else if (controller.normalAdverizeController.itemList.isEmpty) {
            return const SizedBox(); // Don't show anything when there's no data
          } else {
            return const ItemList(); // Render the actual ItemList
          }
        }),
      ],
    );
  }

  // Build the image carousel section with shimmer effect while loading
  Widget _buildImageCarouselSection(AdvertiseController controller) {
    return Obx(() {
      if (controller.specialAdverizeController.isLoading.value) {
        return _buildShimmerCarousel();
      } else if (controller.specialAdverizeController.itemList.isEmpty) {
        return const SizedBox(); // No carousel if no data
      } else {
        return const ImageCarouselBanner(); // Render actual carousel
      }
    });
  }
}

class CategoryGridView extends StatefulWidget {
  const CategoryGridView({super.key});

  @override
  State<CategoryGridView> createState() => _CategoryGridViewState();
}

class _CategoryGridViewState extends State<CategoryGridView> {
  final AdvertiseController controller = Get.find();

  // Cache color values to avoid repeated withOpacity() calls
  late final Color _borderColor;
  late final Color _gradientStart;
  late final Color _gradientEnd;
  late final Color _iconColor;
  late final Color _overlayEnd;
  late final Color _shadowColor;

  // Cache BorderRadius values
  late final BorderRadius _outerRadius;
  late final BorderRadius _innerRadius;

  @override
  void initState() {
    super.initState();
    _borderColor = appTheme.primary.withOpacity(0.2);
    _gradientStart = appTheme.primary.withOpacity(0.3);
    _gradientEnd = appTheme.primary.withOpacity(0.15);
    _iconColor = appTheme.primary.withOpacity(0.3);
    _overlayEnd = Colors.black.withOpacity(0.6);
    _shadowColor = Colors.black.withOpacity(0.5);
    _outerRadius = BorderRadius.circular(16.r);
    _innerRadius = BorderRadius.circular(15.r);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.2,
      ),
      itemCount: controller.storesCategory.length,
      itemBuilder: (context, index) {
        final category = controller.storesCategory[index];

        return RepaintBoundary(
          child: _CategoryGridItem(
            category: category,
            borderColor: _borderColor,
            gradientStart: _gradientStart,
            gradientEnd: _gradientEnd,
            iconColor: _iconColor,
            overlayEnd: _overlayEnd,
            shadowColor: _shadowColor,
            outerRadius: _outerRadius,
            innerRadius: _innerRadius,
          ),
        );
      },
    );
  }
}

// Extracted widget for category grid item
class _CategoryGridItem extends StatelessWidget {
  final dynamic category;
  final Color borderColor;
  final Color gradientStart;
  final Color gradientEnd;
  final Color iconColor;
  final Color overlayEnd;
  final Color shadowColor;
  final BorderRadius outerRadius;
  final BorderRadius innerRadius;

  const _CategoryGridItem({
    required this.category,
    required this.borderColor,
    required this.gradientStart,
    required this.gradientEnd,
    required this.iconColor,
    required this.overlayEnd,
    required this.shadowColor,
    required this.outerRadius,
    required this.innerRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('============ CATEGORY CLICKED ============');
        print('Category ID: ${category.id}');
        print('Category Name: ${category.name}');
        print('Subcategories Count: ${category.subCategories?.length ?? 0}');
        if (category.subCategories != null &&
            category.subCategories!.isNotEmpty) {
          print('Subcategories:');
          for (var sub in category.subCategories!) {
            print('  - ID: ${sub.id}, Name: ${sub.name}');
          }
        }
        print('==========================================');

        Get.toNamed('/StoreListScreen',
            arguments: {
              'category': category,
            },
            preventDuplicates: false);
      },
      child: Container(
        decoration: BoxDecoration(
          color: appTheme.secondaryBackground,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: appTheme.primaryText.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Stack(
            children: [
              // Background with category-specific image
              _getCategoryBackground(category.name),

              // Light overlay for better text visibility (reduced opacity)
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      appTheme.primary.withOpacity(0.15),
                      appTheme.primary.withOpacity(0.05),
                    ],
                  ),
                ),
              ),

              // Icon Background Circle
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: 100.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: appTheme.primary.withOpacity(0.1),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: EdgeInsets.all(14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: appTheme.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.category_outlined,
                        size: 24.sp,
                        color: appTheme.primary,
                      ),
                    ),

                    const Spacer(),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          category.name,
                          style: TextStyle(
                            fontFamily: "NotoNaskhArabic",
                            color: appTheme.primaryBtnText,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Explore'.tr,
                              style: TextStyle(
                                color: appTheme.primary,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              Icons.arrow_forward,
                              color: appTheme.primary,
                              size: 11.sp,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to get category background based on category name
  Widget _getCategoryBackground(String categoryName) {
    String normalizedCategory = categoryName.toLowerCase().trim();

    // Check for different category types and return appropriate background
    if (normalizedCategory.contains('restaurant') ||
        normalizedCategory.contains('مطاعم') ||
        normalizedCategory.contains('مطعم')) {
      return Image.asset(
        'assets/images/222.jpg',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _getDefaultBackground(),
      );
    } else if (normalizedCategory.contains('clothing') ||
        normalizedCategory.contains('ألبسة')) {
      return Image.asset(
        'assets/images/333.jpg',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _getDefaultBackground(),
      );
    } else if (normalizedCategory.contains('shoe') ||
        normalizedCategory.contains('أحذية')) {
      return Image.asset(
        'assets/images/444.jpg',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _getDefaultBackground(),
      );
    } else if (normalizedCategory.contains('perfume') ||
        normalizedCategory.contains('عطور')) {
      return Image.asset(
        'assets/images/555.jpg',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _getDefaultBackground(),
      );
    } else if (normalizedCategory.contains('electronics') ||
        normalizedCategory.contains('إلكترونيات')) {
      return Image.asset(
        'assets/images/777.jpg',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _getDefaultBackground(),
      );
    } else if (normalizedCategory.contains('home') ||
        normalizedCategory.contains('furniture') ||
        normalizedCategory.contains('منزل') ||
        normalizedCategory.contains('أثاث')) {
      return Image.asset(
        'assets/images/888.jpg',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _getDefaultBackground(),
      );
    } else if (normalizedCategory.contains('health') ||
        normalizedCategory.contains('beauty') ||
        normalizedCategory.contains('صحة') ||
        normalizedCategory.contains('جمال')) {
      return Image.asset(
        'assets/images/999.jpg',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _getDefaultBackground(),
      );
    } else if (normalizedCategory.contains('makeup') ||
        normalizedCategory.contains('cosmetic') ||
        normalizedCategory.contains('مكياج') ||
        normalizedCategory.contains('تجميل')) {
      return Image.asset(
        'assets/images/9999.jpg',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _getDefaultBackground(),
      );
    } else if (normalizedCategory.contains('service') ||
        normalizedCategory.contains('خدمات')) {
      return Image.asset(
        'assets/images/2323.jpg',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _getDefaultBackground(),
      );
    } else if (normalizedCategory.contains('car') ||
        normalizedCategory.contains('سيارات')) {
      return Image.asset(
        'assets/images/123123.jpg',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _getDefaultBackground(),
      );
    } else if (normalizedCategory.contains('sport') ||
        normalizedCategory.contains('رياضة')) {
      return Image.asset(
        'assets/images/1212.jpg',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _getDefaultBackground(),
      );
    } else {

      return _getDefaultBackground();
    }
  }

  // Default background with app logo image
  Widget _getDefaultBackground() {
    return Image.asset(
      'assets/images/logo_app.jpg',
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // If logo_app.jpg is also not found, show gradient with logo widget
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                appTheme.primary.withOpacity(0.6),
                appTheme.primary.withOpacity(0.8),
              ],
            ),
          ),
          child: Center(
            child: Opacity(
              opacity: 0.3,
              child: logoAppWidget(size: 80),
            ),
          ),
        );
      },
    );
  }
}

// Shimmer Effect for Carousel
class _ShimmerCarousel extends StatefulWidget {
  const _ShimmerCarousel();

  @override
  State<_ShimmerCarousel> createState() => _ShimmerCarouselState();
}

class _ShimmerCarouselState extends State<_ShimmerCarousel> {
  late final Color _baseColor;
  late final Color _highlightColor;
  late final BorderRadius _radius;

  @override
  void initState() {
    super.initState();
    _baseColor = appTheme.secondaryText.withOpacity(0.3);
    _highlightColor = appTheme.secondaryText.withOpacity(0.1);
    _radius = BorderRadius.circular(10.r);
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _baseColor,
      highlightColor: _highlightColor,
      child: Container(
        height: 230.h,
        decoration: BoxDecoration(
          color: appTheme.secondaryBackground,
          borderRadius: _radius,
        ),
      ),
    );
  }
}

// Shimmer Effect for Item List (For You section)
class _ShimmerItemList extends StatefulWidget {
  const _ShimmerItemList();

  @override
  State<_ShimmerItemList> createState() => _ShimmerItemListState();
}

class _ShimmerItemListState extends State<_ShimmerItemList> {
  late final Color _baseColor;
  late final Color _highlightColor;
  late final BorderRadius _radius;

  @override
  void initState() {
    super.initState();
    _baseColor = appTheme.secondaryText.withOpacity(0.3);
    _highlightColor = appTheme.secondaryText.withOpacity(0.1);
    _radius = BorderRadius.circular(8.r);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(8.w),
            child: Shimmer.fromColors(
              baseColor: _baseColor,
              highlightColor: _highlightColor,
              child: Container(
                width: 200.w,
                height: 120.h,
                decoration: BoxDecoration(
                  color: appTheme.secondaryBackground,
                  borderRadius: _radius,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget _buildShimmerCarousel() => const _ShimmerCarousel();
Widget _buildShimmerItemList() => const _ShimmerItemList();

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 24.h,
          decoration: BoxDecoration(
            color: appTheme.primary,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          title.tr,
          style: TextStyle(
            color: appTheme.primaryText,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

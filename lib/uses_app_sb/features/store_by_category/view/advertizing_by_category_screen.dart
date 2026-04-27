
import 'package:advertising_user/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/shared/widgets/empty_data/empty_data_widget.dart';
import '../../../core/shared/widgets/image/network_image.dart';
import '../../../core/shared/widgets/loaders/combined_loaders.dart';
import '../../../core/shared/widgets/text_fields/app_text_field.dart';
import '../controller/advertizing_by_category_controller.dart';
import '../../../core/shared/models/store_category.dart';
import '../../../../seller_sb/core/shared/models/city.dart';
import '../../posts/model/trader_posts.dart';

class StoreListScreen extends StatefulWidget {
  const StoreListScreen({super.key});

  @override
  State<StoreListScreen> createState() => _StoreListScreenState();
}

class _StoreListScreenState extends State<StoreListScreen> {
  final StoreController storeController = Get.find();

  // Cache color values to avoid repeated withOpacity() calls
  late final Color _listItemBorderColor;

  // Cache BorderRadius values
  late final BorderRadius _listItemRadius;
  late final BorderRadius _imageRadius;

  @override
  void initState() {
    super.initState();
    _listItemBorderColor = appTheme.primaryText.withOpacity(0.1);
    _listItemRadius = BorderRadius.circular(12.r);
    _imageRadius = BorderRadius.circular(10.r);
  }

  @override
  Widget build(BuildContext context) {
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back Button and City Selector
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                              onPressed: () => Get.back(),
                            ),
                          ),
                          // Compact City Selector
                          Obx(() => GestureDetector(
                                onTap: () {
                                  _showCitySelectionBottomSheet(context, storeController);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.white,
                                        size: 18.sp,
                                      ),
                                      SizedBox(width: 6.w),
                                      Text(
                                        storeController.selectedCity.value?.name ??
                                            'All Cities'.tr,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 4.w),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.white,
                                        size: 20.sp,
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),

                    // Category Name
                    Padding(
                      padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            storeController.category.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            "Select one or more subcategories".tr,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),

                     Obx(() {
                      if (storeController.subCategories.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                        child: _SubCategoryFilters(
                          storeController: storeController,
                        ),
                      );
                    }),

                     Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: AppTextField(
                          hint: 'Search stores'.tr,
                          validator: (value) {
                            return null;
                          },
                          prefix: Icon(
                            Icons.search,
                            size: 22.sp,
                            color: appTheme.primary,
                          ),
                          controller: storeController.searchController,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Store List Section
          Obx(
            () {
              // If category has no subcategories, show message
              if (storeController.subCategories.isEmpty) {
                return SliverFillRemaining(
                  child: EmptyData(
                    icon: Icons.category_outlined,
                    message: 'This category has no subcategories'.tr,
                    onTap: null,
                  ),
                );
              }

              // If no subcategory is selected and subcategories exist, show message
              if (storeController.selectedSubCategories.isEmpty &&
                  storeController.subCategories.isNotEmpty) {
                return SliverFillRemaining(
                  child: EmptyData(
                    icon: Icons.category_outlined,
                    message: 'Please select one or more subcategories to view stores'.tr,
                    onTap: null,
                  ),
                );
              }

              // Loading state
              if (storeController.isLoading.value) {
                return const SliverFillRemaining(
                  child: Center(
                    child: GlowingBoxLoader(message: 'Loading'),
                  ),
                );
              }

              // Error state
              if (storeController.isError.value) {
                return SliverFillRemaining(
                  child: EmptyData(
                    icon: Icons.error_outline,
                    message: "Error fetching stores. Please try again.".tr,
                    onTap: () {
                      storeController.getStore();
                    },
                  ),
                );
              }

              // No data state
              if (storeController.data.isEmpty) {
                return SliverFillRemaining(
                  child: EmptyData(
                    icon: Icons.store_outlined,
                    message: 'No stores found in this category.'.tr,
                    onTap: () {
                      storeController.getStore();
                    },
                  ),
                );
              }

              // Data available, display the list
              return SliverPadding(
                padding: EdgeInsets.all(16.w),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final store = storeController.data[index];
                      return RepaintBoundary(
                        key: ValueKey(store.id),
                        child: _StoreListItem(
                          store: store,
                          listItemRadius: _listItemRadius,
                          listItemBorderColor: _listItemBorderColor,
                          imageRadius: _imageRadius,
                        ),
                      );
                    },
                    childCount: storeController.data.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Extract store list item as separate widget for better performance
class _StoreListItem extends StatelessWidget {
  final Store store;
  final BorderRadius listItemRadius;
  final Color listItemBorderColor;
  final BorderRadius imageRadius;

  const _StoreListItem({
    super.key,
    required this.store,
    required this.listItemRadius,
    required this.listItemBorderColor,
    required this.imageRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/StoreDetailsPage', arguments: store.id);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Store Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                  child: getImageNetwork(
                    url: store.image ?? '',
                    width: double.infinity,
                    height: 180.h,
                    fit: BoxFit.cover,
                  ),
                ),
                // Gradient Overlay
                Container(
                  height: 180.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.4),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Store Details
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Store Name
                  Text(
                    store.storeName,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: appTheme.primaryText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12.h),

                  // Owner Info
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: appTheme.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.person_outline,
                          size: 18.sp,
                          color: appTheme.primary,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          store.storeOwnerName,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: appTheme.secondaryText,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),

                  // Phone Info
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: appTheme.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.phone_outlined,
                          size: 18.sp,
                          color: appTheme.primary,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          store.storeNumber,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: appTheme.primaryText,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Arrow Icon
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: appTheme.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 14.sp,
                          color: appTheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// SubCategory Filters Widget
class _SubCategoryFilters extends StatelessWidget {
  final StoreController storeController;

  const _SubCategoryFilters({
    required this.storeController,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: storeController.subCategories.length,
        itemBuilder: (context, index) {
          final subCategory = storeController.subCategories[index];
          return _SubCategoryFilterButton(
            storeController: storeController,
            subCategory: subCategory,
            label: subCategory.name,
          );
        },
      ),
    );
  }
}

// SubCategory Filter Button Widget
class _SubCategoryFilterButton extends StatefulWidget {
  final StoreController storeController;
  final Datum subCategory;
  final String label;

  const _SubCategoryFilterButton({
    required this.storeController,
    required this.subCategory,
    required this.label,
  });

  @override
  State<_SubCategoryFilterButton> createState() =>
      _SubCategoryFilterButtonState();
}

class _SubCategoryFilterButtonState extends State<_SubCategoryFilterButton> {
  // Cache BorderRadius value
  late final BorderRadius _buttonRadius;

  @override
  void initState() {
    super.initState();
    _buttonRadius = BorderRadius.circular(25.r);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10.w),
      child: Obx(() {
        final selected =
            widget.storeController.isSubCategorySelected(widget.subCategory);
        return GestureDetector(
          onTap: () {
            print('============ SubCategory Button Clicked ============');
            print('Label: ${widget.label}');
            print('SubCategory ID: ${widget.subCategory.id}');
            print('====================================================');
            widget.storeController.toggleSubCategory(widget.subCategory);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            decoration: BoxDecoration(
              gradient: selected
                  ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  appTheme.primary,
                  appTheme.primary.withOpacity(0.85),
                ],
              )
                  : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  appTheme.alternate,
                  appTheme.alternate,
                ],
              ),
              color: selected ? null : Colors.white.withOpacity(0.2),
              borderRadius: _buttonRadius,
              border: selected
                  ? Border.all(
                      color: Colors.white,
                      width: 2,
                    )
                  : Border.all(
                color: appTheme.info,
                width: 2,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: appTheme.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        );
      }),
    );
  }
}

// City Selection Bottom Sheet
void _showCitySelectionBottomSheet(
    BuildContext context, StoreController controller) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        decoration: BoxDecoration(
          color: appTheme.secondaryBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.r),
            topRight: Radius.circular(25.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: appTheme.secondaryText.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            // Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select City'.tr,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: appTheme.primaryText,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: appTheme.secondaryText),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Divider(height: 1.h, color: appTheme.primaryText.withOpacity(0.1)),
            // City List
            Expanded(
              child: Obx(() {
                if (controller.isLoadingCities.value) {
                  return Center(
                    child: CircularProgressIndicator(color: appTheme.primary),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  itemCount: controller.cities.length + 1, // +1 for "All Cities"
                  itemBuilder: (context, index) {
                    // First item is "All Cities"
                    if (index == 0) {
                      final isSelected = controller.selectedCity.value == null;
                      return _CityListItem(
                        cityName: 'All Cities'.tr,
                        isSelected: isSelected,
                        onTap: () {
                          controller.onCityChanged(null);
                          Navigator.pop(context);
                        },
                      );
                    }

                    // Other items are cities
                    final city = controller.cities[index - 1];
                    final isSelected =
                        controller.selectedCity.value?.name == city.name;

                    return _CityListItem(
                      cityName: city.name,
                      isSelected: isSelected,
                      onTap: () {
                        controller.onCityChanged(city);
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      );
    },
  );
}

// City List Item Widget
class _CityListItem extends StatelessWidget {
  final String cityName;
  final bool isSelected;
  final VoidCallback onTap;

  const _CityListItem({
    required this.cityName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: isSelected
              ? appTheme.primary.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_city_rounded,
              color: isSelected ? appTheme.primary : appTheme.secondaryText,
              size: 22.sp,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                cityName,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? appTheme.primary : appTheme.primaryText,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: appTheme.primary,
                size: 22.sp,
              ),
          ],
        ),
      ),
    );
  }
}

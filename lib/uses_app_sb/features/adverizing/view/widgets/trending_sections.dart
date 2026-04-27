// Item Grid View Widget
import 'package:advertising_user/main.dart';
import 'package:advertising_user/uses_app_sb/features/adverizing/view/widgets/show_advertise_full_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/shared/models/user.dart';
import '../../../../core/shared/widgets/image/network_image.dart';
import '../../controlller/advertizing_controller.dart';
import '../../model/advertise_model.dart';

class ItemList extends StatelessWidget {
  const ItemList({super.key});

  @override
  Widget build(BuildContext context) {
    final NormalAdverizeController normalAdverizeController = Get.find();

    return SizedBox(
      height: 280.h, // Increased height for better card design
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: normalAdverizeController.itemList.length,
        itemBuilder: (context, index) {
          final item = normalAdverizeController.itemList[index];
          return RepaintBoundary(
            key: ValueKey(item.id),
            child: ItemCard(
              advertise: item,
              index: index,
            ),
          );
        },
      ),
    );
  }
}

class ItemCard extends StatefulWidget {
  final Advertise advertise;
  final int index; // Add the index to track the position in the list

  const ItemCard({
    super.key,
    required this.advertise,
    required this.index, // Accept the index as input
  });

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  late bool isFavorite;
  final NormalAdverizeController normalAdverizeController = Get.find();

  // Cache color values to avoid repeated withOpacity() calls
  late final Color _borderColor;

  // Cache BorderRadius values
  late final BorderRadius _containerRadius;
  late final BorderRadius _imageRadius;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.advertise.isFavorite; // Initialize the favorite status
    _borderColor = appTheme.primaryText.withOpacity(0.1);
    _containerRadius = BorderRadius.circular(8.r);
    _imageRadius = BorderRadius.circular(7.r);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.dialog(ShowAdvertiseFullDataScreen(
          advertise: widget.advertise,
        ));
      },
      child: Container(
        width: 220.w,
        margin: EdgeInsets.symmetric(horizontal: 8.w),
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with favorite button
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                  child: widget.advertise.images.isNotEmpty &&
                          widget.advertise.images.first.url.isNotEmpty
                      ? getImageNetwork(
                          url: widget.advertise.images.first.url,
                          width: 220.w,
                          height: 160.h,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 220.w,
                          height: 160.h,
                          color: appTheme.primary.withOpacity(0.05),
                          child: Icon(
                            Icons.image_outlined,
                            size: 50.sp,
                            color: appTheme.secondaryText,
                          ),
                        ),
                ),
                // Favorite button
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: GestureDetector(
                    onTap: () {
                      if (token.isEmpty) {
                        Get.snackbar(
                          "تسجيل الدخول مطلوب",
                          "يرجى تسجيل الدخول أولاً لإضافة العناصر للمفضلة",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: appTheme.error,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 3),
                        );
                        return;
                      }

                      normalAdverizeController.addToFavorite(
                        widget.advertise.id,
                        widget.index,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.advertise.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: widget.advertise.isFavorite
                            ? appTheme.error
                            : appTheme.secondaryText,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    widget.advertise.title,
                    style: TextStyle(
                      color: appTheme.primaryText,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  // Description
                  Text(
                    widget.advertise.description,
                    style: TextStyle(
                      color: appTheme.secondaryText,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  // View Details Button
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      color: appTheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'View Details'.tr,
                          style: TextStyle(
                            color: appTheme.primary,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: appTheme.primary,
                          size: 12.sp,
                        ),
                      ],
                    ),
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

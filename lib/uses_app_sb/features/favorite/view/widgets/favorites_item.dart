import 'package:advertising_user/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/shared/widgets/buttons/toggle_icon.dart';
import '../../../../core/shared/widgets/image/network_image.dart';
import '../../../adverizing/model/advertise_model.dart';
import '../../../adverizing/view/widgets/show_advertise_full_data.dart';
import '../../controller/favorites_controller.dart';

class FavoriteItemWidget extends StatelessWidget {
  final Advertise item;
  final int index;

  const FavoriteItemWidget({
    super.key,
    required this.item,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = appTheme.primaryText.withOpacity(0.1);

    // Cache border radius
    final containerRadius = BorderRadius.circular(12.r);
    final imageRadius = BorderRadius.only(
      topLeft: Radius.circular(12.r),
      topRight: Radius.circular(12.r),
    );

    return GestureDetector(
      onTap: () {
        Get.dialog(ShowAdvertiseFullDataScreen(
          advertise: item,
        ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: appTheme.secondaryBackground,
          borderRadius: containerRadius,
          border: Border.all(
            color: borderColor,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            ClipRRect(
              borderRadius: imageRadius,
              child: getImageNetwork(
                url: item.images.isNotEmpty ? item.images.first.url : '',
                width: double.infinity,
                height: 100.h,
                fit: BoxFit.cover,
              ),
            ),

            // Content section
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and favorite icon row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: appTheme.text16.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      _FavoriteToggleButton(
                        itemId: item.id,
                        index: index,
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),

                  // Description
                  Text(
                    item.description,
                    style: appTheme.text14.copyWith(
                      color: appTheme.secondaryText,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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

// Separate widget for the favorite toggle to improve performance
class _FavoriteToggleButton extends StatelessWidget {
  final int itemId;
  final int index;

  const _FavoriteToggleButton({
    required this.itemId,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return ToggleIconWithouIconButton(
      onPressed: () {
        Get.find<FavoritesController>().removeFromFavorite(itemId, index);
      },
      value: true,
      onIcon: Icon(
        Icons.favorite_sharp,
        color: appTheme.error,
        size: 25.sp,
      ),
      offIcon: Icon(
        Icons.favorite_border,
        color: appTheme.secondaryText,
        size: 25.sp,
      ),
    );
  }
}

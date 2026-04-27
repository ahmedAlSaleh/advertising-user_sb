import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
 import 'package:advertising_user/seller_sb/features/adverise/show_advertise/model/advertise_model.dart';
import 'package:advertising_user/seller_sb/features/adverise/show_advertise/view/show_advertise_full_data.dart';
import 'package:advertising_user/seller_sb/main.dart';
import 'package:advertising_user/main.dart';

import '../../../../../uses_app_sb/core/shared/widgets/image/network_image.dart';

class ItemList extends StatelessWidget {
  final List<Advertise> items;

  const ItemList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GridView.builder(
        shrinkWrap: true, // Ensures GridView takes only necessary space
        physics:
            const NeverScrollableScrollPhysics(), // Disable GridView scrolling to avoid conflict with ListView
        itemCount: items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two items per row
          crossAxisSpacing: 10.w, // Space between columns
          mainAxisSpacing: 10.h, // Space between rows
          childAspectRatio: 3 / 4, // Width to height ratio for grid items
        ),
        itemBuilder: (context, index) {
          final item = items[index];
          return ItemCard(
            advertise: item,
          );
        },
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final Advertise advertise;

  const ItemCard({
    super.key,
    required this.advertise,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.dialog(ShowAdvertiseFullDataScreen(
          advertise: advertise,
        ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: appTheme.secondaryBackground,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: appTheme.primaryText.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 120.h,
                decoration: BoxDecoration(
                  color: appTheme.secondaryBackground,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: appTheme.primaryText.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7.r),
                  child: advertise.images.isNotEmpty &&
                          advertise.images.first.url.isNotEmpty
                      ? getImageNetwork(
                          url: advertise.images.first.url,
                          width: double.infinity,
                          height: 120.h,
                          fit: BoxFit.cover,
                        )
                      : Center(
                          child: Icon(
                            Icons.image_outlined,
                            size: 50.sp,
                            color: appTheme.secondaryText,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      advertise.title,
                      style: appTheme.text14.copyWith(
                        fontWeight: FontWeight.bold,
                        color: appTheme.primaryText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Text(
                advertise.description,
                style: appTheme.text12.copyWith(
                  color: appTheme.secondaryText.withOpacity(0.8),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Text(
                "${advertise.price} ${("sp").tr}",
                style: appTheme.text14.copyWith(
                  color: appTheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

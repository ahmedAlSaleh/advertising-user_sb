import 'package:advertising_user/uses_app_sb/features/adverizing/controlller/advertizing_controller.dart';
import 'package:advertising_user/uses_app_sb/core/shared/widgets/image/network_image.dart';
import 'package:advertising_user/main.dart';
import 'package:advertising_user/uses_app_sb/features/adverizing/view/widgets/show_advertise_full_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'build_page_indecator.dart';

class ImageCarouselBanner extends StatefulWidget {
  const ImageCarouselBanner({super.key});

  @override
  State<ImageCarouselBanner> createState() => _ImageCarouselBannerState();
}

class _ImageCarouselBannerState extends State<ImageCarouselBanner> {
  final SpecialAdverizeController specialController = Get.find();

  // Cache BorderRadius value
  late final BorderRadius _imageRadius;

  @override
  void initState() {
    super.initState();
    _imageRadius = BorderRadius.circular(10.r);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final advertisements = specialController.itemList;
      return Column(
        children: [
          SizedBox(
            height: 280.h,
            child: PageView.builder(
              controller: specialController.pageController,
              itemCount: advertisements.length,
              itemBuilder: (context, index) {
                final ad = advertisements[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: RepaintBoundary(
                    key: ValueKey(ad.id),
                    child: _CarouselItem(
                      ad: ad,
                      imageRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 12.h),
          BuildPageIndecator(
            pageController: specialController.pageController,
            pageCount: specialController.itemList.length,
          )
        ],
      );
    });
  }
}

// Extracted carousel item widget
class _CarouselItem extends StatelessWidget {
  final dynamic ad;
  final BorderRadius imageRadius;

  const _CarouselItem({
    required this.ad,
    required this.imageRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.dialog(ShowAdvertiseFullDataScreen(
          advertise: ad,
        ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: appTheme.secondaryBackground,
          borderRadius: imageRadius,
          boxShadow: [
            BoxShadow(
              color: appTheme.primaryText.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: imageRadius,
          child: Stack(
            children: [
              // Image
              ad.images.isNotEmpty && ad.images.first.url.isNotEmpty
                  ? getImageNetwork(
                      url: ad.images.first.url,
                      width: double.infinity,
                      height: 280.h,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: double.infinity,
                      height: 280.h,
                      color: appTheme.secondaryBackground,
                      child: Icon(
                        Icons.image_outlined,
                        size: 60.sp,
                        color: appTheme.secondaryText,
                      ),
                    ),

              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),

              // Content
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        ad.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6.h),
                      // Description
                      Text(
                        ad.description,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),

              // Featured Badge
              Positioned(
                top: 16.h,
                right: 16.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: appTheme.primary,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: appTheme.primary.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    'Featured'.tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

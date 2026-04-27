import 'package:advertising_user/main.dart';
import 'package:advertising_user/uses_app_sb/features/adverizing/model/advertise_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/shared/widgets/image/network_image.dart';
import '../../../adverizing/view/widgets/show_advertise_full_data.dart';
import '../../controller/store_detailes.dart';

class OffersList extends StatelessWidget {
  const OffersList({super.key});

  @override
  Widget build(BuildContext context) {
    final AdverizeForStoreController adverizeForStoreController = Get.find();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(
        () => Row(
          children: [
            if (adverizeForStoreController.isLoading.value) ...[
              // Show shimmer effect while loading
              ...List.generate(
                5,
                (index) => const RepaintBoundary(
                  child: ShimmerLoadingCard(),
                ),
              ),
            ] else ...[
              // Actual content after loading
              ...List.generate(
                adverizeForStoreController.itemList.length,
                (index) => RepaintBoundary(
                  child: OfferCard(
                    advertise: adverizeForStoreController.itemList[index],
                    key: ValueKey(
                        adverizeForStoreController.itemList[index].id),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Shimmer effect card
class ShimmerLoadingCard extends StatefulWidget {
  const ShimmerLoadingCard({super.key});

  @override
  State<ShimmerLoadingCard> createState() => _ShimmerLoadingCardState();
}

class _ShimmerLoadingCardState extends State<ShimmerLoadingCard> {
  // Cache color values to avoid repeated withOpacity() calls
  late final Color _shimmerBaseColor;
  late final Color _shimmerHighlightColor;
  late final Color _borderColor;

  // Cache BorderRadius values
  late final BorderRadius _containerRadius;
  late final BorderRadius _topRadius;
  late final BorderRadius _innerRadius;

  @override
  void initState() {
    super.initState();
    _shimmerBaseColor = appTheme.secondaryText.withOpacity(0.3);
    _shimmerHighlightColor = appTheme.secondaryText.withOpacity(0.1);
    _borderColor = appTheme.primaryText.withOpacity(0.1);
    _containerRadius = BorderRadius.circular(16.r);
    _topRadius = BorderRadius.only(
      topLeft: Radius.circular(16.r),
      topRight: Radius.circular(16.r),
    );
    _innerRadius = BorderRadius.circular(4.r);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: Shimmer.fromColors(
        baseColor: _shimmerBaseColor,
        highlightColor: _shimmerHighlightColor,
        child: Container(
          width: 180.w,
          decoration: BoxDecoration(
            color: appTheme.secondaryBackground,
            borderRadius: _containerRadius,
            border: Border.all(
              color: _borderColor,
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 180.w,
                height: 120.h,
                decoration: BoxDecoration(
                  color: appTheme.secondaryBackground,
                  borderRadius: _topRadius,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120.w,
                      height: 14.h,
                      decoration: BoxDecoration(
                        color: appTheme.secondaryBackground,
                        borderRadius: _innerRadius,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: 150.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: appTheme.secondaryBackground,
                        borderRadius: _innerRadius,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      width: 100.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: appTheme.secondaryBackground,
                        borderRadius: _innerRadius,
                      ),
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
}

// Actual OfferCard
class OfferCard extends StatefulWidget {
  final Advertise advertise;

  const OfferCard({
    super.key,
    required this.advertise,
  });

  @override
  State<OfferCard> createState() => _OfferCardState();
}

class _OfferCardState extends State<OfferCard> {
  // Cache color values to avoid repeated withOpacity() calls
  late final Color _gradientSecondColor;
  late final Color _borderColor;
  late final Color _shadowColor;
  late final Color _badgeShadowColor;

  // Cache BorderRadius values
  late final BorderRadius _containerRadius;
  late final BorderRadius _topRadius;
  late final BorderRadius _badgeRadius;

  @override
  void initState() {
    super.initState();
    _gradientSecondColor = appTheme.secondaryBackground.withOpacity(0.7);
    _borderColor = appTheme.primary.withOpacity(0.2);
    _shadowColor = appTheme.primary.withOpacity(0.1);
    _badgeShadowColor = const Color(0xFFFF6B6B).withOpacity(0.4);
    _containerRadius = BorderRadius.circular(16.r);
    _topRadius = BorderRadius.only(
      topLeft: Radius.circular(16.r),
      topRight: Radius.circular(16.r),
    );
    _badgeRadius = BorderRadius.circular(20.r);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: GestureDetector(
        onTap: () {
          Get.dialog(ShowAdvertiseFullDataScreen(
            showStoreDisabled: true,
            advertise: widget.advertise,
          ));
        },
        child: Container(
          width: 180.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                appTheme.secondaryBackground,
                _gradientSecondColor,
              ],
            ),
            borderRadius: _containerRadius,
            border: Border.all(
              color: _borderColor,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _shadowColor,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: _topRadius,
                    child: widget.advertise.images.isNotEmpty
                        ? getImageNetwork(
                            url: widget.advertise.images.first.url,
                            width: 180.w,
                            height: 120.h,
                            fit: BoxFit.cover,
                          )
                        : _NoImagePlaceholder(topRadius: _topRadius),
                  ),
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFF6B6B),
                            Color(0xFFEE5A6F),
                          ],
                        ),
                        borderRadius: _badgeRadius,
                        boxShadow: [
                          BoxShadow(
                            color: _badgeShadowColor,
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.local_offer_rounded,
                            color: Colors.white,
                            size: 12.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'Offer'.tr,
                            style: appTheme.text10.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.advertise.title,
                      style: appTheme.text14.copyWith(
                        fontWeight: FontWeight.bold,
                        color: appTheme.primaryText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      widget.advertise.description,
                      style: appTheme.text12.copyWith(
                        color: appTheme.secondaryText,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(
                          Icons.visibility_rounded,
                          size: 14.sp,
                          color: appTheme.primary,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'View Details'.tr,
                          style: appTheme.text12.copyWith(
                            color: appTheme.primary,
                            fontWeight: FontWeight.w600,
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
      ),
    );
  }
}

// Extract no image placeholder as separate widget
class _NoImagePlaceholder extends StatefulWidget {
  final BorderRadius topRadius;

  const _NoImagePlaceholder({required this.topRadius});

  @override
  State<_NoImagePlaceholder> createState() => _NoImagePlaceholderState();
}

class _NoImagePlaceholderState extends State<_NoImagePlaceholder> {
  late final Color _gradientTopColor;
  late final Color _gradientBottomColor;

  @override
  void initState() {
    super.initState();
    _gradientTopColor = appTheme.primary.withOpacity(0.3);
    _gradientBottomColor = appTheme.primary.withOpacity(0.1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180.w,
      height: 120.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _gradientTopColor,
            _gradientBottomColor,
          ],
        ),
      ),
      child: Icon(
        Icons.image_not_supported_rounded,
        color: appTheme.secondaryText,
        size: 40.sp,
      ),
    );
  }
}

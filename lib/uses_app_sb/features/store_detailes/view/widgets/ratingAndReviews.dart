import 'package:advertising_user/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RatingAndReviews extends StatefulWidget {
  const RatingAndReviews({
    super.key,
    required this.storeRate,
  });

  final int storeRate;

  @override
  State<RatingAndReviews> createState() => _RatingAndReviewsState();
}

class _RatingAndReviewsState extends State<RatingAndReviews> {
  // Cache color values to avoid repeated withOpacity() calls
  late final Color _circleShadowColor;
  late final Color _ratingTextColor;
  late final Color _emptyStarColor;
  late final Color _badgeBgColor;

  // Cache BorderRadius value
  late final BorderRadius _badgeRadius;

  @override
  void initState() {
    super.initState();
    _circleShadowColor = const Color(0xFFFFD700).withOpacity(0.3);
    _ratingTextColor = Colors.white.withOpacity(0.9);
    _emptyStarColor = appTheme.secondaryText.withOpacity(0.3);
    _badgeBgColor = const Color(0xFFFFD700).withOpacity(0.2);
    _badgeRadius = BorderRadius.circular(20.r);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Row(
        children: [
          // Rating Number with Gradient Circle
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFD700),
                  Color(0xFFFFA500),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _circleShadowColor,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.storeRate.toString(),
                    style: appTheme.text26.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 32.sp,
                    ),
                  ),
                  Text(
                    'Rating'.tr,
                    style: appTheme.text10.copyWith(
                      color: _ratingTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 20.w),

          // Stars and Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Star rating display
                Row(
                  children: List.generate(
                    5,
                    (index) => Padding(
                      padding: EdgeInsets.only(right: 4.w),
                      child: Icon(
                        index < widget.storeRate
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: index < widget.storeRate
                            ? const Color(0xFFFFD700)
                            : _emptyStarColor,
                        size: 28.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),

                // Verified badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: _badgeBgColor,
                    borderRadius: _badgeRadius,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_rounded,
                        color: const Color(0xFFFFD700),
                        size: 16.sp,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Verified Store'.tr,
                        style: appTheme.text12.copyWith(
                          color: const Color(0xFFB8860B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

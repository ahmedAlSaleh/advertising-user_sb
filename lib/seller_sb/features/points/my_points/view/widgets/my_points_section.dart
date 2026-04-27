import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:advertising_user/seller_sb/features/points/my_points/model/point_model.dart';
import 'package:advertising_user/seller_sb/main.dart';
import 'package:advertising_user/main.dart';

class MyPointsSection extends StatefulWidget {
  final PointsModel pointsModel;

  const MyPointsSection({super.key, required this.pointsModel});

  @override
  State<MyPointsSection> createState() => _MyPointsSectionState();
}

class _MyPointsSectionState extends State<MyPointsSection> {
  // Cache BorderRadius value
  late final BorderRadius _containerRadius;

  @override
  void initState() {
    super.initState();
    _containerRadius = BorderRadius.circular(20.sp);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Points".tr,
          style: appTheme.text18.copyWith(
            color: appTheme.primaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: appTheme.accent4,
            borderRadius: _containerRadius,
          ),
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Points".tr,
                style: appTheme.text16.copyWith(
                  color: appTheme.primaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                widget.pointsModel.totalPoints,
                style: appTheme.text16.copyWith(
                  color: appTheme.primaryText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.pointsModel.growthRate,
                style: appTheme.text14.copyWith(
                  color: appTheme.success,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:advertising_user/seller_sb/features/points/recharge_points/controller/recharge_points_controller.dart';
import 'package:advertising_user/seller_sb/features/points/recharge_points/model/point_package_model.dart';
import 'package:advertising_user/seller_sb/main.dart';
import 'package:get/get.dart';
import 'package:advertising_user/main.dart';

import '../../../../../../uses_app_sb/core/shared/widgets/buttons/button_widget.dart';

class RechargePointsItem extends StatefulWidget {
  final PointsPackageModel package;

  const RechargePointsItem({super.key, required this.package});

  @override
  State<RechargePointsItem> createState() => _RechargePointsItemState();
}

class _RechargePointsItemState extends State<RechargePointsItem> {
  // Cache color values to avoid repeated withOpacity() calls
  late final Color _borderColor;

  // Cache BorderRadius values
  late final BorderRadius _containerRadius;
  late final BorderRadius _buttonRadius;

  @override
  void initState() {
    super.initState();
    _borderColor = appTheme.primaryText.withOpacity(0.1);
    _containerRadius = BorderRadius.circular(16.sp);
    _buttonRadius = BorderRadius.circular(16.sp);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RechargePointsController>();

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Container(
        decoration: BoxDecoration(
          color: appTheme.secondaryBackground,
          borderRadius: _containerRadius,
          border: Border.all(
            color: _borderColor,
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left section with points details
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.package.points} ${"points".tr}",
                    style: appTheme.text16.copyWith(
                      fontWeight: FontWeight.bold,
                      color: appTheme.primaryText,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "${widget.package.pricePerPoint} ${"per point".tr}",
                    style: appTheme.text14.copyWith(
                      color: appTheme.secondaryText,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    widget.package.totalPrice,
                    style: appTheme.text14.copyWith(
                      color: appTheme.primaryText,
                    ),
                  ),
                ],
              ),

              ButtonWidget(
                onPressed: () {
                  controller.buyPoints(widget.package.points);
                },
                text: 'Buy'.tr,
                showLoadingIndicator: false,
                options: ButtonOptions(
                  color: appTheme.primary,
                  textStyle: appTheme.text12.copyWith(color: Colors.white),
                  borderRadius: _buttonRadius,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

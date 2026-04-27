import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:advertising_user/seller_sb/features/points/recharge_points/controller/recharge_points_controller.dart';
import 'package:advertising_user/seller_sb/features/points/recharge_points/view/widgets/recharge_points_item.dart';

import 'package:advertising_user/main.dart';

import '../../../../../uses_app_sb/core/shared/widgets/app_bar/general_app_bar.dart';
import '../../../../../uses_app_sb/core/shared/widgets/buttons/button_widget.dart';

class RechargePointsScreen extends StatefulWidget {
  const RechargePointsScreen({super.key});

  @override
  State<RechargePointsScreen> createState() => _RechargePointsScreenState();
}

class _RechargePointsScreenState extends State<RechargePointsScreen> {
  final RechargePointsController controller =
      Get.put(RechargePointsController());

  // Cache BorderRadius value
  late final BorderRadius _buttonRadius;

  @override
  void initState() {
    super.initState();
    _buttonRadius = BorderRadius.circular(16.sp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.primaryBackground,
      appBar: generalAppBar(
        context: context,
        title: Text('Recharge points'.tr,
            style: appTheme.text18.copyWith(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // List of point packages
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: controller.pointsPackages.length,
                  itemBuilder: (context, index) {
                    final package = controller.pointsPackages[index];
                    return RepaintBoundary(
                      child: RechargePointsItem(
                        package: package,
                        key: ValueKey(package.points),
                      ),
                    );
                  },
                );
              }),
            ),

            // Add the Recharge Points button at the bottom
            Padding(
              padding: EdgeInsets.only(top: 16.h),
              child: ButtonWidget(
                onPressed: controller.rechargePoints,
                text: 'Recharge points'.tr,
                showLoadingIndicator: false,
                options: ButtonOptions(
                  width: double.infinity,
                  height: 50.h,
                  color: appTheme.primary,
                  textStyle: appTheme.text16.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  borderRadius: _buttonRadius,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

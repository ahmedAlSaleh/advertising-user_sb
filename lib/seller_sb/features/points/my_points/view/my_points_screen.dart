import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:advertising_user/seller_sb/features/points/my_points/controller/my_points_controller.dart';
import 'package:advertising_user/seller_sb/features/points/my_points/view/widgets/ads_section.dart';
import 'package:advertising_user/seller_sb/features/points/my_points/view/widgets/my_points_section.dart';
import 'package:advertising_user/seller_sb/features/points/recharge_points/view/recharge_points_secreen.dart';
import 'package:advertising_user/seller_sb/main.dart';
import 'package:advertising_user/main.dart';

import '../../../../../uses_app_sb/core/shared/widgets/app_bar/general_app_bar.dart';

class MyPointsScreen extends StatelessWidget {
  MyPointsScreen({super.key});

  final MyPointsController controller = Get.put(MyPointsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.primaryBackground,
      appBar: generalAppBar(
        context: context,
        actions: [
          TextButton.icon(
            onPressed: () {
              Get.to(() => RechargePointsScreen());
            },
            icon: Icon(Icons.account_balance_wallet,
                color: appTheme.primaryText, size: 20.sp),
            label: Text(
              "Recharge".tr,
              style: appTheme.text16.copyWith(color: appTheme.primaryText),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Obx(() => RepaintBoundary(
                  child: MyPointsSection(pointsModel: controller.pointsModel.value),
                )),
            SizedBox(height: 20.h),
            Obx(() => AdsSection(adsList: controller.adsList)),
          ],
        ),
      ),
    );
  }
}

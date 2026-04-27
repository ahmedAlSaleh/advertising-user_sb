import 'package:advertising_user/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.primaryBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hourglass_empty,
              size: 64.sp,
              color: appTheme.secondaryText,
            ),
            SizedBox(height: 16.h),
            Text(
              "Coming Soon".tr,
              style: appTheme.text18.copyWith(
                fontWeight: FontWeight.bold,
                color: appTheme.primaryText,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "This feature is under development".tr,
              style: appTheme.text14.copyWith(
                color: appTheme.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:advertising_user/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void showAuthRequiredDialog() {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: appTheme.primaryBackground,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.login,
              size: 48.sp,
              color: appTheme.primary,
            ),
            SizedBox(height: 16.h),
            Text(
              'تسجيل الدخول مطلوب'.tr,
              style: appTheme.text18.copyWith(
                fontWeight: FontWeight.bold,
                color: appTheme.primaryText,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'يرجى تسجيل الدخول أو إنشاء حساب جديد للمتابعة'.tr,
              style: appTheme.text14.copyWith(
                color: appTheme.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      Get.toNamed('/AccountTypeSelection');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appTheme.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'تسجيل'.tr,
                      style: appTheme.text14.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back();
                      Get.toNamed('/UserSignInScreen');
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: appTheme.primary,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      side: BorderSide(color: appTheme.primary, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'تسجيل الدخول'.tr,
                      style: appTheme.text14.copyWith(
                        fontWeight: FontWeight.bold,
                        color: appTheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                'إلغاء'.tr,
                style: appTheme.text14.copyWith(
                  color: appTheme.secondaryText,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: true,
  );
}

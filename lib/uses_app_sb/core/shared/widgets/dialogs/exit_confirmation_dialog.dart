import 'package:advertising_user/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Shows an exit confirmation dialog
/// Returns true if user wants to exit, false otherwise
Future<bool> showExitConfirmationDialog() async {
  final result = await Get.dialog<bool>(
    const _ExitConfirmationDialog(),
    barrierDismissible: false,
  );
  return result ?? false;
}

/// Reusable exit confirmation dialog widget
class _ExitConfirmationDialog extends StatelessWidget {
  const _ExitConfirmationDialog();

  @override
  Widget build(BuildContext context) {
    // Use theme colors for the dialog gradient
    final primaryColor = appTheme.primary;
    final secondaryColor = appTheme.secondary;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [primaryColor, secondaryColor],
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 70.w,
              height: 70.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.exit_to_app_rounded,
                size: 40.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20.h),

            // Title
            Text(
              "Exit App?".tr,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12.h),

            // Message
            Text(
              "Are you sure you want to exit the application?".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.9),
                height: 1.4,
              ),
            ),
            SizedBox(height: 30.h),

            // Buttons
            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: _DialogButton(
                    text: "Cancel".tr,
                    isPrimary: false,
                    onPressed: () => Get.back(result: false),
                  ),
                ),
                SizedBox(width: 12.w),

                // Exit Button
                Expanded(
                  child: _DialogButton(
                    text: "Exit".tr,
                    isPrimary: true,
                    primaryColor: primaryColor,
                    onPressed: () => Get.back(result: true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable dialog button widget
class _DialogButton extends StatelessWidget {
  final String text;
  final bool isPrimary;
  final Color? primaryColor;
  final VoidCallback onPressed;

  const _DialogButton({
    required this.text,
    required this.isPrimary,
    required this.onPressed,
    this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    if (isPrimary) {
      return Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryColor ?? appTheme.primary,
            ),
          ),
        ),
      );
    } else {
      return Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }
}

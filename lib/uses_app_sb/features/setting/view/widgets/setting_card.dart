import 'package:advertising_user/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/services/responsive.dart';
import '../../../../core/shared/widgets/bottom_sheet/show_bottom_sheet.dart';

class SettingCard extends StatefulWidget {
  final String title;
  final dynamic targetRout;
  final String? subString;
  final double? bottomSheetHeight;
  final IconData icon;
  final void Function()? onTap;
  final bool isDanger;

  const SettingCard({
    super.key,
    required this.title,
    required this.icon,
    this.targetRout,
    this.subString,
    this.bottomSheetHeight,
    this.onTap,
    this.isDanger = false,
  });

  @override
  State<SettingCard> createState() => _SettingCardState();
}

class _SettingCardState extends State<SettingCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final Color iconBgColor = widget.isDanger
        ? appTheme.error.withOpacity(0.1)
        : appTheme.primary.withOpacity(0.1);
    final Color iconColor = widget.isDanger ? appTheme.error : appTheme.primary;
    final Color borderColor = widget.isDanger
        ? appTheme.error.withOpacity(0.15)
        : appTheme.primaryText.withOpacity(0.08);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap ??
          () {
            widget.targetRout is String
                ? Get.toNamed(widget.targetRout)
                : showCustomBottomSheet(
                    context: context,
                    widget: widget.targetRout,
                    height: widget.bottomSheetHeight ?? screenHeight * 0.2);
          },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: appTheme.secondaryBackground,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: borderColor,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _isPressed
                  ? Colors.transparent
                  : appTheme.primaryText.withOpacity(0.04),
              blurRadius: _isPressed ? 0 : 8,
              offset: Offset(0, _isPressed ? 0 : 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left side: Icon and Title
            Expanded(
              child: Row(
                children: [
                  // Icon Container
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      widget.icon,
                      color: iconColor,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 14.w),
                  // Title
                  Expanded(
                    child: Text(
                      widget.title.tr,
                      style: TextStyle(
                        color: appTheme.primaryText,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Right side: SubString or Arrow
            widget.subString == null
                ? Icon(
                    Icons.arrow_forward_ios,
                    color: appTheme.secondaryText,
                    size: 16.sp,
                  )
                : Text(
                    widget.subString!,
                    style: TextStyle(
                      color: appTheme.secondaryText,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class ThemeSettingCard extends StatefulWidget {
  final String title;
  final bool isDarkMode;
  final ValueChanged<bool> onToggle;

  const ThemeSettingCard({
    super.key,
    required this.title,
    required this.isDarkMode,
    required this.onToggle,
  });

  @override
  State<ThemeSettingCard> createState() => _ThemeSettingCardState();
}

class _ThemeSettingCardState extends State<ThemeSettingCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: appTheme.secondaryBackground,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: appTheme.primaryText.withOpacity(0.08),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: appTheme.primaryText.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Icon and Title
          Expanded(
            child: Row(
              children: [
                // Icon Container
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: appTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    color: appTheme.primary,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 14.w),
                // Title
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      color: appTheme.primaryText,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Right side: Switch
          Switch(
            value: widget.isDarkMode,
            onChanged: widget.onToggle,
            activeColor: appTheme.primary,
          ),
        ],
      ),
    );
  }
}

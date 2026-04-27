import 'package:advertising_user/seller_sb/features/setting/view/widgets/delete_account.dart';
import 'package:advertising_user/seller_sb/features/setting/view/widgets/language_bottom_sheet.dart';
import 'package:advertising_user/seller_sb/features/setting/view/widgets/logout_confirmation_widget.dart';
import 'package:advertising_user/seller_sb/features/setting/view/widgets/setting_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:advertising_user/main.dart';

import '../../../../uses_app_sb/core/theme/app_theme.dart';
import '../../main_bottom_navigation_bar/controller/main_bottom_navigation_controller.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: appTheme.primaryBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section with Gradient
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    appTheme.primary,
                    appTheme.primary.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 40.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Settings".tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "Manage your account and preferences".tr,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Main Content
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Account Section
                  _SectionTitle(title: "Account".tr),
                  SizedBox(height: 12.h),
                  const SettingCard(
                    title: "Edit Account",
                    iconData: Icons.person_outline,
                    targetRout: '/SellerEditAccountScreen',
                  ),
                  SizedBox(height: 24.h),

                  // Preferences Section
                  _SectionTitle(title: "Preferences".tr),
                  SizedBox(height: 12.h),
                  ThemeSettingCard(
                    title: "Theme Mode".tr,
                    isDarkMode: isDarkMode,
                    onToggle: (value) {
                      try {
                        Get.find<MainBottomNavigationController>().clearScreenCache();
                      } catch (e) {
                        // Controller might not be initialized yet
                      }
                      AppTheme.toggleThemeMode();
                      MyApp.of(context).updateThemeMode();
                      Get.forceAppUpdate();
                    },
                  ),
                  SizedBox(height: 12.h),
                  SettingCard(
                    title: "Language",
                    iconData: Icons.language_outlined,
                    targetRout: LanguageBottomSheet(),
                    bottomSheetHeight: 200,
                  ),
                  SizedBox(height: 24.h),

                  // Legal Section
                  _SectionTitle(title: "Legal".tr),
                  SizedBox(height: 12.h),
                  const SettingCard(
                    title: "Privacy Policy",
                    iconData: Icons.privacy_tip_outlined,
                    targetRout: '/PrivacyPolicy',
                  ),
                  SizedBox(height: 12.h),
                  const SettingCard(
                    title: "Terms of Service",
                    iconData: Icons.description_outlined,
                    targetRout: '/TermsService',
                  ),
                  SizedBox(height: 12.h),
                  const SettingCard(
                    title: "Data Policy",
                    iconData: Icons.data_usage_outlined,
                    targetRout: '/DataPolicyScreen',
                  ),
                  SizedBox(height: 24.h),

                  // About Section
                  _SectionTitle(title: "About".tr),
                  SizedBox(height: 12.h),
                  const SettingCard(
                    title: "About Us",
                    iconData: Icons.info_outline,
                    targetRout: '/AboutUsScreen',
                  ),
                  SizedBox(height: 24.h),

                  // Danger Zone
                  _SectionTitle(title: "Danger Zone".tr, isRed: true),
                  SizedBox(height: 12.h),
                  SettingCard(
                    title: "Delete Account",
                    iconData: Icons.delete_forever_outlined,
                    bottomSheetHeight: 250,
                    targetRout: DeleteAccountWidget(),
                    isDanger: true,
                  ),
                  SizedBox(height: 12.h),
                  SettingCard(
                    title: "Log Out",
                    iconData: Icons.logout,
                    bottomSheetHeight: 200,
                    targetRout: LogoutWidget(),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final bool isRed;

  const _SectionTitle({
    required this.title,
    this.isRed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: isRed ? appTheme.error : appTheme.primary,
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }
}

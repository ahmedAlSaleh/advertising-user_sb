import 'package:advertising_user/main.dart';
import 'package:advertising_user/uses_app_sb/core/shared/functions/helper/divide.dart';
import 'package:advertising_user/uses_app_sb/features/setting/view/widgets/delete_account.dart';
import 'package:advertising_user/uses_app_sb/features/setting/view/widgets/language_bottom_sheet.dart';
import 'package:advertising_user/uses_app_sb/features/setting/view/widgets/logout_confirmation_widget.dart';
import 'package:advertising_user/uses_app_sb/features/setting/view/widgets/setting_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/shared/widgets/app_bar/general_app_bar.dart';
import '../../../core/theme/app_theme.dart';
import '../controller/setting_controller.dart';
import '../../main_bottom_navigation_bar/controller/main_bottom_navigation_controller.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    final SettingController settingController = Get.put(SettingController());

    return Scaffold(
      backgroundColor: appTheme.primaryBackground,
      body: Obx(() => _SettingsList(
            isUserLoggedIn: settingController.isUserLoggedIn.value,
          )),
    );
  }
}

class _SettingsList extends StatelessWidget {
  final bool isUserLoggedIn;

  const _SettingsList({required this.isUserLoggedIn});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        children: [
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
                // Account Section (only if not logged in)
                if (!isUserLoggedIn) ...[
                  _SectionTitle(title: "Account".tr),
                  SizedBox(height: 12.h),
                  const RepaintBoundary(
                    child: SettingCard(
                      title: "Log In",
                      targetRout: '/SignInScreen',
                      icon: Icons.login_outlined,
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],

                // Preferences Section
                _SectionTitle(title: "Preferences".tr),
                SizedBox(height: 12.h),
                RepaintBoundary(
                  child: ThemeSettingCard(
                    title: "Theme Mode".tr,
                    isDarkMode: isDarkMode,
                    onToggle: (value) {
                      try {
                        Get.find<MainBottomNavigationController>()
                            .clearScreenCache();
                      } catch (e) {
                        // Controller might not be initialized yet
                      }
                      AppTheme.toggleThemeMode();
                      MyApp.of(context).updateThemeMode();
                      Get.forceAppUpdate();
                    },
                  ),
                ),
                SizedBox(height: 12.h),
                RepaintBoundary(
                  child: SettingCard(
                    title: "Language",
                    targetRout: LanguageBottomSheet(),
                    bottomSheetHeight: 200,
                    icon: Icons.language_outlined,
                  ),
                ),
                SizedBox(height: 12.h),

                // Legal Section
                _SectionTitle(title: "Legal".tr),
                SizedBox(height: 12.h),
                const RepaintBoundary(
                  child: SettingCard(
                    title: "Privacy Policy",
                    targetRout: '/PrivacyPolicy',
                    icon: Icons.privacy_tip_outlined,
                  ),
                ),
                SizedBox(height: 12.h),
                const RepaintBoundary(
                  child: SettingCard(
                    title: "Terms of Service",
                    targetRout: '/TermsService',
                    icon: Icons.description_outlined,
                  ),
                ),
                SizedBox(height: 12.h),
                const RepaintBoundary(
                  child: SettingCard(
                    title: "Data Policy",
                    targetRout: '/DataPolicyScreen',
                    icon: Icons.data_usage_outlined,
                  ),
                ),
                SizedBox(height: 12.h),

                // About Section
                _SectionTitle(title: "About".tr),
                SizedBox(height: 12.h),
                const RepaintBoundary(
                  child: SettingCard(
                    title: "About Us",
                    targetRout: '/AboutUsScreen',
                    icon: Icons.info_outline,
                  ),
                ),
                SizedBox(height: 12.h),
                const RepaintBoundary(
                  child: SettingCard(
                    title: "App Support",
                    targetRout: '/AppSupportScreen',
                    icon: Icons.support_agent_outlined,
                  ),
                ),


                if (isUserLoggedIn) ...[
                  SizedBox(height: 12.h),
                  const RepaintBoundary(
                    child: SettingCard(
                      title: "Banned Stores",
                      targetRout: '/BlockedStoresScreen',
                      icon: Icons.block_outlined,
                    ),
                  ),
                ],
                SizedBox(height: 12.h),

                // Danger Zone (only if logged in)
                if (isUserLoggedIn) ...[
                  _SectionTitle(title: "Danger Zone".tr, isRed: true),
                  SizedBox(height: 12.h),
                  RepaintBoundary(
                    child: SettingCard(
                      title: "Delete Account",
                      icon: Icons.delete_forever_outlined,
                      bottomSheetHeight: 250,
                      targetRout: DeleteAccountWidget(),
                      isDanger: true,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  RepaintBoundary(
                    child: SettingCard(
                      title: "Log Out",
                      icon: Icons.logout,
                      bottomSheetHeight: 200,
                      targetRout: LogoutWidget(),
                    ),
                  ),
                ],
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ],
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

import 'package:advertising_user/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpdateScreen extends StatelessWidget {
  const ForceUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.primaryBackground,
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  appTheme.primary.withOpacity(0.05),
                  appTheme.primaryBackground,
                  appTheme.primary.withOpacity(0.03),
                ],
              ),
            ),
          ),

          // Decorative Circles
          Positioned(
            top: -100.h,
            right: -100.w,
            child: Container(
              width: 300.w,
              height: 300.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: appTheme.primary.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -80.h,
            left: -80.w,
            child: Container(
              width: 250.w,
              height: 250.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: appTheme.primary.withOpacity(0.06),
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Update Icon Card
                    Container(
                      width: 200.w,
                      height: 200.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            appTheme.primary,
                            appTheme.primary.withOpacity(0.8),
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: appTheme.primary.withOpacity(0.3),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Pulsing background circle
                          Container(
                            width: 140.w,
                            height: 140.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          // Icon
                          Icon(
                            Icons.system_update_alt_rounded,
                            size: 90.sp,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 48.h),

                    // Title
                    Text(
                      'Update Available'.tr,
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: appTheme.primaryText,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 16.h),

                    // Subtitle
                    Text(
                      'A new version is available!'.tr,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: appTheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 24.h),

                    // Description Card
                    Container(
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        color: appTheme.secondaryBackground,
                        borderRadius: BorderRadius.circular(24.r),
                        boxShadow: [
                          BoxShadow(
                            color: appTheme.primaryText.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'You must update the application to continue using it. This update includes important improvements and bug fixes.'.tr,
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: appTheme.secondaryText,
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 24.h),

                          // Features List
                          _FeatureItem(
                            icon: Icons.new_releases_outlined,
                            text: 'New features and improvements'.tr,
                          ),
                          SizedBox(height: 12.h),
                          _FeatureItem(
                            icon: Icons.speed_outlined,
                            text: 'Better performance'.tr,
                          ),
                          SizedBox(height: 12.h),
                          _FeatureItem(
                            icon: Icons.security_outlined,
                            text: 'Enhanced security'.tr,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 40.h),

                    // Update Button
                    GestureDetector(
                      onTap: () async {
                        await _openStore();
                      },
                      child: Container(
                        width: double.infinity,
                        height: 60.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              appTheme.primary,
                              appTheme.primary.withOpacity(0.85),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30.r),
                          boxShadow: [
                            BoxShadow(
                              color: appTheme.primary.withOpacity(0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.download_rounded,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              'Update Now'.tr,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Help Text
                    Text(
                      'This update is required to continue'.tr,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: appTheme.secondaryText.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openStore() async {
    // You can update these URLs with your actual app store links
    const String androidUrl = 'https://play.google.com/store/apps/details?id=com.yourapp.id';
    // const String iosUrl = 'https://apps.apple.com/app/idYOUR_APP_ID';

    try {
      // Check platform and open appropriate store
      // For now, we'll use a generic approach
      final Uri url = Uri.parse(androidUrl);

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // Handle error
      print('Error opening store: $e');
    }
  }
}

// Feature Item Widget
class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: appTheme.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            icon,
            size: 20.sp,
            color: appTheme.primary,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              color: appTheme.primaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Icon(
          Icons.check_circle,
          size: 20.sp,
          color: Colors.green,
        ),
      ],
    );
  }
}

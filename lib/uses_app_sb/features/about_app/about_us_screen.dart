import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:advertising_user/uses_app_sb/core/theme/app_theme.dart';
import 'package:advertising_user/main.dart';
import 'package:advertising_user/uses_app_sb/core/shared/widgets/image/logo_app_widget.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar(
        'Error'.tr,
        'Could not open link'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: appTheme.error,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    appTheme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: appTheme.primaryBackground,
      body: CustomScrollView(
        slivers: [
          // Hero Header with Gradient
          SliverToBoxAdapter(
            child: Container(
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
                  bottomLeft: Radius.circular(40.r),
                  bottomRight: Radius.circular(40.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: appTheme.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 50.h),
                  child: Column(
                    children: [
                      // Back Button
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () => Get.back(),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),

                      // Animated Logo
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: ScaleTransition(
                          scale: _fadeAnimation,
                          child: Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: logoAppWidget(size: 80),
                          ),
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Company Name with Animation
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Column(
                            children: [
                              Text(
                                'Neutron Dev',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 36.sp,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.3),
                                      offset: const Offset(0, 4),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Text(
                                  'Innovate • Create • Inspire',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.95),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Content Section
          SliverPadding(
            padding: EdgeInsets.all(24.w),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // About Section
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: appTheme.secondaryBackground,
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: appTheme.primaryText.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          size: 48.sp,
                          color: appTheme.primary,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Building the Future',
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: appTheme.primaryText,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'At Neutron Dev, we transform ideas into powerful digital solutions. Our passion for innovation drives us to create exceptional mobile and web applications that make a difference.',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: appTheme.secondaryText,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 32.h),

                // Connect With Us Title
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'Connect With Us',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: appTheme.primaryText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: 8.h),

                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'Follow us on social media for updates',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: appTheme.secondaryText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: 24.h),

                // Facebook Card
                _buildSocialMediaCard(
                  icon: FontAwesomeIcons.facebook,
                  title: 'Facebook',
                  description: 'Follow our journey',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1877F2), Color(0xFF4267B2)],
                  ),
                  url: 'https://www.facebook.com/profile.php?id=61584002096663',
                  delay: 0.2,
                ),

                SizedBox(height: 16.h),

                // Instagram Card
                _buildSocialMediaCard(
                  icon: FontAwesomeIcons.instagram,
                  title: 'Instagram',
                  description: 'See what we create',
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE1306C), Color(0xFFFD1D1D), Color(0xFFF77737)],
                  ),
                  url: 'https://www.instagram.com/dealora255/',
                  delay: 0.4,
                ),

                SizedBox(height: 40.h),

                // Footer
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: appTheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.favorite,
                          color: appTheme.error,
                          size: 24.sp,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'Made with passion by Neutron Dev',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: appTheme.secondaryText,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '© 2025 All Rights Reserved',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: appTheme.secondaryText.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20.h),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaCard({
    required IconData icon,
    required String title,
    required String description,
    required Gradient gradient,
    required String url,
    required double delay,
  }) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: GestureDetector(
        onTap: () => _launchURL(url),
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: appTheme.primaryText.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Container(
            padding: EdgeInsets.all(20.w),
            child: Row(
              children: [
                // Icon Container
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 32.sp,
                  ),
                ),

                SizedBox(width: 16.w),

                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        description,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow Icon
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

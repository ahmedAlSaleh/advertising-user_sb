import 'package:advertising_user/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/shared/widgets/image/logo_app_widget.dart';

class AppSupportScreen extends StatefulWidget {
  const AppSupportScreen({super.key});

  @override
  State<AppSupportScreen> createState() => _AppSupportScreenState();
}

class _AppSupportScreenState extends State<AppSupportScreen>
    with SingleTickerProviderStateMixin {
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

  void _copyToClipboard(String text, String message) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      'Copied'.tr,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: appTheme.primary,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.white),
                              onPressed: () => Get.back(),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),

                      // Animated Support Icon
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: ScaleTransition(
                          scale: _fadeAnimation,
                          child: Container(
                            padding: EdgeInsets.all(20.w),
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
                            child: Icon(
                              Icons.support_agent,
                              size: 60.sp,
                              color: appTheme.primary,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Title with Animation
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Column(
                            children: [
                              Text(
                                'Need Help?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32.sp,
                                  fontWeight: FontWeight.bold,
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
                              Text(
                                'We\'re here to assist you',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
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
                // Welcome Message
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
                          Icons.info_outline,
                          size: 40.sp,
                          color: appTheme.primary,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Get in Touch',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: appTheme.primaryText,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'If you encounter a problem, want to contact the development team, or need anything else, feel free to reach out to us via Facebook, Instagram, or WhatsApp. We\'re always happy to help!',
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

                // Contact Options Title
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'Contact Us',
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
                    'Choose your preferred way to connect',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: appTheme.secondaryText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: 24.h),

                // WhatsApp Card
                _buildContactCard(
                  icon: FontAwesomeIcons.whatsapp,
                  title: 'WhatsApp',
                  description: 'Chat with us instantly',
                  detail: '+963 990 437 122',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF25D366), Color(0xFF128C7E)],
                  ),
                  onTap: () => _launchURL('https://wa.me/963990437122'),
                  onLongPress: () => _copyToClipboard(
                    '+963990437122',
                    'Phone number copied to clipboard',
                  ),
                ),

                SizedBox(height: 16.h),

                // Facebook Card
                _buildContactCard(
                  icon: FontAwesomeIcons.facebook,
                  title: 'Facebook',
                  description: 'Message us on Facebook',
                  detail: 'Neutron Dev',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1877F2), Color(0xFF4267B2)],
                  ),
                  onTap: () => _launchURL(
                      'https://www.facebook.com/profile.php?id=61584002096663'),
                  onLongPress: null,
                ),

                SizedBox(height: 16.h),

                // Instagram Card
                _buildContactCard(
                  icon: FontAwesomeIcons.instagram,
                  title: 'Instagram',
                  description: 'Send us a DM',
                  detail: '@dealora255',
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFE1306C),
                      Color(0xFFFD1D1D),
                      Color(0xFFF77737)
                    ],
                  ),
                  onTap: () =>
                      _launchURL('https://www.instagram.com/dealora255/'),
                  onLongPress: null,
                ),

                SizedBox(height: 40.h),

                // Software Company Section
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          appTheme.primary.withOpacity(0.1),
                          appTheme.primary.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(
                        color: appTheme.primary.withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        // Logo
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: appTheme.primary.withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: logoAppWidget(size: 50),
                        ),

                        SizedBox(height: 16.h),

                        // Company Name
                        Text(
                          'Developed by',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: appTheme.secondaryText,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        SizedBox(height: 4.h),

                        Text(
                          'Neutron Dev',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: appTheme.primary,
                          ),
                        ),

                        SizedBox(height: 8.h),

                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: appTheme.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            'Innovate • Create • Inspire',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: appTheme.primary,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),

                        SizedBox(height: 16.h),

                        Text(
                          'Your trusted partner in digital transformation. We create innovative solutions that drive business growth.',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: appTheme.secondaryText,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 20.h),

                        // Contact Software Company Button
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                appTheme.primary,
                                appTheme.primary.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: appTheme.primary.withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () =>
                                  _launchURL('https://wa.me/963990437122'),
                              borderRadius: BorderRadius.circular(16.r),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.whatsapp,
                                      color: Colors.white,
                                      size: 20.sp,
                                    ),
                                    SizedBox(width: 12.w),
                                    Text(
                                      'Contact Neutron Dev',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 32.h),

                // Footer
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        'Response time: Usually within 24 hours',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: appTheme.secondaryText,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '© 2025 Neutron Dev. All Rights Reserved',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: appTheme.secondaryText.withOpacity(0.7),
                        ),
                      ),
                    ],
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

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String description,
    required String detail,
    required Gradient gradient,
    required VoidCallback onTap,
    VoidCallback? onLongPress,
  }) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
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
                    size: 28.sp,
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
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        description,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      if (detail.isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        Text(
                          detail,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
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

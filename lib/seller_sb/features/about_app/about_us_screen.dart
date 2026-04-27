import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:advertising_user/uses_app_sb/core/theme/app_theme.dart';
import 'package:advertising_user/main.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  // Cache BorderRadius values
  late final BorderRadius _buttonRadius;
  late final BorderRadius _serviceItemRadius;
  late final BorderRadius _iconContainerRadius;

  // Cache service items data
  late final List<_ServiceItemData> _services;
  late final List<_SocialIconData> _socialIcons;

  @override
  void initState() {
    super.initState();
    _buttonRadius = BorderRadius.circular(12.r);
    _serviceItemRadius = BorderRadius.circular(12.r);
    _iconContainerRadius = BorderRadius.circular(8.r);

    // Initialize services list
    _services = [
      _ServiceItemData(
        icon: Icons.language,
        title: 'برمجة المواقع',
        description: 'مواقع سريعة ومتجاوبة متوافقة مع جميع الاجهزة',
        color: const Color(0xFF3B82F6),
      ),
      _ServiceItemData(
        icon: Icons.mobile_friendly,
        title: 'تطوير التطبيقات',
        description: 'Android وiOS تطبيقات ذكية لمنصات',
        color: const Color(0xFF10B981),
      ),
      _ServiceItemData(
        icon: Icons.settings,
        title: 'حلول برمجية مخصصة',
        description: 'حلول تقنية مصممة خصيصاً لاحتياجات عملك',
        color: const Color(0xFF8B5CF6),
      ),
      _ServiceItemData(
        icon: Icons.trending_up,
        title: 'استراتيجيات النمو',
        description: 'استشارات تقنية وحلول مبتكرة لنمو أعمالك',
        color: const Color(0xFFF59E0B),
      ),
    ];

    // Initialize social icons list
    _socialIcons = [
      _SocialIconData(
        icon: FontAwesomeIcons.facebook,
        color: const Color(0xFF1877F2),
        url: 'https://www.facebook.com/ahmed.dose.756/',
      ),
      _SocialIconData(
        icon: FontAwesomeIcons.linkedin,
        color: const Color(0xFF0077B5),
        url: 'https://linkedin.com/in/ahmed-al-saleh-0424ba208',
      ),
    ];
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    appTheme = AppTheme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Neutron',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: appTheme.primaryBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: appTheme.primaryText),
      ),
      backgroundColor: appTheme.primaryBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Company Name & Description
            Text(
              'شريككم في التحول الرقمي والابتكار التقني',
              style: TextStyle(
                fontSize: 18.sp,
                color: appTheme.secondaryText,
                fontWeight: FontWeight.w500,
              ),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            Text(
              'حلول تقنية متكاملة ومبتكرة تساعد الشركات على النمو والتطور في العصر Neutron نقدم في الرقمي، تجمع بين الخبرة التقنية والرؤية الاستراتيجية لتقديم حلول تتجاوز توقعات عملائنا',
              style: TextStyle(
                fontSize: 14.sp,
                color: appTheme.secondaryText,
                height: 1.6,
              ),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),

            // Services
            ..._services.map((service) => _ServiceItem(
                  data: service,
                  serviceItemRadius: _serviceItemRadius,
                  iconContainerRadius: _iconContainerRadius,
                )),
            SizedBox(height: 24.h),

            // Visit Website Button
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: () => _launchURL('https://techhorizon.website/'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: appTheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: _buttonRadius,
                  ),
                ),
                child: const Text(
                  'زيارة موقعنا',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // Social Media Section
            Text(
              'تابعونا على وسائل التواصل الاجتماعي',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: appTheme.primaryText,
              ),
              textDirection: TextDirection.rtl,
            ),
            SizedBox(height: 16.h),

            // Social Media Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _socialIcons
                  .map((social) => _SocialIcon(
                        data: social,
                        onTap: _launchURL,
                      ))
                  .toList(),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

}

// Data class for service items
class _ServiceItemData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  _ServiceItemData({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}

// Data class for social icons
class _SocialIconData {
  final IconData icon;
  final Color color;
  final String url;

  _SocialIconData({
    required this.icon,
    required this.color,
    required this.url,
  });
}

// Extracted service item widget
class _ServiceItem extends StatefulWidget {
  final _ServiceItemData data;
  final BorderRadius serviceItemRadius;
  final BorderRadius iconContainerRadius;

  const _ServiceItem({
    required this.data,
    required this.serviceItemRadius,
    required this.iconContainerRadius,
  });

  @override
  State<_ServiceItem> createState() => _ServiceItemState();
}

class _ServiceItemState extends State<_ServiceItem> {
  // Cache color values to avoid repeated withOpacity() calls
  late final Color _borderColor;
  late final Color _iconBackgroundColor;

  @override
  void initState() {
    super.initState();
    _borderColor = appTheme.primaryText.withOpacity(0.1);
    _iconBackgroundColor = widget.data.color.withOpacity(0.1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: appTheme.secondaryBackground,
        borderRadius: widget.serviceItemRadius,
        border: Border.all(
          color: _borderColor,
          width: 1,
        ),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: _iconBackgroundColor,
              borderRadius: widget.iconContainerRadius,
            ),
            child: Icon(
              widget.data.icon,
              color: widget.data.color,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  widget.data.title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: appTheme.primaryText,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  widget.data.description,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: appTheme.secondaryText,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Extracted social icon widget
class _SocialIcon extends StatefulWidget {
  final _SocialIconData data;
  final Function(String) onTap;

  const _SocialIcon({
    required this.data,
    required this.onTap,
  });

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  // Cache color value to avoid repeated withOpacity() calls
  late final Color _backgroundColor;

  @override
  void initState() {
    super.initState();
    _backgroundColor = widget.data.color.withOpacity(0.1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: _backgroundColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(widget.data.icon, size: 20.sp),
        color: widget.data.color,
        onPressed: () => widget.onTap(widget.data.url),
      ),
    );
  }
}
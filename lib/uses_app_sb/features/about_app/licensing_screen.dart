import 'package:advertising_user/main.dart';
import 'package:advertising_user/uses_app_sb/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LicensingScreen extends StatefulWidget {
  const LicensingScreen({super.key});

  @override
  State<LicensingScreen> createState() => _LicensingScreenState();
}

class _LicensingScreenState extends State<LicensingScreen> {
  final List<LicensePackage> packages = [
    LicensePackage(
      name: 'Flutter SDK',
      version: '3.13.0',
      license: 'BSD-3-Clause',
      description: 'مجموعة أدوات تطوير واجهات المستخدم من Google',
    ),
    LicensePackage(
      name: 'url_launcher',
      version: '6.1.14',
      license: 'BSD-3-Clause',
      description: 'مكتبة لفتح الروابط والمواقع',
    ),
    LicensePackage(
      name: 'font_awesome_flutter',
      version: '10.5.0',
      license: 'MIT',
      description: 'مكتبة أيقونات Font Awesome',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    appTheme = AppTheme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'التراخيص',
          style: TextStyle(
            color: appTheme.primaryText,
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
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'المكتبات والتراخيص المستخدمة',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: appTheme.primaryText,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 8.h),
              Text(
                'قائمة بجميع المكتبات والحزم المستخدمة في التطبيق وتراخيصها',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: appTheme.secondaryText,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 24.h),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: packages.length,
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  return _buildPackageCard(packages[index]);
                },
              ),
              SizedBox(height: 32.h),
              _buildAboutSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPackageCard(LicensePackage package) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: appTheme.secondaryBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: appTheme.primaryText.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: appTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  package.version,
                  style: TextStyle(
                    color: appTheme.primary,
                    fontSize: 12.sp,
                  ),
                ),
              ),
              Text(
                package.name,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: appTheme.primaryText,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            package.description,
            style: TextStyle(
              fontSize: 14.sp,
              color: appTheme.secondaryText,
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                package.license,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: appTheme.secondaryText,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                ':الترخيص',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: appTheme.primaryText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: appTheme.primary,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'عن التطبيق',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'تم تطوير هذا التطبيق بواسطة فريق Neutron. جميع الحقوق محفوظة © 2024',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white70,
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '1.0.0',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white60,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                ':إصدار التطبيق',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LicensePackage {
  final String name;
  final String version;
  final String license;
  final String description;

  LicensePackage({
    required this.name,
    required this.version,
    required this.license,
    required this.description,
  });
}
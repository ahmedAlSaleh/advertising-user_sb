import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:advertising_user/uses_app_sb/core/theme/app_theme.dart';
import 'package:advertising_user/main.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  bool isEnglish = false;

  final Map<String, Map<String, String>> translations = {
    'title': {
      'ar': 'سياسة الخصوصية',
      'en': 'Privacy Policy',
    },
    'headerTitle': {
      'ar': 'سياسة الخصوصية وحماية البيانات',
      'en': 'Privacy Policy and Data Protection',
    },
    'headerDescription': {
      'ar': 'نلتزم بحماية خصوصيتك وبياناتك الشخصية. توضح هذه السياسة كيفية جمع واستخدام وحماية معلوماتك. استخدامك للتطبيق يعني موافقتك على هذه السياسة.',
      'en': 'We are committed to protecting your privacy and personal data. This policy explains how we collect, use and protect your information. Using the app means you agree to this policy.',
    },
    'lastUpdate': {
      'ar': 'آخر تحديث: 21 يناير 2024',
      'en': 'Last Updated: January 21, 2024',
    },
  };

  final List<PrivacySection> sectionsAr = [
    PrivacySection(
      title: 'معلومات نجمعها',
      content: '''
• معلومات الحساب الأساسية:
  - الاسم الكامل
  - البريد الإلكتروني
  - رقم الهاتف
  - كلمة المرور المشفرة

• بيانات الاستخدام:
  - سجل النشاط
  - الإعلانات المنشورة
  - تفضيلات البحث
• المعلومات الاختيارية:
  - الصورة الشخصية
  - الموقع الجغرافي''',
      icon: Icons.data_usage,
    ),
    PrivacySection(
      title: 'كيفية استخدام البيانات',
      content: '''
• تقديم الخدمات الأساسية:
  - إدارة حسابك
  - عرض وإدارة الإعلانات
  - التواصل معك
• تحسين الخدمات:
  - تحليل أداء التطبيق
  - تخصيص تجربة المستخدم
  - تحسين الميزات
• الأمان والحماية:
  - منع الاحتيال
  - حماية الحسابات
  - التحقق من الهوية''',
      icon: Icons.security,
    ),
    PrivacySection(
      title: 'مشاركة البيانات',
      content: '''
• لا نشارك بياناتك الشخصية مع:
  - أطراف ثالثة لأغراض تسويقية
  - شركات غير مصرح لها
• نشارك البيانات فقط:
  - بموافقتك الصريحة
  - مع مقدمي الخدمات المعتمدين
  - عند الضرورة القانونية
• التزامات المشاركة:
  - اتفاقيات سرية ملزمة
  - معايير أمان صارمة
  - رقابة مستمرة''',
      icon: Icons.share,
    ),
    PrivacySection(
      title: 'حماية البيانات',
      content: '''
• إجراءات الأمان:
  - تشفير البيانات
  - جدران حماية متقدمة
  - مراقبة مستمرة
• حذف البيانات:
  - حذف فوري عند إغلاق الحساب
  - خيار تصدير البيانات
  - لا نحتفظ بنسخ احتياطية
• معايير الامتثال:
  - GDPR متوافق مع
  - معايير حماية البيانات العالمية
  - تحديثات أمنية منتظمة''',
      icon: Icons.shield,
    ),
    PrivacySection(
      title: 'حقوق المستخدم',
      content: '''
• حقوق الوصول:
  - عرض بياناتك
  - تعديل معلوماتك
  - حذف حسابك
• التحكم في الخصوصية:
  - إعدادات الخصوصية المخصصة
  - التحكم في الإشعارات
  - إدارة الموافقات
• الموافقة المسبقة:
  - مطلوبة لإنشاء حساب
  - واضحة وصريحة
  - قابلة للإلغاء''',
      icon: Icons.person,
    ),
    PrivacySection(
      title: 'حماية الأطفال',
      content: '''
• قيود العمر:
  - حد أدنى 18 عاماً
  - التحقق من العمر
  - حظر الحسابات المخالفة
• حماية إضافية:
  - عدم جمع بيانات القاصرين
  - إجراءات حماية خاصة
  - إبلاغ فوري عن المخالفات''',
      icon: Icons.child_care,
    ),
  ];

  final List<PrivacySection> sectionsEn = [
    PrivacySection(
      title: 'Information We Collect',
      content: '''
• Basic Account Information:
  - Full Name
  - Email Address
  - Phone Number
  - Encrypted Password

• Usage Data:
  - Activity Log
  - Posted Advertisements
  - Search Preferences
• Optional Information:
  - Profile Picture
  - Geographic Location''',
      icon: Icons.data_usage,
    ),
    PrivacySection(
      title: 'How We Use Data',
      content: '''
• Core Services:
  - Account Management
  - Ad Display and Management
  - Communication
• Service Improvement:
  - App Performance Analysis
  - User Experience Customization
  - Feature Enhancement
• Security and Protection:
  - Fraud Prevention
  - Account Protection
  - Identity Verification''',
      icon: Icons.security,
    ),
    PrivacySection(
      title: 'Data Sharing',
      content: '''
• We Don't Share Your Personal Data With:
  - Third Parties for Marketing
  - Unauthorized Companies
• We Only Share Data:
  - With Your Explicit Consent
  - With Authorized Service Providers
  - When Legally Required
• Sharing Commitments:
  - Binding Confidentiality Agreements
  - Strict Security Standards
  - Continuous Monitoring''',
      icon: Icons.share,
    ),
    PrivacySection(
      title: 'Data Protection',
      content: '''
• Security Measures:
  - Data Encryption
  - Advanced Firewalls
  - Continuous Monitoring
• Data Deletion:
  - Immediate Deletion Upon Account Closure
  - Data Export Option
  - No Backups Retained
• Compliance Standards:
  - GDPR Compliant
  - Global Data Protection Standards
  - Regular Security Updates''',
      icon: Icons.shield,
    ),
    PrivacySection(
      title: 'User Rights',
      content: '''
• Access Rights:
  - View Your Data
  - Modify Information
  - Delete Account
• Privacy Controls:
  - Custom Privacy Settings
  - Notification Control
  - Consent Management
• Prior Consent:
  - Required for Account Creation
  - Clear and Explicit
  - Revocable''',
      icon: Icons.person,
    ),
    PrivacySection(
      title: 'Children\'s Protection',
      content: '''
• Age Restrictions:
  - Minimum Age 18
  - Age Verification
  - Account Ban for Violations
• Additional Protection:
  - No Minor Data Collection
  - Special Protection Measures
  - Immediate Violation Reporting''',
      icon: Icons.child_care,
    ),
  ];

  String getTranslation(String key) {
    return translations[key]?[isEnglish ? 'en' : 'ar'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    appTheme = AppTheme.of(context);
    return Scaffold(
      backgroundColor: appTheme.primaryBackground,
      appBar: AppBar(
        title: Text(
          getTranslation('title'),
          style: TextStyle(
            color: appTheme.primaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: appTheme.primaryBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: appTheme.primaryText),
        actions: [
          IconButton(
            icon: Icon(Icons.language, color: appTheme.primaryText),
            onPressed: () {
              setState(() {
                isEnglish = !isEnglish;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: isEnglish ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              Text(
                getTranslation('headerTitle'),
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: appTheme.primaryText,
                ),
                textAlign: isEnglish ? TextAlign.left : TextAlign.right,
              ),
              SizedBox(height: 8.h),
              Text(
                getTranslation('headerDescription'),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: appTheme.secondaryText,
                ),
                textAlign: isEnglish ? TextAlign.left : TextAlign.right,
                textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
              ),
              SizedBox(height: 8.h),
              Text(
                getTranslation('lastUpdate'),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: appTheme.secondaryText,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: isEnglish ? TextAlign.left : TextAlign.right,
              ),
              SizedBox(height: 24.h),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: isEnglish ? sectionsEn.length : sectionsAr.length,
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  return _buildPrivacySection(
                    isEnglish ? sectionsEn[index] : sectionsAr[index],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacySection(PrivacySection section) {
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
        crossAxisAlignment: isEnglish ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: isEnglish ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              if (!isEnglish) ...[
                Expanded(
                  child: Text(
                    section.title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: appTheme.primaryText,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBox(width: 12.w),
              ],
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: appTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  section.icon,
                  color: appTheme.primary,
                  size: 24.sp,
                ),
              ),
              if (isEnglish) ...[
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    section.title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: appTheme.primaryText,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            section.content,
            style: TextStyle(
              fontSize: 14.sp,
              color: appTheme.secondaryText,
              height: 1.6,
            ),
            textAlign: isEnglish ? TextAlign.left : TextAlign.right,
            textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
          ),
        ],
      ),
    );
  }
}

class PrivacySection {
  final String title;
  final String content;
  final IconData icon;

  PrivacySection({
    required this.title,
    required this.content,
    required this.icon,
  });
}
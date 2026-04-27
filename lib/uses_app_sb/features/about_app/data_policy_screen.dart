import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:advertising_user/uses_app_sb/core/theme/app_theme.dart';
import 'package:advertising_user/main.dart';

class DataPolicyScreen extends StatefulWidget {
  const DataPolicyScreen({super.key});

  @override
  State<DataPolicyScreen> createState() => _DataPolicyScreenState();
}

class _DataPolicyScreenState extends State<DataPolicyScreen> {
  bool isEnglish = false;

  final Map<String, Map<String, String>> translations = {
    'title': {
      'ar': 'سياسة البيانات',
      'en': 'Data Policy',
    },
    'headerTitle': {
      'ar': 'نحن نهتم بخصوصيتك',
      'en': 'We Care About Your Privacy',
    },
    'headerDescription': {
      'ar': 'نلتزم بحماية بياناتك الشخصية وضمان خصوصيتك. تشرح هذه السياسة كيفية جمع واستخدام وحماية معلوماتك.',
      'en': 'We are committed to protecting your personal data and ensuring your privacy. This policy explains how we collect, use, and protect your information.',
    },
    'contactTitle': {
      'ar': 'تواصل معنا',
      'en': 'Contact Us',
    },
    'contactDescription': {
      'ar': 'إذا كان لديك أي أسئلة حول سياسة البيانات، يرجى التواصل معنا عبر البريد الإلكتروني:',
      'en': 'If you have any questions about the data policy, please contact us via email:',
    },
  };

  final List<PolicySection> sectionsAr = [
    PolicySection(
      title: 'البيانات التي نجمعها',
      content: '''
• معلومات الحساب: الاسم، البريد الإلكتروني، رقم الهاتف
• معلومات الملف الشخصي: الصورة الشخصية (اختياري)
• بيانات الإعلانات: تفاصيل الإعلانات المنشورة والمعروضة
• بيانات الموقع: الموقع الجغرافي لعرض الإعلانات المناسبة
• بيانات التصفح: تفضيلات البحث وسجل التصفح
• معلومات الجهاز: نوع الجهاز ونظام التشغيل''',
      icon: Icons.folder_shared,
    ),
    PolicySection(
      title: 'كيف نستخدم بياناتك',
      content: '''
• تحسين تجربة المستخدم وتخصيص المحتوى
• إدارة حسابك وتوفير الدعم الفني
• عرض إعلانات مخصصة ومناسبة لاهتماماتك
• إرسال تحديثات وإشعارات مهمة
• تحليل استخدام التطبيق وتحسين خدماتنا
• التواصل معك بخصوص الإعلانات والخدمات''',
      icon: Icons.security,
    ),
    PolicySection(
      title: 'حماية البيانات',
      content: '''
• تشفير جميع البيانات الشخصية
• تخزين آمن على خوادم محمية
• مراقبة مستمرة لأنظمة الأمان
• تحديثات دورية لإجراءات الحماية
• نظام تحقق متعدد العوامل
• مراجعة دورية لسياسات الأمان''',
      icon: Icons.shield,
    ),
    PolicySection(
      title: 'مشاركة البيانات',
      content: '''
• لا نشارك بياناتك مع أطراف ثالثة دون موافقتك
• نشارك فقط البيانات الضرورية لتقديم الخدمة
• يمكنك التحكم في إعدادات الخصوصية من حسابك
• نلتزم بقوانين حماية البيانات المحلية والدولية''',
      icon: Icons.share,
    ),
    PolicySection(
      title: 'حقوقك',
      content: '''
• الوصول إلى بياناتك الشخصية
• تحديث أو تصحيح معلوماتك
• طلب حذف حسابك وبياناتك
• الاعتراض على معالجة بياناتك
• تحكم كامل في إعدادات الخصوصية
• إمكانية تصدير بياناتك''',
      icon: Icons.gavel,
    ),
  ];

  final List<PolicySection> sectionsEn = [
    PolicySection(
      title: 'Data We Collect',
      content: '''
• Account Information: Name, email, phone number
• Profile Information: Profile picture (optional)
• Advertisement Data: Details of posted and viewed ads
• Location Data: Geographic location for relevant ads
• Browsing Data: Search preferences and history
• Device Information: Device type and operating system''',
      icon: Icons.folder_shared,
    ),
    PolicySection(
      title: 'How We Use Your Data',
      content: '''
• Improving user experience and customizing content
• Managing your account and providing technical support
• Displaying personalized and relevant advertisements
• Sending important updates and notifications
• Analyzing app usage and improving our services
• Communicating about ads and services''',
      icon: Icons.security,
    ),
    PolicySection(
      title: 'Data Protection',
      content: '''
• Encryption of all personal data
• Secure storage on protected servers
• Continuous security system monitoring
• Regular security procedure updates
• Multi-factor authentication system
• Regular security policy reviews''',
      icon: Icons.shield,
    ),
    PolicySection(
      title: 'Data Sharing',
      content: '''
• We don't share your data with third parties without consent
• We only share necessary data for service provision
• You can control privacy settings from your account
• We comply with local and international data protection laws''',
      icon: Icons.share,
    ),
    PolicySection(
      title: 'Your Rights',
      content: '''
• Access to your personal data
• Update or correct your information
• Request account and data deletion
• Object to data processing
• Full control over privacy settings
• Ability to export your data''',
      icon: Icons.gavel,
    ),
  ];

  String getTranslation(String key) {
    return translations[key]?[isEnglish ? 'en' : 'ar'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    appTheme = AppTheme.of(context);
    return Scaffold(
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
      backgroundColor: appTheme.primaryBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: isEnglish ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            // Header
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
            SizedBox(height: 24.h),

            // Policy Sections
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: isEnglish ? sectionsEn.length : sectionsAr.length,
              separatorBuilder: (context, index) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                return _buildPolicySection(
                  isEnglish ? sectionsEn[index] : sectionsAr[index],
                );
              },
            ),
            SizedBox(height: 24.h),

            // Contact Section
            _buildContactSection(),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicySection(PolicySection section) {
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

  Widget _buildContactSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: appTheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: isEnglish ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Text(
            getTranslation('contactTitle'),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: appTheme.primaryText,
            ),
            textAlign: isEnglish ? TextAlign.left : TextAlign.right,
          ),
          SizedBox(height: 8.h),
          Text(
            getTranslation('contactDescription'),
            style: TextStyle(
              fontSize: 14.sp,
              color: appTheme.secondaryText,
            ),
            textAlign: isEnglish ? TextAlign.left : TextAlign.right,
            textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
          ),
          SizedBox(height: 12.h),
          Text(
            'privacy@techhorizon.website',
            style: TextStyle(
              fontSize: 14.sp,
              color: appTheme.primary,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}

class PolicySection {
  final String title;
  final String content;
  final IconData icon;

  PolicySection({
    required this.title,
    required this.content,
    required this.icon,
  });
}
import 'package:advertising_user/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:advertising_user/uses_app_sb/core/theme/app_theme.dart';

class TermsService extends StatefulWidget {
  const TermsService({super.key});

  @override
  State<TermsService> createState() => _TermsServiceState();
}

class _TermsServiceState extends State<TermsService> {
  bool isEnglish = false;

  final Map<String, Map<String, String>> translations = {
    'title': {
      'ar': 'شروط الخدمة',
      'en': 'Terms of Service',
    },
    'headerTitle': {
      'ar': 'شروط وأحكام استخدام التطبيق',
      'en': 'App Terms and Conditions',
    },
    'headerDescription': {
      'ar':
          'يرجى قراءة هذه الشروط بعناية قبل استخدام التطبيق. باستخدامك للتطبيق، فإنك توافق على الالتزام بهذه الشروط.',
      'en':
          'Please read these terms carefully before using the app. By using the app, you agree to be bound by these terms.',
    },
    'lastUpdate': {
      'ar': 'آخر تحديث: 21 يناير 2024',
      'en': 'Last Updated: January 21, 2024',
    },
  };

  final List<TermSection> sectionsAr = [
    TermSection(
      title: 'شروط الاستخدام',
      content: '''
• يجب أن يكون عمرك 18 عاماً أو أكثر لاستخدام التطبيق
• يجب استخدام معلومات صحيحة عند التسجيل
• يحظر استخدام التطبيق لأي أغراض غير مشروعة
• يجب احترام حقوق الملكية الفكرية
• يحق لنا تعليق أو إنهاء حسابك في حالة مخالفة الشروط''',
      icon: Icons.rule,
    ),
    TermSection(
      title: 'المحتوى والإعلانات',
      content: '''
• يجب أن يكون المحتوى المنشور قانونياً ولائقاً
• يحظر نشر إعلانات مضللة أو احتيالية
• نحتفظ بحق إزالة أي محتوى مخالف
• يجب احترام حقوق الآخرين عند النشر
• المستخدم مسؤول عن المحتوى الذي ينشره''',
      icon: Icons.content_paste,
    ),
    TermSection(
      title: 'المدفوعات والرسوم',
      content: '''
• قد تتطلب بعض الخدمات رسوماً
• جميع المدفوعات نهائية وغير قابلة للاسترداد
• نحتفظ بحق تغيير الأسعار
• يتم توضيح الرسوم قبل إتمام أي عملية
• يجب الالتزام بسياسة الدفع المحددة''',
      icon: Icons.payment,
    ),
    TermSection(
      title: 'الملكية الفكرية',
      content: '''
• جميع حقوق الملكية الفكرية محفوظة
• يحظر نسخ أو تعديل محتوى التطبيق
• العلامات التجارية والشعارات محمية
• المستخدم يحتفظ بحقوق محتواه الخاص
• يمنح المستخدم التطبيق ترخيصاً لعرض محتواه''',
      icon: Icons.copyright,
    ),
    TermSection(
      title: 'تحديث الشروط',
      content: '''
• نحتفظ بحق تحديث هذه الشروط
• سيتم إخطار المستخدمين بالتغييرات المهمة
• استمرار استخدام التطبيق يعني قبول التحديثات
• يمكن مراجعة الشروط في أي وقت
• التحديثات تدخل حيز التنفيذ فور نشرها''',
      icon: Icons.update,
    ),
  ];

  final List<TermSection> sectionsEn = [
    TermSection(
      title: 'Terms of Use',
      content: '''
• You must be 18 years or older to use the app
• You must provide accurate information when registering
• The app must not be used for illegal purposes
• Intellectual property rights must be respected
• We reserve the right to suspend or terminate your account for violations''',
      icon: Icons.rule,
    ),
    TermSection(
      title: 'Content and Advertisements',
      content: '''
• Posted content must be legal and appropriate
• Misleading or fraudulent ads are prohibited
• We reserve the right to remove any violating content
• Respect others' rights when posting
• Users are responsible for their posted content''',
      icon: Icons.content_paste,
    ),
    TermSection(
      title: 'Payments and Fees',
      content: '''
• Some services may require fees
• All payments are final and non-refundable
• We reserve the right to change prices
• Fees are disclosed before completing transactions
• Users must comply with payment policy''',
      icon: Icons.payment,
    ),
    TermSection(
      title: 'Intellectual Property',
      content: '''
• All intellectual property rights are reserved
• Copying or modifying app content is prohibited
• Trademarks and logos are protected
• Users retain rights to their own content
• Users grant the app license to display their content''',
      icon: Icons.copyright,
    ),
    TermSection(
      title: 'Terms Updates',
      content: '''
• We reserve the right to update these terms
• Users will be notified of significant changes
• Continued use means acceptance of updates
• Terms can be reviewed at any time
• Updates are effective immediately upon posting''',
      icon: Icons.update,
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
        surfaceTintColor: appTheme.primaryBackground,
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
            crossAxisAlignment:
                isEnglish ? CrossAxisAlignment.start : CrossAxisAlignment.end,
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
                  return _buildTermSection(
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

  Widget _buildTermSection(TermSection section) {
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
        crossAxisAlignment:
            isEnglish ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment:
                isEnglish ? MainAxisAlignment.start : MainAxisAlignment.end,
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

class TermSection {
  final String title;
  final String content;
  final IconData icon;

  TermSection({
    required this.title,
    required this.content,
    required this.icon,
  });
}

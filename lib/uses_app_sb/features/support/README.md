# Support & Version System

نظام الدعم وفحص الإصدار في التطبيق.

## المميزات

### 1. معلومات الدعم (Contact Us)
- رقم الهاتف (قابل للنقر والنسخ)
- البريد الإلكتروني
- واتساب (يفتح التطبيق)
- تيليجرام
- أوقات العمل

### 2. فحص الإصدار (Version Check)
- فحص تلقائي عند بدء التطبيق
- تحديث إجباري (Force Update)
- تحديث اختياري (Optional Update)
- رابط متجر التطبيقات

## الاستخدام

### في main.dart

```dart
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'uses_app_sb/features/support/utils/version_checker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get package info
  final packageInfo = await PackageInfo.fromPlatform();

  // Set current version
  VersionChecker.setCurrentVersion(
    version: packageInfo.version,
    buildNumber: int.parse(packageInfo.buildNumber),
  );

  runApp(MyApp());
}
```

### في Splash Screen أو Home Screen

```dart
@override
void initState() {
  super.initState();

  // Check version on startup
  VersionChecker.checkVersionOnStartup();
}
```

### فتح شاشة تواصل معنا

```dart
import 'uses_app_sb/features/support/view/contact_us_screen.dart';

// Navigate to contact us
Get.to(() => const ContactUsScreen());
```

### فحص الإصدار يدوياً

```dart
import 'uses_app_sb/features/support/controller/support_controller.dart';
import 'uses_app_sb/features/support/view/widgets/update_dialog.dart';

final controller = Get.put(SupportController());

// Check version
await controller.checkVersion();

// Show dialog if update available
if (controller.isUpdateAvailable) {
  showUpdateDialog(
    isForceUpdate: controller.isForceUpdateRequired,
  );
}
```

## البيانات المطلوبة من الـ API

### GET /api/support
```json
{
  "status": true,
  "data": {
    "phone": "07701234567",
    "email": "support@example.com",
    "whatsapp": "07701234567",
    "telegram": "@support",
    "working_hours": "السبت - الخميس: 9:00 صباحاً - 9:00 مساءً"
  }
}
```

### GET /api/version
```json
{
  "status": true,
  "data": {
    "version": "1.0.0",
    "build_number": 1,
    "force_update": false,
    "update_url": "https://play.google.com/store/apps/details?id=com.example.app"
  }
}
```

## Dependencies المطلوبة

في `pubspec.yaml`:

```yaml
dependencies:
  url_launcher: ^6.2.0
  package_info_plus: ^5.0.1
```

## ملاحظات

1. **Force Update**: عندما `force_update = true`، لا يمكن للمستخدم إغلاق النافذة
2. **Optional Update**: يمكن للمستخدم اختيار "لاحقاً"
3. **Version Comparison**: يتم مقارنة الإصدارات بناءً على format `X.Y.Z`
4. **No Token Required**: جميع الـ APIs عامة ولا تحتاج token

## الملفات

### Models
- `support_model.dart` - SupportModel & AppVersionModel

### Controller
- `support_controller.dart` - SupportController

### Views
- `contact_us_screen.dart` - شاشة تواصل معنا
- `widgets/update_dialog.dart` - نافذة التحديث

### Utils
- `version_checker.dart` - VersionChecker utility

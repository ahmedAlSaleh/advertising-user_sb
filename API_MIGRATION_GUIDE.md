# دليل الانتقال إلى API الجديد
## Migration Guide for New Backend API Format

---

## 📋 نظرة عامة

تم تحديث التطبيق ليتوافق مع شكل Response الجديد من Backend:

```json
{
  "status": true/false,
  "message": "رسالة النجاح أو الخطأ",
  "data": {...}
}
```

---

## ✅ الملفات التي تم إنشاؤها

### 1. **api_response.dart**
Model موحد للـ Response من الـ Backend:
- `status`: bool - حالة العملية
- `message`: String? - رسالة من السيرفر
- `data`: T? - البيانات المرجعة

**الموقع:** `lib/uses_app_sb/core/server/api_response.dart`

### 2. **api_exception.dart**
Exception موحد لمعالجة الأخطاء:
- `message`: رسالة الخطأ
- `statusCode`: HTTP Status Code
- `errors`: أخطاء التحقق (Validation Errors)

**الموقع:** `lib/uses_app_sb/core/server/api_exception.dart`

---

## 🔄 الملفات المحدثة

### 1. **helper_api.dart**
تم تحديث `ApiHelper.makeRequest` ليرجع:
```dart
Future<Either<ApiException, ApiResponse<T>>> makeRequest<T>({...})
```

**الموقع:** `lib/uses_app_sb/core/server/helper_api.dart`

### 2. **server_config.dart**
تم تحديث Base URL:
```dart
static String baseAPI = 'http://localhost:8000/api';
```

**ملاحظة:** للاستخدام على أجهزة حقيقية أو الإنتاج:
- Android Emulator: `http://10.0.2.2:8000/api`
- Production: `https://myadvertisement.shop/api`

**الموقع:** `lib/uses_app_sb/core/server/server_config.dart`

### 3. **parse_response.dart**
تم وضع علامة `@Deprecated` على `ErrorResponse` و `ValidationError` (محفوظة للتوافق مع الكود القديم).

**الموقع:** `lib/uses_app_sb/core/server/parse_response.dart`

---

## 📝 كيفية تحديث Controllers

### الطريقة القديمة ❌

```dart
Either<ErrorResponse, Map<String, dynamic>> response;

response = await ApiHelper.makeRequest(
  targetRout: ServerConstApis.login,
  method: "Post",
  data: {...}
);

dynamic handlingResponse = response.fold((l) => l, (r) => r);

if (handlingResponse is ErrorResponse) {
  // معالجة الخطأ
  SnackbarManager.showSnackbar(handlingResponse.message!);
} else {
  // معالجة النجاح
  whenResponseSuccess(handlingResponse);
}
```

### الطريقة الجديدة ✅

```dart
final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
  targetRout: ServerConstApis.login,
  method: "POST",  // ⚠️ استخدم الأحرف الكبيرة
  data: {...},
);

response.fold(
  // في حالة الخطأ (ApiException)
  (apiException) {
    isLoading.value = false;
    isError.value = true;

    // عرض رسالة الخطأ
    SnackbarManager.showSnackbar(
      apiException.message,
      backgroundColor: appTheme.error,
    );

    // معالجة خاصة حسب نوع الخطأ
    if (apiException.isAuthError) {
      // انتهت الجلسة - اطلب تسجيل دخول
      print("⚠️ Session expired");
    } else if (apiException.isValidationError) {
      // أخطاء في البيانات المدخلة
      print("Validation errors: ${apiException.errors}");
    }
  },
  // في حالة النجاح (ApiResponse)
  (apiResponse) {
    // تحقق من status في الـ response
    if (apiResponse.isSuccess && apiResponse.data != null) {
      whenResponseSuccess(apiResponse.data!);
    } else {
      // status = false
      isLoading.value = false;
      SnackbarManager.showSnackbar(
        apiResponse.message ?? 'حدث خطأ غير متوقع',
        backgroundColor: appTheme.error,
      );
    }
  },
);
```

---

## 🎯 أمثلة محدثة

### مثال 1: SignInController ✅
**الموقع:** `lib/uses_app_sb/features/auth/sign_in/controller/sign_in_controller.dart`

تم تحديثه بالكامل ليستخدم الـ API الجديد.

### مثال 2: SignUpController ✅
**الموقع:** `lib/uses_app_sb/features/auth/sign_up/controller/sign_up_controller.dart`

تم تحديثه بالكامل مع معالجة Validation Errors.

---

## 📦 Controllers التي تحتاج تحديث

تم العثور على **22 controller** يستخدمون `ApiHelper.makeRequest` القديم:

### Users App (uses_app_sb):
1. ✅ `sign_in_controller.dart` - **محدث**
2. ✅ `sign_up_controller.dart` - **محدث**
3. ⚠️ `advertizing_by_category_controller.dart` - يحتاج تحديث
4. ⚠️ `blocked_stores_controller.dart` - يحتاج تحديث
5. ⚠️ `favorites_controller.dart` - يحتاج تحديث
6. ⚠️ `search_controller.dart` - يحتاج تحديث
7. ⚠️ `store_detailes.dart` - يحتاج تحديث
8. ⚠️ `advertizing_controller.dart` - يحتاج تحديث
9. ⚠️ `posts_controller.dart` - يحتاج تحديث
10. ⚠️ `show_adertize_full_data_controller.dart` - يحتاج تحديث
11. ⚠️ `setting_controller.dart` - يحتاج تحديث
12. ⚠️ `edit_account_controller.dart` - يحتاج تحديث
13. ⚠️ `rate_advertise_dialog.dart` - يحتاج تحديث
14. ⚠️ `version_check_service.dart` - يحتاج تحديث

### Seller App (seller_sb):
1. ⚠️ `sign_up_controller.dart` (seller) - يحتاج تحديث
2. ⚠️ `sign_in_controller.dart` (seller) - يحتاج تحديث
3. ⚠️ `edit_account_controller.dart` (seller) - يحتاج تحديث
4. ⚠️ `adverize_controller.dart` - يحتاج تحديث
5. ⚠️ `setting_controller.dart` (seller) - يحتاج تحديث
6. ⚠️ `posts_controller.dart` (seller) - يحتاج تحديث
7. ⚠️ `add_post_controller.dart` - يحتاج تحديث
8. ⚠️ `add_advertise_controller.dart` - يحتاج تحديث

---

## 🔍 خطوات التحديث لكل Controller

### 1. تحديث الـ Imports
```dart
// ❌ احذف
import 'package:advertising_user/uses_app_sb/core/server/parse_response.dart';
import 'package:dartz/dartz.dart';

// ✅ لا حاجة لـ imports إضافية - فقط helper_api.dart كافي
import 'package:advertising_user/uses_app_sb/core/server/helper_api.dart';
```

### 2. تحديث الـ makeRequest Call
```dart
// ❌ القديم
Either<ErrorResponse, Map<String, dynamic>> response;
response = await ApiHelper.makeRequest(
  targetRout: ServerConstApis.someEndpoint,
  method: "Post",
  data: {...}
);

// ✅ الجديد
final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
  targetRout: ServerConstApis.someEndpoint,
  method: "POST",  // استخدم الأحرف الكبيرة
  data: {...},
);
```

### 3. تحديث معالجة Response
```dart
// ❌ القديم
dynamic handlingResponse = response.fold((l) => l, (r) => r);
if (handlingResponse is ErrorResponse) {
  // error handling
} else {
  // success handling
}

// ✅ الجديد
response.fold(
  (apiException) {
    // error handling
  },
  (apiResponse) {
    if (apiResponse.isSuccess && apiResponse.data != null) {
      // success handling
    }
  },
);
```

### 4. تحديث الـ Method Type في whenResponseSuccess
```dart
// ❌ القديم
whenResponseSuccess(handlingResponse) async {
  var token = handlingResponse['token'];
  ...
}

// ✅ الجديد
whenResponseSuccess(Map<String, dynamic> data) async {
  var token = data['token'];
  ...
}
```

---

## 🎨 معالجة الأخطاء المتقدمة

### أنواع الأخطاء المدعومة:

```dart
if (apiException.isAuthError) {
  // 401: انتهت الجلسة - اطلب تسجيل دخول
  Get.offAllNamed('/SignInScreen');
}

if (apiException.isForbidden) {
  // 403: غير مصرح بالوصول
  SnackbarManager.showSnackbar('غير مصرح لك بالوصول');
}

if (apiException.isNotFound) {
  // 404: غير موجود
  SnackbarManager.showSnackbar('المورد المطلوب غير موجود');
}

if (apiException.isValidationError) {
  // 422: أخطاء في البيانات
  // يمكنك عرض الأخطاء بشكل منفصل
  apiException.errors?.forEach((field, messages) {
    print("$field: $messages");
  });
}

if (apiException.isServerError) {
  // 500: خطأ في السيرفر
  SnackbarManager.showSnackbar('خطأ في السيرفر، حاول لاحقاً');
}
```

---

## 📌 نصائح مهمة

1. **استخدم Generic Types**:
   ```dart
   ApiHelper.makeRequest<Map<String, dynamic>>(...)
   ```
   أو
   ```dart
   ApiHelper.makeRequest<List<dynamic>>(...)
   ```

2. **تحقق من status**:
   ```dart
   if (apiResponse.isSuccess && apiResponse.data != null) {
     // العملية نجحت
   }
   ```

3. **عرض الرسائل**:
   ```dart
   SnackbarManager.showSnackbar(
     apiException.message,
     backgroundColor: appTheme.error,
   );
   ```

4. **استخدم الأحرف الكبيرة للـ HTTP Methods**:
   - ✅ "GET", "POST", "PUT", "DELETE", "PATCH"
   - ❌ "get", "post", "put", "delete", "patch"

5. **معالجة حالة data = null**:
   ```dart
   if (apiResponse.data != null) {
     // استخدم البيانات
   }
   ```

---

## 🧪 الاختبار

### للاختبار على localhost:
```dart
static String baseAPI = 'http://localhost:8000/api';
```

### للاختبار على Android Emulator:
```dart
static String baseAPI = 'http://10.0.2.2:8000/api';
```

### للإنتاج:
```dart
static String baseAPI = 'https://myadvertisement.shop/api';
```

---

## ✨ الخلاصة

### ما تم إنجازه:
- ✅ إنشاء `ApiResponse<T>` model
- ✅ إنشاء `ApiException` للأخطاء
- ✅ تحديث `ApiHelper.makeRequest`
- ✅ تحديث `server_config.dart` (Base URL)
- ✅ تحديث `SignInController` كمثال
- ✅ تحديث `SignUpController` كمثال

### ما يحتاج تحديث:
- ⚠️ **20 controller** آخر يحتاجون نفس التحديث
- اتبع الخطوات الموضحة أعلاه لكل controller

---

## 📞 في حالة وجود مشاكل

إذا واجهت أي مشكلة:
1. تأكد من أن Backend يرسل Response بالشكل الصحيح
2. تحقق من الـ Base URL
3. تأكد من الـ Headers (Authorization Bearer Token)
4. راجع أمثلة SignInController و SignUpController

---

**تاريخ التحديث:** 2024
**الإصدار:** 1.0.0

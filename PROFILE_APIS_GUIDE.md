# 📝 دليل تحديث Profile APIs

دليل شامل لتحديث APIs الملف الشخصي للمستخدمين والتجار

---

## ✅ التحديثات المكتملة

### 1. إضافة Wallet Model
**الملف:** `lib/seller_sb/core/shared/models/profile_data.dart`

```dart
class Wallet {
  final int balance;
  final int points;

  Wallet({required this.balance, required this.points});

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
    balance: json["balance"] ?? 0,
    points: json["points"] ?? 0,
  );
}
```

### 2. تحديث Data class في TraderModel
```dart
class Data {
  ...
  Wallet? wallet; // ✅ حقل جديد
  ...
}
```

---

## 📡 Profile APIs

### 1. Get User Profile
**Endpoint:** `GET /api/user/get/profile`
**Headers:** `Authorization: Bearer {token}`

**Response:**
```json
{
  "status": true,
  "data": {
    "id": 1,
    "name": "Ahmed Mohammed",
    "phone": "07701234567",
    "email": "ahmed@example.com",
    "created_at": "2024-01-01T00:00:00.000000Z"
  }
}
```

**Implementation في Setting Controller:**
```dart
Future<void> getProfile() async {
  try {
    isLoading.value = true;

    final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
      targetRout: ServerConstApis.getProfile,
      method: "GET",
      token: token,
    );

    response.fold(
      (apiException) {
        print("Error: ${apiException.message}");
        SnackbarManager.showSnackbar(
          apiException.message,
          backgroundColor: appTheme.error,
        );
      },
      (apiResponse) {
        if (apiResponse.isSuccess && apiResponse.data != null) {
          // تحديث بيانات المستخدم
          UserModel user = UserModel.fromJson(apiResponse.data!);
          // حفظ في state
        }
      },
    );
  } catch (e) {
    print("Error getting profile: $e");
  } finally {
    isLoading.value = false;
  }
}
```

---

### 2. Update User Profile
**Endpoint:** `POST /api/user/update/profile`
**Headers:** `Authorization: Bearer {token}`

**Request:**
```dart
{
  "name": "Ahmed Ali",
  "email": "ahmed.ali@example.com"
}
```

**Response:**
```json
{
  "status": true,
  "message": "Profile updated successfully",
  "data": {
    "id": 1,
    "name": "Ahmed Ali",
    "phone": "07701234567",
    "email": "ahmed.ali@example.com"
  }
}
```

**Implementation في Edit Account Controller:**
```dart
Future<void> updateProfile() async {
  try {
    isLoading.value = true;

    final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
      targetRout: ServerConstApis.updateProfile,
      method: "POST",
      token: token,
      data: {
        'name': nameController.text,
        'email': emailController.text,
      },
    );

    response.fold(
      (apiException) {
        isLoading.value = false;
        SnackbarManager.showSnackbar(
          apiException.message,
          backgroundColor: appTheme.error,
        );

        // عرض validation errors إن وجدت
        if (apiException.isValidationError && apiException.errors != null) {
          apiException.errors!.forEach((field, messages) {
            print("$field: ${messages.join(', ')}");
          });
        }
      },
      (apiResponse) {
        if (apiResponse.isSuccess) {
          isLoading.value = false;
          SnackbarManager.showSnackbar(
            apiResponse.message ?? "تم تحديث الملف الشخصي بنجاح"
          );

          // تحديث البيانات المحلية
          if (apiResponse.data != null) {
            UserModel user = UserModel.fromJson(apiResponse.data!);
            // حفظ في state
          }

          Get.back(); // العودة للشاشة السابقة
        } else {
          isLoading.value = false;
          SnackbarManager.showSnackbar(
            apiResponse.message ?? "فشل التحديث",
            backgroundColor: appTheme.error,
          );
        }
      },
    );
  } catch (e) {
    isLoading.value = false;
    print("Error updating profile: $e");
    SnackbarManager.showSnackbar(
      "حدث خطأ في التحديث",
      backgroundColor: appTheme.error,
    );
  }
}
```

---

### 3. Get Trader Profile
**Endpoint:** `GET /api/trader/get/profile`
**Headers:** `Authorization: Bearer {token}`

**Response:**
```json
{
  "status": true,
  "data": {
    "id": 1,
    "owner_contact_number": "07701234567",
    "city": "بغداد",
    "whatsapp_number": "07701234567",
    "telegram_number": "@trader",
    "social_media_link": "https://facebook.com/store",
    "store_description": "متجر متخصص في الإلكترونيات",
    "store": {
      "id": 1,
      "store_name": "متجر الإلكترونيات",
      "store_owner_name": "Ahmed"
    },
    "wallet": {
      "balance": 50000,
      "points": 100
    }
  }
}
```

**Implementation في Trader Setting Controller:**
```dart
Future<void> getTraderProfile() async {
  try {
    isLoading.value = true;

    final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
      targetRout: ServerConstApis.getProfile,
      method: "GET",
      token: token,
    );

    response.fold(
      (apiException) {
        print("Error: ${apiException.message}");
        SnackbarManager.showSnackbar(
          apiException.message,
          backgroundColor: appTheme.error,
        );
      },
      (apiResponse) {
        if (apiResponse.isSuccess && apiResponse.data != null) {
          // تحويل البيانات إلى ProfileData
          ProfileData profileData = ProfileData.fromJson({
            "status": apiResponse.status,
            "data": apiResponse.data
          });

          // حفظ البيانات
          traderData.value = profileData.data;

          // عرض معلومات المحفظة
          if (profileData.data.wallet != null) {
            print("Balance: ${profileData.data.wallet!.balance}");
            print("Points: ${profileData.data.wallet!.points}");
          }
        }
      },
    );
  } catch (e) {
    print("Error getting trader profile: $e");
  } finally {
    isLoading.value = false;
  }
}
```

---

### 4. Update Trader Profile
**Endpoint:** `POST /api/trader/update/profile`
**Headers:** `Authorization: Bearer {token}`
**Content-Type:** `multipart/form-data`

**Request (Form Data):**
```dart
{
  "city": "بغداد",
  "whatsapp_number": "07701234567",
  "telegram_number": "@trader_new",
  "social_media_link": "https://facebook.com/mystore",
  "store_description": "متجر متخصص في بيع الإلكترونيات"
}
```

**Response:**
```json
{
  "status": true,
  "message": "Profile updated successfully",
  "data": {...}
}
```

**Implementation في Trader Edit Account Controller:**
```dart
Future<void> updateTraderProfile() async {
  try {
    isLoading.value = true;

    final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
      targetRout: ServerConstApis.updateProfile,
      method: "POST",
      token: token,
      data: {
        'city': selectedCity.value?.nameAr ?? cityController.text,
        'whatsapp_number': whatsappController.text,
        'telegram_number': telegramController.text,
        'social_media_link': socialMediaController.text,
        'store_description': storeDescriptionController.text,
      },
    );

    response.fold(
      (apiException) {
        isLoading.value = false;
        SnackbarManager.showSnackbar(
          apiException.message,
          backgroundColor: appTheme.error,
        );

        if (apiException.isValidationError && apiException.errors != null) {
          apiException.errors!.forEach((field, messages) {
            print("$field: ${messages.join(', ')}");
          });
        }
      },
      (apiResponse) {
        if (apiResponse.isSuccess) {
          isLoading.value = false;
          SnackbarManager.showSnackbar(
            apiResponse.message ?? "تم تحديث الملف الشخصي بنجاح"
          );

          Get.back();
        } else {
          isLoading.value = false;
          SnackbarManager.showSnackbar(
            apiResponse.message ?? "فشل التحديث",
            backgroundColor: appTheme.error,
          );
        }
      },
    );
  } catch (e) {
    isLoading.value = false;
    print("Error updating trader profile: $e");
    SnackbarManager.showSnackbar(
      "حدث خطأ في التحديث",
      backgroundColor: appTheme.error,
    );
  }
}
```

---

### 5. Change Password (Trader)
**Endpoint:** `POST /api/trader/change/password`
**Headers:** `Authorization: Bearer {token}`

**Request:**
```dart
{
  "current_password": "oldpassword123",
  "new_password": "newpassword123",
  "new_password_confirmation": "newpassword123"
}
```

**Response (Success):**
```json
{
  "status": true,
  "message": "Password changed successfully"
}
```

**Response (Error):**
```json
{
  "status": false,
  "message": "Current password is incorrect"
}
```

**Implementation - إنشاء Change Password Screen:**

**الموقع:** `lib/seller_sb/features/settings/change_password/`

#### Controller:
```dart
class ChangePasswordController extends GetxController {
  RxBool isLoading = false.obs;
  late GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> changePassword() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: '${ServerConstApis.baseAPI}/trader/change/password',
        method: "POST",
        token: token,
        data: {
          'current_password': currentPasswordController.text,
          'new_password': newPasswordController.text,
          'new_password_confirmation': confirmPasswordController.text,
        },
      );

      response.fold(
        (apiException) {
          isLoading.value = false;
          SnackbarManager.showSnackbar(
            apiException.message,
            backgroundColor: appTheme.error,
          );

          if (apiException.isValidationError && apiException.errors != null) {
            apiException.errors!.forEach((field, messages) {
              print("$field: ${messages.join(', ')}");
            });
          }
        },
        (apiResponse) {
          isLoading.value = false;

          if (apiResponse.isSuccess) {
            SnackbarManager.showSnackbar(
              apiResponse.message ?? "تم تغيير كلمة المرور بنجاح"
            );

            // مسح الحقول
            currentPasswordController.clear();
            newPasswordController.clear();
            confirmPasswordController.clear();

            Get.back(); // العودة للشاشة السابقة
          } else {
            SnackbarManager.showSnackbar(
              apiResponse.message ?? "فشل تغيير كلمة المرور",
              backgroundColor: appTheme.error,
            );
          }
        },
      );
    } catch (e) {
      isLoading.value = false;
      print("Error changing password: $e");
      SnackbarManager.showSnackbar(
        "حدث خطأ في تغيير كلمة المرور",
        backgroundColor: appTheme.error,
      );
    }
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
```

#### UI Screen:
```dart
class ChangePasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePasswordController());

    return Scaffold(
      appBar: AppBar(title: Text('تغيير كلمة المرور')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              AppTextField(
                controller: controller.currentPasswordController,
                hintText: 'كلمة المرور الحالية',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال كلمة المرور الحالية';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              AppTextField(
                controller: controller.newPasswordController,
                hintText: 'كلمة المرور الجديدة',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال كلمة المرور الجديدة';
                  }
                  if (value.length < 6) {
                    return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              AppTextField(
                controller: controller.confirmPasswordController,
                hintText: 'تأكيد كلمة المرور الجديدة',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء تأكيد كلمة المرور';
                  }
                  if (value != controller.newPasswordController.text) {
                    return 'كلمة المرور غير متطابقة';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              Obx(() => ButtonWidget(
                text: 'تغيير كلمة المرور',
                isLoading: controller.isLoading.value,
                onPressed: controller.changePassword,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 🔧 Controllers التي تحتاج تحديث

### User App (uses_app_sb):

#### 1. Setting Controller
**الملف:** `lib/uses_app_sb/features/setting/controller/setting_controller.dart`

**التحديثات المطلوبة:**
- ✅ تحديث `getProfile()` لاستخدام API الجديد
- ✅ تحديث `logout()` لاستخدام API الجديد

#### 2. Edit Account Controller
**الملف:** `lib/uses_app_sb/features/setting/controller/edit_account_controller.dart`

**التحديثات المطلوبة:**
- ✅ تحديث `updateProfile()` لاستخدام API الجديد
- ✅ إضافة حقل `email` في UI

---

### Seller App (seller_sb):

#### 1. Setting Controller (Trader)
**الملف:** `lib/seller_sb/features/setting/controller/setting_controller.dart`

**التحديثات المطلوبة:**
- ✅ تحديث `getProfile()` لاستخدام API الجديد
- ✅ عرض بيانات `wallet` (balance & points)
- ✅ تحديث `logout()` لاستخدام API الجديد

#### 2. Edit Account Controller (Trader)
**الملف:** `lib/seller_sb/features/setting/controller/edit_account_controller.dart`

**التحديثات المطلوبة:**
- ✅ تحديث `updateProfile()` لاستخدام API الجديد
- ✅ إضافة حقل `store_description` في UI

#### 3. Change Password (جديد)
**المطلوب إنشاؤه:**
- ✅ Controller: `lib/seller_sb/features/settings/change_password/controller/change_password_controller.dart`
- ✅ Screen: `lib/seller_sb/features/settings/change_password/view/change_password_screen.dart`

---

## 📋 ملخص Endpoints

| API | Method | Endpoint | Controller | Status |
|-----|--------|----------|-----------|--------|
| Get User Profile | GET | `/api/user/get/profile` | SettingController | ⚠️ يحتاج تحديث |
| Update User Profile | POST | `/api/user/update/profile` | EditAccountController | ⚠️ يحتاج تحديث |
| Get Trader Profile | GET | `/api/trader/get/profile` | SettingController | ⚠️ يحتاج تحديث |
| Update Trader Profile | POST | `/api/trader/update/profile` | EditAccountController | ⚠️ يحتاج تحديث |
| Change Password | POST | `/api/trader/change/password` | ChangePasswordController | ⚠️ يحتاج إنشاء |

---

## ✨ الميزات الجديدة

- ✅ دعم `email` في User Profile
- ✅ دعم `store_description` في Trader Profile
- ✅ دعم `wallet` (balance & points) للتاجر
- ✅ Change Password للتاجر
- ✅ معالجة محسنة للأخطاء
- ✅ رسائل بالعربية

---

## 📝 ملاحظات مهمة

1. **Authentication Required:**
   - جميع Profile APIs تحتاج `Authorization: Bearer {token}`

2. **Validation Errors:**
   - استخدم `apiException.isValidationError` للتحقق
   - اعرض الأخطاء من `apiException.errors`

3. **Update Profile:**
   - User: يرسل `name` و `email` فقط
   - Trader: يرسل جميع الحقول (city, whatsapp, telegram, social_media_link, store_description)

4. **Wallet:**
   - متوفر فقط للتجار
   - يحتوي على `balance` و `points`

---

## 🎯 الخطوات التالية

1. ⚠️ تحديث User Setting Controller
2. ⚠️ تحديث User Edit Account Controller
3. ⚠️ تحديث Trader Setting Controller
4. ⚠️ تحديث Trader Edit Account Controller
5. ⚠️ إنشاء Change Password Screen للتاجر
6. ⚠️ اختبار شامل

---

**تاريخ الإنشاء:** 2024
**الإصدار:** 1.0.0

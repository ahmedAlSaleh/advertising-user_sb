# تحديثات مطلوبة لـ Trader SignUp Controller

## الملف: `lib/seller_sb/features/auth/sign_up/controller/sign_up_controller.dart`

---

## 1. إضافة حقل store_description

### في الـ Controllers (بعد السطر 58):
```dart
final TextEditingController storeDescriptionController = TextEditingController(); // ✅ حقل جديد
```

---

## 2. تحديث getStoresCategory() (السطر 97-127)

### الطريقة القديمة ❌:
```dart
Future<void> getStoresCategory() async {
  try {
    isLoadingFetchingCateogires.value = true;
    Either<ErrorResponse, Map<String, dynamic>> response;

    response = await ApiHelper.makeRequest(
      targetRout: ServerConstApis.getStoresCategories,
      method: "Get",
    );

    dynamic handlingResponse = response.fold((l) => l, (r) => r);

    if (handlingResponse is ErrorResponse) {
      if (kDebugMode) {
        print("Error fetching categories: ${handlingResponse.message}");
      }
    } else {
      StoreCategory storeCategoryResponse = StoreCategory.fromJson(handlingResponse);
      storesCategory.value = storeCategoryResponse.data;
    }
  } catch (e) {
    // Handle error
  } finally {
    isLoadingFetchingCateogires.value = false;
  }
}
```

### الطريقة الجديدة ✅:
```dart
Future<void> getStoresCategory() async {
  try {
    isLoadingFetchingCateogires.value = true;

    final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
      targetRout: ServerConstApis.getStoresCategories,
      method: "GET",
    );

    response.fold(
      (apiException) {
        if (kDebugMode) {
          print("Error fetching categories: ${apiException.message}");
        }
      },
      (apiResponse) {
        if (apiResponse.isSuccess && apiResponse.data != null) {
          StoreCategory storeCategoryResponse = StoreCategory.fromJson(apiResponse.data!);
          storesCategory.value = storeCategoryResponse.data;
        }
      },
    );
  } catch (e) {
    if (kDebugMode) {
      print("Error loading categories: $e");
    }
  } finally {
    isLoadingFetchingCateogires.value = false;
  }
}
```

---

## 3. تحديث getCities() (السطر 129-159)

### الطريقة الجديدة ✅:
```dart
Future<void> getCities() async {
  try {
    isLoadingCities.value = true;

    final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
      targetRout: ServerConstApis.getCities,
      method: "GET",
    );

    response.fold(
      (apiException) {
        if (kDebugMode) {
          print("Error fetching cities: ${apiException.message}");
        }
      },
      (apiResponse) {
        if (apiResponse.isSuccess && apiResponse.data != null) {
          List<dynamic> citiesJson = apiResponse.data!['data'] ?? apiResponse.data;
          cities.value = citiesJson.map((cityJson) {
            return City.fromjson(cityJson);
          }).toList();
        }
      },
    );
  } catch (e) {
    if (kDebugMode) {
      print("Error loading cities: $e");
    }
  } finally {
    isLoadingCities.value = false;
  }
}
```

---

## 4. تحديث onPressContinue() - عند إرسال البيانات بدون صورة (السطر 321-356)

### إضافة store_description في data:
```dart
Map<String, dynamic> data = {
  'store_name': storeNameController.text,
  'store_owner_name': storeOwnerNameController.text,
  'store_number': storeNumberController.text,
  'owner_contact_number': storeOwnerNumberController.text,
  'password': passwordController.text,
  'password_confirmation': passwordConfirmationController.text,
  'sub_category_ids': selectedSubCategoryIds.toList(),
  'city': selectedCity.value?.nameAr ?? '',
  'whatsapp_number': '',
  'telegram_number': '',
  'social_media_link': '',
  'store_description': storeDescriptionController.text, // ✅ حقل جديد
  'image': '',
};
```

### تحديث API Call:
```dart
final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
  targetRout: ServerConstApis.register,
  method: "POST",
  data: data,
);

response.fold(
  (apiException) {
    isLoading.value = false;
    isError.value = true;
    print('ERROR: ${apiException.message}');
    SnackbarManager.showSnackbar(
      apiException.message,
      backgroundColor: appTheme.error,
    );
  },
  (apiResponse) {
    if (apiResponse.isSuccess && apiResponse.data != null) {
      whenResponseSuccess(apiResponse.data!);
    } else {
      isLoading.value = false;
      isError.value = true;
      SnackbarManager.showSnackbar(
        apiResponse.message ?? "Registration failed",
        backgroundColor: appTheme.error,
      );
    }
  },
);
```

---

## 5. تحديث registerWithImage() (السطر 367-435)

### إضافة store_description في الحقول:
```dart
request.fields['store_description'] = storeDescriptionController.text; // ✅ حقل جديد
```

### تحديث معالجة Response:
```dart
// بعد السطر 412
if (response.statusCode == 200 || response.statusCode == 201) {
  var jsonResponse = json.decode(response.body);

  // ✅ التحقق من الشكل الجديد
  if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
    if (jsonResponse['data']['token'] != null) {
      await whenResponseSuccess(jsonResponse['data']);
    } else {
      isLoading.value = false;
      isError.value = true;
      SnackbarManager.showSnackbar("Registration failed: No token received");
    }
  } else {
    isLoading.value = false;
    isError.value = true;
    SnackbarManager.showSnackbar(
      jsonResponse['message'] ?? 'Registration failed'
    );
  }
} else {
  isLoading.value = false;
  isError.value = true;
  var errorResponse = json.decode(response.body);
  SnackbarManager.showSnackbar(
    errorResponse['message'] ?? 'Registration failed'
  );
}
```

---

## 6. تحديث whenResponseSuccess() (السطر 437-453)

### الطريقة الجديدة ✅:
```dart
whenResponseSuccess(Map<String, dynamic> data) async {
  try {
    await storeService.createString('token', data['token']);
    token = data['token'];
    await storeService.createString('account_type', 'seller');
    print("Token saved: $token");
    SnackbarManager.showSnackbar("تم التسجيل بنجاح");
    isLoading.value = false;
    Get.offAllNamed('/SellerMainBottomNavigationBarWidget');
  } catch (e) {
    print("Error saving token: $e");
    isLoading.value = false;
    isError.value = true;
    SnackbarManager.showSnackbar("تم التسجيل لكن فشل حفظ الجلسة");
  }
}
```

---

## 7. تحديث Imports (السطر 1-17)

### إزالة:
```dart
import 'package:dartz/dartz.dart'; // ❌ لم يعد مطلوب
import 'package:advertising_user/uses_app_sb/core/server/parse_response.dart'; // ❌ deprecated
```

---

## ملخص التغييرات:

✅ إضافة `storeDescriptionController`
✅ تحديث `getStoresCategory()` للـ API الجديد
✅ تحديث `getCities()` للـ API الجديد
✅ إضافة `store_description` في data عند التسجيل
✅ إضافة `store_description` في registerWithImage()
✅ تحديث معالجة Response في registerWithImage()
✅ تحديث `whenResponseSuccess()` signature
✅ إزالة imports غير مستخدمة

---

## UI Updates المطلوبة:

يجب إضافة TextField لـ store_description في شاشة التسجيل.

**الموقع المحتمل:** `lib/seller_sb/features/auth/sign_up/view/sign_up_screen.dart`

```dart
AppTextField(
  controller: controller.storeDescriptionController,
  hintText: 'وصف المتجر',
  labelText: 'وصف المتجر',
  maxLines: 3,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال وصف المتجر';
    }
    return null;
  },
),
```

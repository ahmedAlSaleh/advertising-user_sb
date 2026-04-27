import 'dart:io';
import 'dart:convert';
import 'package:advertising_user/uses_app_sb/core/shared/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:advertising_user/seller_sb/core/server/server_config.dart';
import 'package:advertising_user/seller_sb/core/shared/models/city.dart';
import 'package:advertising_user/main.dart';

import '../../../../../uses_app_sb/core/server/helper_api.dart';
import '../../../../../uses_app_sb/core/server/api_exception.dart';
import '../../../../../uses_app_sb/core/server/api_response.dart';
import '../../../../../uses_app_sb/core/shared/models/store_category.dart';
import '../../../../../uses_app_sb/core/shared/widgets/snacl_bar/snackbar_manager.dart';

class SignUpController extends GetxController {
  @override
  void onInit() {
    super.onInit();
     _fetchInitialData();
  }

   void _fetchInitialData() async {
    try {
       await Future.wait([
        getStoresCategory(),
        getCities(),
      ]);
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching initial data: $e");
      }
    }
  }

  RxBool isAgreedOn = false.obs;
  RxBool isAgreedError = false.obs;

  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  RxInt currentStep = 1.obs;
  late GlobalKey<FormState> formstate = GlobalKey<FormState>();
  late GlobalKey<FormState> formstateStep1 = GlobalKey<FormState>();
  late GlobalKey<FormState> formstateStep2 = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController storeNameController = TextEditingController();
  final TextEditingController storeOwnerNameController =
      TextEditingController();
  final TextEditingController storeNumberController = TextEditingController();
  final TextEditingController storeOwnerNumberController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController =
      TextEditingController();
  RxList<Datum> storesCategory = <Datum>[].obs;
  RxBool isLoadingFetchingCateogires = false.obs;
  Rx<Datum?> selectedCategory =
      Rx<Datum?>(null); // Allow null values

  // Subcategories
  RxList<int> selectedSubCategoryIds = <int>[].obs;

  // Method to toggle subcategory selection
  void toggleSubCategory(int subCategoryId) {
    if (selectedSubCategoryIds.contains(subCategoryId)) {
      selectedSubCategoryIds.remove(subCategoryId);
    } else {
      selectedSubCategoryIds.add(subCategoryId);
    }
  }

  // Method to handle category selection change
  void onCategoryChanged(Datum? category) {
    selectedCategory.value = category;
    // Clear selected subcategories when category changes
    selectedSubCategoryIds.clear();
  }

  // Cities
  RxList<City> cities = <City>[].obs;
  RxBool isLoadingCities = false.obs;
  Rx<City?> selectedCity = Rx<City?>(null);

  // Image Upload
  final ImagePicker _imagePicker = ImagePicker();
  Rx<File?> selectedImage = Rx<File?>(null);
  RxBool isImageUploading = false.obs;

  // ✅ Combined loading state for better UX
  bool get isLoadingInitialData =>
      isLoadingFetchingCateogires.value || isLoadingCities.value;

  Future<void> getStoresCategory() async {
    try {
      isLoadingFetchingCateogires.value = true; // Start loading

      // Make the API request
      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: ServerConstApis.getStoresCategories,
        method: "Get",
      );

      response.fold(
        (apiException) {
          // Handle error response
          if (kDebugMode) {
            print("Error fetching categories: ${apiException.message}");
          }
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            // Parsing the required files from the response
            StoreCategory storeCategoryResponse = StoreCategory.fromJson(apiResponse.data!);

            // Mapping the JSON data to a list of Datum objects
            storesCategory.value = storeCategoryResponse.data;
          }
        },
      );
    } catch (e) {
      // Handle error here, e.g. showing a message or logging it
    } finally {
      isLoadingFetchingCateogires.value = false; // End loading
    }
  }

  Future<void> getCities() async {
    try {
      isLoadingCities.value = true;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: ServerConstApis.getCities,
        method: "Get",
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error fetching cities: ${apiException.message}");
          }
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            List<dynamic> citiesJson = apiResponse.data!['data'];

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

  // Image Upload Methods
  Future<void> pickImageFromGallery() async {
    try {
      print('============ Picking Image from Gallery ============');
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
        print('Image selected from gallery: ${pickedFile.path}');
        print('Image size: ${await selectedImage.value!.length()} bytes');
        SnackbarManager.showSnackbar("Image selected successfully");
      } else {
        print('No image selected');
      }
      print('====================================================');
    } catch (e) {
      print('ERROR picking image from gallery: $e');
      SnackbarManager.showSnackbar("Failed to pick image: $e");
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      print('============ Taking Photo from Camera ============');
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
        print('Photo captured: ${pickedFile.path}');
        print('Image size: ${await selectedImage.value!.length()} bytes');
        SnackbarManager.showSnackbar("Photo captured successfully");
      } else {
        print('No photo taken');
      }
      print('====================================================');
    } catch (e) {
      print('ERROR taking photo: $e');
      SnackbarManager.showSnackbar("Failed to capture photo: $e");
    }
  }

  void removeSelectedImage() {
    print('============ Removing Selected Image ============');
    selectedImage.value = null;
    print('Image removed successfully');
    print('=================================================');
    SnackbarManager.showSnackbar("Image removed");
  }

  void showImageSourceDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Image Source'.tr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Camera Option
                  _ImageSourceOption(
                    icon: Icons.camera_alt,
                    label: 'Camera'.tr,
                    onTap: () {
                      Get.back();
                      pickImageFromCamera();
                    },
                  ),
                  // Gallery Option
                  _ImageSourceOption(
                    icon: Icons.photo_library,
                    label: 'Gallery'.tr,
                    onTap: () {
                      Get.back();
                      pickImageFromGallery();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Navigate to next step after validating step 1
  onPressNextStep() {
    FormState? formdata = formstateStep1.currentState;
    if (formdata!.validate()) {
      formdata.save();

      // Check if category has subcategories and if at least one is selected
      if (selectedCategory.value != null &&
          selectedCategory.value!.subCategories != null &&
          selectedCategory.value!.subCategories!.isNotEmpty &&
          selectedSubCategoryIds.isEmpty) {
        SnackbarManager.showSnackbar("Please select at least one subcategory");
        return;
      }

      currentStep.value = 2;
    }
  }

  // Go back to step 1
  onPressPreviousStep() {
    currentStep.value = 1;
  }

  onPressContinue() async {
    try {
      FormState? formdata = formstateStep2.currentState;
      if (formdata!.validate()) {
        formdata.save();
        if (!isAgreedOn.value) {
          isAgreedError.value = true;
          return;
        } else {
          isAgreedError.value = false;
        }

        isLoading.value = true;
        isError.value = false;

        print('============ Starting Registration ============');
        print('Store Name: ${storeNameController.text}');
        print('Owner Name: ${storeOwnerNameController.text}');
        print('City: ${selectedCity.value?.nameAr}');
        print('Selected Subcategories: ${selectedSubCategoryIds.toList()}');
        print('Image Selected: ${selectedImage.value != null}');

        // If image is selected, upload with multipart
        if (selectedImage.value != null) {
          print('Using multipart/form-data for image upload');
          await registerWithImage();
        } else {
          print('No image selected, using standard JSON request');
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
            'image': '',
          };

          final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
              targetRout: ServerConstApis.register, method: "Post", data: data);

          response.fold(
            (apiException) {
              isLoading.value = false;
              isError.value = true;
              print('ERROR: ${apiException.message}');
              SnackbarManager.showSnackbar(apiException.message);
            },
            (apiResponse) {
              if (apiResponse.isSuccess && apiResponse.data != null) {
                if (apiResponse.data!['token'] != null) {
                  whenResponseSuccess(apiResponse.data!);
                } else {
                  isLoading.value = false;
                  isError.value = true;
                  SnackbarManager.showSnackbar(
                      "Registration failed: No token received");
                }
              } else {
                isLoading.value = false;
                isError.value = true;
                SnackbarManager.showSnackbar(
                    apiResponse.message ?? "Registration failed");
              }
            },
          );
        }
        print('===============================================');
      }
    } catch (e) {
      isError.value = true;
      isLoading.value = false;
      print("Error during registration: $e");
    }
  }

  // Register with image using multipart/form-data
  Future<void> registerWithImage() async {
    try {
      print('============ Uploading with Image ============');
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ServerConstApis.register),
      );

      // Add form fields
      request.fields['store_name'] = storeNameController.text;
      request.fields['store_owner_name'] = storeOwnerNameController.text;
      request.fields['store_number'] = storeNumberController.text;
      request.fields['owner_contact_number'] = storeOwnerNumberController.text;
      request.fields['password'] = passwordController.text;
      request.fields['password_confirmation'] = passwordConfirmationController.text;
      request.fields['city'] = selectedCity.value?.nameAr ?? '';
      request.fields['whatsapp_number'] = '';
      request.fields['telegram_number'] = '';
      request.fields['social_media_link'] = '';

      // Add subcategory IDs as array
      for (int i = 0; i < selectedSubCategoryIds.length; i++) {
        request.fields['sub_category_ids[$i]'] = selectedSubCategoryIds[i].toString();
      }

      // Add image file
      if (selectedImage.value != null) {
        var imageFile = await http.MultipartFile.fromPath(
          'image',
          selectedImage.value!.path,
        );
        request.files.add(imageFile);
        print('Image added to request: ${selectedImage.value!.path}');
      }

      print('Sending request to: ${request.url}');
      print('Fields: ${request.fields}');
      print('Files: ${request.files.length}');

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['token'] != null) {
          await whenResponseSuccess(jsonResponse);
        } else {
          isLoading.value = false;
          isError.value = true;
          SnackbarManager.showSnackbar("Registration failed: No token received");
        }
      } else {
        isLoading.value = false;
        isError.value = true;
        var errorResponse = json.decode(response.body);
        SnackbarManager.showSnackbar(errorResponse['message'] ?? 'Registration failed');
      }
      print('==============================================');
    } catch (e) {
      isLoading.value = false;
      isError.value = true;
      print('ERROR in registerWithImage: $e');
      SnackbarManager.showSnackbar("Registration failed: $e");
    }
  }

  whenResponseSuccess(handlingResponse) async {
    try {
      await storeService.createString('token', handlingResponse['token']);
      token = handlingResponse['token'];
      await storeService.createString('account_type', 'seller');
      print("Token saved: $token");
      SnackbarManager.showSnackbar("Successfully registered");
      isLoading.value = false;
      Get.offAllNamed('/SellerMainBottomNavigationBarWidget');
    } catch (e) {
      print("Error saving token: $e");
      isLoading.value = false;
      isError.value = true;
      SnackbarManager.showSnackbar(
          "Registration successful but failed to save session");
    }
  }
}

// Image Source Option Widget
class _ImageSourceOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ImageSourceOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              appTheme.primary,
              appTheme.primary.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: appTheme.primary.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

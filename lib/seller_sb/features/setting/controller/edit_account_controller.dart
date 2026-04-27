import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:advertising_user/seller_sb/core/server/server_config.dart';
import 'package:advertising_user/seller_sb/core/shared/models/city.dart';
import 'package:advertising_user/seller_sb/core/shared/models/profile_data.dart';

import '../../../../main.dart';
import '../../../../uses_app_sb/core/server/helper_api.dart';
import '../../../../uses_app_sb/core/shared/models/store_category.dart';
import '../../../../uses_app_sb/core/shared/models/user.dart';
import '../../../../uses_app_sb/core/shared/widgets/snacl_bar/snackbar_manager.dart';

class EditAccountController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    await getStoresCategory();
    await getCities();
    await getProfileData();
  }

  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  RxBool isLoadingProfile = true.obs;
  late GlobalKey<FormState> formstate = GlobalKey<FormState>();

  // Controllers for form fields (matching API response)
  final TextEditingController storeNameController = TextEditingController();
  final TextEditingController storeOwnerNameController = TextEditingController();
  final TextEditingController storeNumberController = TextEditingController();
  final TextEditingController storeOwnerNumberController =
      TextEditingController();
  final TextEditingController whatsappNumberController =
      TextEditingController();
  final TextEditingController telegramPhoneNumber = TextEditingController();
  final TextEditingController socialMediaController = TextEditingController();
  final TextEditingController storeDescriptionController = TextEditingController();

  // Cities
  RxList<City> cities = <City>[].obs;
  RxBool isLoadingCities = false.obs;
  Rx<City?> selectedCity = Rx<City?>(null);

  // Store Categories
  RxList<Datum> storesCategory = <Datum>[].obs;
  RxBool isLoadingFetchingCateogires = false.obs;
  Rx<Datum?> selectedCategory = Rx<Datum?>(null);

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

  /// Get Store Categories - API الجديد
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

  /// Get Cities - API الجديد
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

  /// Get Trader Profile - API الجديد
  Future<void> getProfileData() async {
    try {
      isLoadingProfile.value = true;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: ServerConstApis.getProfile,
        method: "GET",
        token: token,
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error fetching profile: ${apiException.message}");
          }
          SnackbarManager.showSnackbar(
            apiException.message,
            backgroundColor: appTheme.error,
          );
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            // Parse using ProfileData model
            ProfileData profileData = ProfileData.fromJson(apiResponse.data!);
            Data userData = profileData.data;
            Store storeData = userData.store;

            if (kDebugMode) {
              print("Profile loaded successfully");
              print("Store: ${storeData.storeName}");
              print("Subcategories count: ${storeData.subCategories.length}");
            }

            // Populate form fields with profile data
            storeOwnerNumberController.text = userData.ownerContactNumber;
            whatsappNumberController.text = userData.whatsappNumber ?? '';
            telegramPhoneNumber.text = userData.telegramNumber ?? '';
            socialMediaController.text = userData.socialMediaLink ?? '';
            storeDescriptionController.text = userData.storeDescription ?? '';

            storeNameController.text = storeData.storeName;
            storeOwnerNameController.text = storeData.storeOwnerName;
            storeNumberController.text = storeData.storeNumber;

            // Set selected city
            if (userData.city.isNotEmpty) {
              selectedCity.value = cities.firstWhereOrNull(
                (city) => city.nameAr == userData.city || city.nameEn == userData.city,
              );

              if (kDebugMode) {
                print("Selected city: ${selectedCity.value?.name}");
              }
            }

            // Set selected subcategories
            selectedSubCategoryIds.clear();
            for (var subCat in storeData.subCategories) {
              selectedSubCategoryIds.add(subCat.id);
            }

            if (kDebugMode) {
              print("Selected subcategory IDs: $selectedSubCategoryIds");
            }

            // Find and set the category based on the first subcategory
            if (storeData.subCategories.isNotEmpty) {
              // Get the first subcategory to find its parent category
              int firstSubCatId = storeData.subCategories.first.id;

              // Find the category that contains this subcategory
              for (var category in storesCategory) {
                if (category.subCategories != null) {
                  bool found = category.subCategories!.any((sub) => sub.id == firstSubCatId);
                  if (found) {
                    selectedCategory.value = category;
                    if (kDebugMode) {
                      print("Found parent category: ${category.name}");
                    }
                    break;
                  }
                }
              }
            }
          } else {
            SnackbarManager.showSnackbar(
              apiResponse.message ?? "Failed to load profile data",
              backgroundColor: appTheme.error,
            );
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error loading profile: $e");
      }
      SnackbarManager.showSnackbar(
        "Failed to load profile data".tr,
        backgroundColor: appTheme.error,
      );
    } finally {
      isLoadingProfile.value = false;
    }
  }

  /// Update Trader Profile - API الجديد
  Future<void> onPressUpdate() async {
    try {
      FormState? formdata = formstate.currentState;
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

        isLoading.value = true;
        isError.value = false;

        Map<String, dynamic> data = {
          'store_name': storeNameController.text,
          'store_owner_name': storeOwnerNameController.text,
          'store_number': storeNumberController.text,
          'sub_category_ids': selectedSubCategoryIds.toList(),
          'owner_contact_number': storeOwnerNumberController.text,
          'whatsapp_number': whatsappNumberController.text,
          'telegram_number': telegramPhoneNumber.text,
          'social_media_link': socialMediaController.text,
          'store_description': storeDescriptionController.text,
          'city': selectedCity.value?.nameAr ?? '',
          'image': '',
        };

        final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
          targetRout: ServerConstApis.updateProfile,
          method: "POST",
          token: token,
          data: data,
        );

        response.fold(
          (apiException) {
            isLoading.value = false;
            isError.value = true;

            SnackbarManager.showSnackbar(
              apiException.message,
              backgroundColor: appTheme.error,
            );

            // عرض validation errors
            if (apiException.isValidationError && apiException.errors != null) {
              if (kDebugMode) {
                apiException.errors!.forEach((field, messages) {
                  print("$field: ${messages.join(', ')}");
                });
              }
            }
          },
          (apiResponse) {
            isLoading.value = false;

            if (apiResponse.isSuccess) {
              SnackbarManager.showSnackbar(
                apiResponse.message ?? "Profile updated successfully".tr,
              );
              Get.back();
            } else {
              isError.value = true;
              SnackbarManager.showSnackbar(
                apiResponse.message ?? "Failed to update profile",
                backgroundColor: appTheme.error,
              );
            }
          },
        );
      }
    } catch (e) {
      isError.value = true;
      isLoading.value = false;
      if (kDebugMode) {
        print("Error during update: $e");
      }
      SnackbarManager.showSnackbar(
        "حدث خطأ في التحديث",
        backgroundColor: appTheme.error,
      );
    }
  }
}

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../main.dart';
import '../../../../uses_app_sb/core/server/helper_api.dart';
import '../../../../uses_app_sb/core/shared/models/advertisement_model.dart';
import '../../../../uses_app_sb/core/shared/models/user.dart';
import '../../../../uses_app_sb/core/shared/widgets/snacl_bar/snackbar_manager.dart';
import '../../../core/server/server_config.dart';

class TraderAdsController extends GetxController {
  // Loading states
  RxBool isLoadingMyAds = true.obs;
  RxBool isLoadingScheduled = false.obs;
  RxBool isLoadingExpired = false.obs;
  RxBool isCreating = false.obs;
  RxBool isDeleting = false.obs;
  RxBool isUpdatingStatus = false.obs;
  RxBool isRenewing = false.obs;

  // Data
  RxList<AdvertisementModel> myAdvertisements = <AdvertisementModel>[].obs;
  RxList<AdvertisementModel> scheduledAds = <AdvertisementModel>[].obs;
  RxList<AdvertisementModel> expiredAds = <AdvertisementModel>[].obs;

  // Form controllers for creating ad
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  late GlobalKey<FormState> adFormKey = GlobalKey<FormState>();

  // Selected data for creating ad
  RxInt selectedCategoryId = 0.obs;
  RxInt selectedSubCategoryId = 0.obs;
  RxString selectedType = 'normal'.obs;
  RxList<File> selectedImages = <File>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMyAdvertisements();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.onClose();
  }

  /// Get My Advertisements
  /// GET /api/ads/mine
  Future<void> loadMyAdvertisements() async {
    try {
      isLoadingMyAds.value = true;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: ServerConstApis.showAdvertize,
        method: "GET",
        token: token,
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error fetching my ads: ${apiException.message}");
          }
          SnackbarManager.showSnackbar(
            apiException.message,
            backgroundColor: appTheme.error,
          );
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            final dynamic responseData = apiResponse.data;
            final List<dynamic> dataList = responseData is List
                ? responseData
                : (responseData is Map ? (responseData['data'] ?? []) : []);

            myAdvertisements.value = List<AdvertisementModel>.from(
              dataList.map((x) => AdvertisementModel.fromJson(x)),
            );

            if (kDebugMode) {
              print("My advertisements loaded: ${myAdvertisements.length} items");
            }
          } else {
            SnackbarManager.showSnackbar(
              apiResponse.message ?? "Failed to load advertisements",
              backgroundColor: appTheme.error,
            );
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error loading my ads: $e");
      }
      SnackbarManager.showSnackbar(
        "حدث خطأ في تحميل الإعلانات",
        backgroundColor: appTheme.error,
      );
    } finally {
      isLoadingMyAds.value = false;
    }
  }

  /// Create Advertisement
  /// POST /api/ads/create
  Future<bool> createAdvertisement() async {
    try {
      FormState? formdata = adFormKey.currentState;
      if (formdata == null || !formdata.validate()) {
        return false;
      }

      if (selectedCategoryId.value == 0) {
        SnackbarManager.showSnackbar(
          "الرجاء اختيار التصنيف",
          backgroundColor: appTheme.error,
        );
        return false;
      }

      if (selectedSubCategoryId.value == 0) {
        SnackbarManager.showSnackbar(
          "الرجاء اختيار التصنيف الفرعي",
          backgroundColor: appTheme.error,
        );
        return false;
      }

      formdata.save();
      isCreating.value = true;

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ServerConstApis.addAdvertize),
      );

      // Add headers
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      // Add fields
      request.fields['title'] = titleController.text;
      request.fields['description'] = descriptionController.text;
      request.fields['price'] = priceController.text;
      request.fields['category_id'] = selectedCategoryId.value.toString();
      request.fields['sub_category_id'] = selectedSubCategoryId.value.toString();
      request.fields['type'] = selectedType.value;

      // Add images
      for (int i = 0; i < selectedImages.length; i++) {
        var imageFile = await http.MultipartFile.fromPath(
          'images[$i]',
          selectedImages[i].path,
        );
        request.files.add(imageFile);
      }

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (kDebugMode) {
        print("Create ad status: ${response.statusCode}");
        print("Create ad response: ${response.body}");
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        SnackbarManager.showSnackbar(
          "تم إنشاء الإعلان بنجاح",
          icon: Icon(Icons.check_circle, color: appTheme.primaryText),
          backgroundColor: Colors.green,
        );

        // Clear form
        clearForm();

        // Reload ads
        await loadMyAdvertisements();

        return true;
      } else {
        SnackbarManager.showSnackbar(
          "فشل إنشاء الإعلان",
          backgroundColor: appTheme.error,
        );
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error creating ad: $e");
      }
      SnackbarManager.showSnackbar(
        "حدث خطأ في إنشاء الإعلان",
        backgroundColor: appTheme.error,
      );
      return false;
    } finally {
      isCreating.value = false;
    }
  }

  /// Delete Advertisement
  /// POST /api/ads/delete/{id}
  Future<void> deleteAdvertisement(int adId) async {
    try {
      isDeleting.value = true;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: '${ServerConstApis.deleteAdvertize}/$adId',
        method: "POST",
        token: token,
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error deleting ad: ${apiException.message}");
          }
          SnackbarManager.showSnackbar(
            apiException.message,
            backgroundColor: appTheme.error,
          );
        },
        (apiResponse) {
          if (apiResponse.isSuccess) {
            SnackbarManager.showSnackbar(
              apiResponse.message ?? "تم حذف الإعلان بنجاح",
              icon: Icon(Icons.check_circle, color: appTheme.primaryText),
              backgroundColor: Colors.green,
            );

            // Remove from list
            myAdvertisements.removeWhere((ad) => ad.id == adId);
          } else {
            SnackbarManager.showSnackbar(
              apiResponse.message ?? "فشل حذف الإعلان",
              backgroundColor: appTheme.error,
            );
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting ad: $e");
      }
      SnackbarManager.showSnackbar(
        "حدث خطأ في حذف الإعلان",
        backgroundColor: appTheme.error,
      );
    } finally {
      isDeleting.value = false;
    }
  }

  /// Update Advertisement Status
  /// PUT /api/trader/ads/{id}/status
  Future<void> updateAdStatus(int adId, bool isActive) async {
    try {
      isUpdatingStatus.value = true;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: '${ServerConstApis.updateAdStatus}/$adId/status',
        method: "PUT",
        token: token,
        data: {
          'is_active': isActive,
        },
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error updating status: ${apiException.message}");
          }
          SnackbarManager.showSnackbar(
            apiException.message,
            backgroundColor: appTheme.error,
          );
        },
        (apiResponse) {
          if (apiResponse.isSuccess) {
            SnackbarManager.showSnackbar(
              apiResponse.message ?? "تم تحديث حالة الإعلان",
              icon: Icon(Icons.check_circle, color: appTheme.primaryText),
              backgroundColor: Colors.green,
            );

            // Update in list
            final index = myAdvertisements.indexWhere((ad) => ad.id == adId);
            if (index != -1) {
              // Create updated ad
              final updatedAd = AdvertisementModel(
                id: myAdvertisements[index].id,
                title: myAdvertisements[index].title,
                description: myAdvertisements[index].description,
                price: myAdvertisements[index].price,
                type: myAdvertisements[index].type,
                featureType: myAdvertisements[index].featureType,
                isActive: isActive,
                viewsCount: myAdvertisements[index].viewsCount,
                scheduledFor: myAdvertisements[index].scheduledFor,
                expiresAt: myAdvertisements[index].expiresAt,
                promotedUntil: myAdvertisements[index].promotedUntil,
                trader: myAdvertisements[index].trader,
                category: myAdvertisements[index].category,
                subCategory: myAdvertisements[index].subCategory,
                images: myAdvertisements[index].images,
              );
              myAdvertisements[index] = updatedAd;
            }
          } else {
            SnackbarManager.showSnackbar(
              apiResponse.message ?? "فشل تحديث حالة الإعلان",
              backgroundColor: appTheme.error,
            );
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error updating status: $e");
      }
      SnackbarManager.showSnackbar(
        "حدث خطأ في تحديث الحالة",
        backgroundColor: appTheme.error,
      );
    } finally {
      isUpdatingStatus.value = false;
    }
  }

  /// Get Scheduled Advertisements
  /// GET /api/trader/ads/scheduled
  Future<void> getScheduledAds() async {
    try {
      isLoadingScheduled.value = true;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: ServerConstApis.getScheduledAds,
        method: "GET",
        token: token,
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error fetching scheduled ads: ${apiException.message}");
          }
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            final dynamic responseData = apiResponse.data;
            final List<dynamic> dataList = responseData is List
                ? responseData
                : (responseData is Map ? (responseData['data'] ?? []) : []);

            scheduledAds.value = List<AdvertisementModel>.from(
              dataList.map((x) => AdvertisementModel.fromJson(x)),
            );

            if (kDebugMode) {
              print("Scheduled ads loaded: ${scheduledAds.length} items");
            }
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error loading scheduled ads: $e");
      }
    } finally {
      isLoadingScheduled.value = false;
    }
  }

  /// Get Expired Advertisements
  /// GET /api/trader/ads/expired
  Future<void> getExpiredAds() async {
    try {
      isLoadingExpired.value = true;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: ServerConstApis.getExpiredAds,
        method: "GET",
        token: token,
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error fetching expired ads: ${apiException.message}");
          }
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            final dynamic responseData = apiResponse.data;
            final List<dynamic> dataList = responseData is List
                ? responseData
                : (responseData is Map ? (responseData['data'] ?? []) : []);

            expiredAds.value = List<AdvertisementModel>.from(
              dataList.map((x) => AdvertisementModel.fromJson(x)),
            );

            if (kDebugMode) {
              print("Expired ads loaded: ${expiredAds.length} items");
            }
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error loading expired ads: $e");
      }
    } finally {
      isLoadingExpired.value = false;
    }
  }

  /// Renew Advertisement
  /// POST /api/trader/ads/{id}/renew
  Future<void> renewAdvertisement(int adId, int durationDays) async {
    try {
      isRenewing.value = true;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: '${ServerConstApis.renewAd}/$adId/renew',
        method: "POST",
        token: token,
        data: {
          'duration_days': durationDays,
        },
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error renewing ad: ${apiException.message}");
          }
          SnackbarManager.showSnackbar(
            apiException.message,
            backgroundColor: appTheme.error,
          );
        },
        (apiResponse) {
          if (apiResponse.isSuccess) {
            SnackbarManager.showSnackbar(
              apiResponse.message ?? "تم تجديد الإعلان بنجاح",
              icon: Icon(Icons.check_circle, color: appTheme.primaryText),
              backgroundColor: Colors.green,
            );

            // Reload ads
            loadMyAdvertisements();
            getExpiredAds();
          } else {
            SnackbarManager.showSnackbar(
              apiResponse.message ?? "فشل تجديد الإعلان",
              backgroundColor: appTheme.error,
            );
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error renewing ad: $e");
      }
      SnackbarManager.showSnackbar(
        "حدث خطأ في تجديد الإعلان",
        backgroundColor: appTheme.error,
      );
    } finally {
      isRenewing.value = false;
    }
  }

  /// Clear form
  void clearForm() {
    titleController.clear();
    descriptionController.clear();
    priceController.clear();
    selectedCategoryId.value = 0;
    selectedSubCategoryId.value = 0;
    selectedType.value = 'normal';
    selectedImages.clear();
  }

  /// Add image
  void addImage(File image) {
    selectedImages.add(image);
  }

  /// Remove image
  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  /// Format price
  String formatPrice(double price) {
    return price.toStringAsFixed(0);
  }

  /// Get active ads count
  int getActiveAdsCount() {
    return myAdvertisements.where((ad) => ad.isActive).length;
  }

  /// Get inactive ads count
  int getInactiveAdsCount() {
    return myAdvertisements.where((ad) => !ad.isActive).length;
  }

  /// Get active ads list
  List<AdvertisementModel> get activeAds {
    return myAdvertisements.where((ad) => ad.isActive).toList();
  }

  /// Get inactive ads list
  List<AdvertisementModel> get inactiveAds {
    return myAdvertisements.where((ad) => !ad.isActive).toList();
  }

  /// Refresh all data
  Future<void> refreshData() async {
    await Future.wait([
      loadMyAdvertisements(),
      getScheduledAds(),
      getExpiredAds(),
    ]);
  }
}

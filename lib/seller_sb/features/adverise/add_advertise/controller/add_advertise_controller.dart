import 'dart:io';

import 'package:advertising_user/main.dart';
import 'package:advertising_user/seller_sb/features/adverise/show_advertise/controller/adverize_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import '../../../../../uses_app_sb/core/server/helper_api.dart';
import '../../../../../uses_app_sb/core/server/api_exception.dart';
import '../../../../../uses_app_sb/core/server/api_response.dart';
import '../../../../../uses_app_sb/core/shared/models/user.dart';
import '../../../../../uses_app_sb/core/shared/widgets/snacl_bar/snackbar_manager.dart';
import '../../../../core/server/server_config.dart';

class AddAdvertiseController extends GetxController {
  // Renamed to AddAdvertiseController
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final notesController = TextEditingController();
  final priceController = TextEditingController();

  // To store picked images
  final images = <File>[].obs;

  final ImagePicker picker = ImagePicker();
  RxBool isLoading = false.obs;
  RxBool isSpecial = false.obs;
  RxBool isError = false.obs;

  // ✅ Image compression function for faster uploads
  Future<File?> compressImage(File file) async {
    try {
      final dir = await getTemporaryDirectory();
      final targetPath = path.join(
        dir.path,
        'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg'
      );

      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 70, // Adjust quality (0-100, lower = smaller file)
        minWidth: 1024,
        minHeight: 1024,
      );

      return result != null ? File(result.path) : file;
    } catch (e) {
      print('Compression error: $e');
      return file; // Return original if compression fails
    }
  }

  // Function to pick images
  Future<void> pickImage() async {
    if (images.length >= 5) {
      Get.snackbar("Limit reached", "You can only add up to 5 images");
      return;
    }

    final List<XFile>? pp = await picker.pickMultiImage(limit: 5);
    if (pp != null) {
      for (var element in pp) {
        // ✅ Compress images before adding
        final compressedFile = await compressImage(File(element.path));
        if (compressedFile != null) {
          images.add(compressedFile);
        }
      }
    }
  }

  // Function to submit the form (renamed for advertisement)
  void submitAdvertise() async {
    try {
      isLoading.value = true;
      isError.value = false;
      Map<String, dynamic> data = {
        'title': titleController.text,
        'description': descriptionController.text,
        'notes': notesController.text,
        'price': priceController.text,
        'type': isSpecial.value ? 'special' : 'normal'
      };
      Map<String, File> imagesMap = {};
      for (int i = 0; i < images.length; i++) {
        imagesMap['images[$i]'] = images[i];
      }

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
          targetRout: ServerConstApis.addAdvertize,
          method: "Post",
          data: data,
          token: token,
          files: imagesMap);

      response.fold(
        (apiException) {
          isLoading.value = false;
          isError.value = true;
          SnackbarManager.showSnackbar(apiException.message,
              backgroundColor: appTheme.error);
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            whenResponseSuccess(apiResponse.data);
          } else {
            isLoading.value = false;
            isError.value = true;
            SnackbarManager.showSnackbar(
                apiResponse.message ?? "Failed to create advertisement",
                backgroundColor: appTheme.error);
          }
        },
      );
    } catch (e) {
      isError.value = true;
      isLoading.value = false;
    }
  }

  whenResponseSuccess(handlingResponse) {
    isLoading.value = false;
    Get.back();

    // ✅ Check if AdverizeController exists before trying to refresh
    if (Get.isRegistered<AdverizeController>()) {
      Get.find<AdverizeController>().refreshData();
    }

    // ✅ Show success message
    String successMessage = handlingResponse['message'] ?? "Ads created successfully";
    if (successMessage.isEmpty) {
      successMessage = "Ads created successfully";
    }

    SnackbarManager.showSnackbar(
      successMessage,
      backgroundColor: appTheme.success
    );
  }
}

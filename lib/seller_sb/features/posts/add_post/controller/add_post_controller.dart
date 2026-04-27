import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:advertising_user/seller_sb/core/server/server_config.dart';
import 'package:advertising_user/seller_sb/features/posts/my_posts/controller/posts_controller.dart';
import 'package:advertising_user/main.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import '../../../../../uses_app_sb/core/server/helper_api.dart';
import '../../../../../uses_app_sb/core/server/api_exception.dart';
import '../../../../../uses_app_sb/core/server/api_response.dart';
import '../../../../../uses_app_sb/core/shared/models/user.dart';
import '../../../../../uses_app_sb/core/shared/widgets/snacl_bar/snackbar_manager.dart';

class AddPostController extends GetxController {
  final titleController = TextEditingController();

  // To store picked images
  final images = <File>[].obs;

  final ImagePicker picker = ImagePicker();
  RxBool isLoading = false.obs;
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

  Future<void> pickImage() async {
    if (images.length >= 5) {
      SnackbarManager.showSnackbar(
          "You can only add up to 5 images".tr.isNotEmpty
              ? "You can only add up to 5 images".tr
              : "You can only add up to 5 images",
          backgroundColor: appTheme.error
      );
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

   void removeImage(int index) {
    if (index >= 0 && index < images.length) {
      images.removeAt(index);
    }
  }

   void submitPost() async {
    try {

      if (token.isEmpty) {
        SnackbarManager.showSnackbar(
            "Please login first",
            backgroundColor: appTheme.error
        );
        return;
      }

      print("Token being sent: $token");

      isLoading.value = true;
      isError.value = false;


      Map<String, dynamic> data = {
        'title': titleController.text,
      };
      Map<String, File> imagesMap = {};
      for (int i = 0; i < images.length; i++) {
        imagesMap['images[$i]'] = images[i];
      }

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
          targetRout: ServerConstApis.addPost,
          method: "Post",
          data: data,
          token: token,
          files: imagesMap);

      response.fold(
        (apiException) {
          isLoading.value = false;
          isError.value = true;

          String errorMessage = apiException.message;
          if (errorMessage.isEmpty) {
            errorMessage = "An error occurred";
          }

          SnackbarManager.showSnackbar(
              errorMessage,
              backgroundColor: appTheme.error
          );
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            whenResponseSuccess(apiResponse.data);
          } else {
            isLoading.value = false;
            isError.value = true;
            SnackbarManager.showSnackbar(
                apiResponse.message ?? "Failed to add post",
                backgroundColor: appTheme.error
            );
          }
        },
      );
    } catch (e) {
      isError.value = true;
      isLoading.value = false;

      SnackbarManager.showSnackbar(
          "An unexpected error occurred",
          backgroundColor: appTheme.error
      );
    }
  }

  whenResponseSuccess(handlingResponse) async {
    isLoading.value = false;
    Get.back();

    // ✅ Check if PostsController exists before trying to refresh
    if (Get.isRegistered<PostsController>()) {
      Get.find<PostsController>().refreshData();
    }

    // ✅ Show success message
    String successMessage = handlingResponse['message'] ?? "Post added successfully";
    if (successMessage.isEmpty) {
      successMessage = "Post added successfully";
    }

    SnackbarManager.showSnackbar(
      successMessage,
      backgroundColor: appTheme.success
    );
  }

}

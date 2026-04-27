import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../../uses_app_sb/core/server/helper_api.dart';
import '../../../../uses_app_sb/core/server/server_config.dart';
import '../../../../uses_app_sb/core/shared/models/post_model.dart';
import '../../../../uses_app_sb/core/shared/models/user.dart';
import '../../../../uses_app_sb/core/shared/widgets/snacl_bar/snackbar_manager.dart';

class TraderPostsController extends GetxController {
  // Loading states
  RxBool isLoadingPosts = true.obs;
  RxBool isCreating = false.obs;
  RxBool isDeleting = false.obs;

  // Data
  RxList<PostModel> myPosts = <PostModel>[].obs;

  // Form controllers for create post
  final TextEditingController contentController = TextEditingController();
  RxList<File> selectedImages = <File>[].obs;

  @override
  void onInit() {
    super.onInit();
    getMyPosts();
  }

  @override
  void onClose() {
    contentController.dispose();
    super.onClose();
  }

  /// Get My Posts (Trader)
  /// GET /api/posts/mine
  Future<void> getMyPosts() async {
    try {
      isLoadingPosts.value = true;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: ServerConstApis.getMyPosts,
        method: "GET",
        token: token,
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error loading my posts: ${apiException.message}");
          }
          SnackbarManager.showSnackbar(
            apiException.message,
            backgroundColor: appTheme.error,
          );
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            // Extract the list from the response
            final dataList = apiResponse.data!['data'] ?? [];

            myPosts.value = List<PostModel>.from(
              dataList.map((x) => PostModel.fromJson(x)),
            );

            if (kDebugMode) {
              print("My posts loaded: ${myPosts.length} posts");
            }
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Exception loading my posts: $e");
      }
      SnackbarManager.showSnackbar(
        'حدث خطأ أثناء تحميل منشوراتي',
        backgroundColor: appTheme.error,
      );
    } finally {
      isLoadingPosts.value = false;
    }
  }

  /// Create Post (Trader)
  /// POST /api/posts/create
  Future<bool> createPost() async {
    try {
      isCreating.value = true;

      if (contentController.text.trim().isEmpty) {
        SnackbarManager.showSnackbar(
          'يرجى كتابة محتوى المنشور',
          backgroundColor: appTheme.error,
        );
        return false;
      }

      // Prepare form data
      final Map<String, dynamic> data = {
        'content': contentController.text.trim(),
      };

      // Prepare files
      final Map<String, File>? files = selectedImages.isNotEmpty
          ? Map.fromIterable(
              List.generate(selectedImages.length, (i) => i),
              key: (i) => 'images[$i]',
              value: (i) => selectedImages[i],
            )
          : null;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: ServerConstApis.createPost,
        method: "POST",
        token: token,
        data: data,
        files: files,
      );

      bool success = false;

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error creating post: ${apiException.message}");
          }
          SnackbarManager.showSnackbar(
            apiException.message,
            backgroundColor: appTheme.error,
          );
        },
        (apiResponse) {
          if (apiResponse.isSuccess) {
            SnackbarManager.showSnackbar(
              apiResponse.message ?? 'تم إنشاء المنشور بنجاح',
              backgroundColor: Colors.green,
            );

            // Clear form
            contentController.clear();
            selectedImages.clear();

            // Refresh my posts
            getMyPosts();

            success = true;

            if (kDebugMode) {
              print("Post created successfully");
            }
          } else {
            SnackbarManager.showSnackbar(
              apiResponse.message ?? 'فشل إنشاء المنشور',
              backgroundColor: appTheme.error,
            );
          }
        },
      );

      return success;
    } catch (e) {
      if (kDebugMode) {
        print("Exception creating post: $e");
      }
      SnackbarManager.showSnackbar(
        'حدث خطأ أثناء إنشاء المنشور',
        backgroundColor: appTheme.error,
      );
      return false;
    } finally {
      isCreating.value = false;
    }
  }

  /// Delete Post
  /// POST /api/posts/delete/{post_id}
  Future<void> deletePost(int postId) async {
    try {
      isDeleting.value = true;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: '${ServerConstApis.deletePost}/$postId',
        method: "POST",
        token: token,
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error deleting post: ${apiException.message}");
          }
          SnackbarManager.showSnackbar(
            apiException.message,
            backgroundColor: appTheme.error,
          );
        },
        (apiResponse) {
          if (apiResponse.isSuccess) {
            SnackbarManager.showSnackbar(
              apiResponse.message ?? 'تم حذف المنشور بنجاح',
              backgroundColor: Colors.green,
            );

            // Remove from list
            myPosts.removeWhere((post) => post.id == postId);

            if (kDebugMode) {
              print("Post deleted successfully");
            }
          } else {
            SnackbarManager.showSnackbar(
              apiResponse.message ?? 'فشل حذف المنشور',
              backgroundColor: appTheme.error,
            );
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Exception deleting post: $e");
      }
      SnackbarManager.showSnackbar(
        'حدث خطأ أثناء حذف المنشور',
        backgroundColor: appTheme.error,
      );
    } finally {
      isDeleting.value = false;
    }
  }

  /// Add Image
  void addImage(File image) {
    if (selectedImages.length < 5) {
      selectedImages.add(image);
    } else {
      SnackbarManager.showSnackbar(
        'الحد الأقصى 5 صور',
        backgroundColor: appTheme.error,
      );
    }
  }

  /// Remove Image
  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
    }
  }

  /// Refresh Posts
  Future<void> refreshPosts() async {
    await getMyPosts();
  }
}

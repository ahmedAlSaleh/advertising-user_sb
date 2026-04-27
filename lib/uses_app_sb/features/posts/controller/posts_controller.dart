import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../core/server/helper_api.dart';
import '../../../core/server/server_config.dart';
import '../../../core/shared/models/post_model.dart';
import '../../../core/shared/widgets/snacl_bar/snackbar_manager.dart';

class PostsController extends GetxController {
  // Loading states
  RxBool isLoadingPosts = true.obs;
  RxBool isLoadingMore = false.obs;
  RxBool isLiking = false.obs;

  // Data
  RxList<PostModel> posts = <PostModel>[].obs;
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxInt totalPosts = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getAllPosts();
  }

  /// Get All Posts with Pagination
  /// GET /api/user/get_posts?page={page}
  Future<void> getAllPosts({int page = 1}) async {
    try {
      if (page == 1) {
        isLoadingPosts.value = true;
      } else {
        isLoadingMore.value = true;
      }

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: '${ServerConstApis.getAllPosts}?page=$page',
        method: "GET",
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error loading posts: ${apiException.message}");
          }
          SnackbarManager.showSnackbar(
            apiException.message,
            backgroundColor: appTheme.error,
          );
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            // Extract 'posts' object from response
            final postsData = apiResponse.data!['posts'];
            final paginatedResponse = PaginatedPostsResponse.fromJson(postsData);

            if (page == 1) {
              posts.value = paginatedResponse.posts;
            } else {
              posts.addAll(paginatedResponse.posts);
            }

            currentPage.value = paginatedResponse.currentPage;
            totalPages.value = paginatedResponse.lastPage;
            totalPosts.value = paginatedResponse.total;

            if (kDebugMode) {
              print("Posts loaded: ${posts.length} of $totalPosts");
              print("Page $currentPage of $totalPages");
            }
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Exception loading posts: $e");
      }
      SnackbarManager.showSnackbar(
        'حدث خطأ أثناء تحميل المنشورات',
        backgroundColor: appTheme.error,
      );
    } finally {
      isLoadingPosts.value = false;
      isLoadingMore.value = false;
    }
  }

  /// Load More Posts (Pagination)
  Future<void> loadMorePosts() async {
    if (!isLoadingMore.value && currentPage.value < totalPages.value) {
      await getAllPosts(page: currentPage.value + 1);
    }
  }

  /// Refresh Posts
  Future<void> refreshPosts() async {
    await getAllPosts(page: 1);
  }

  /// Like Post
  /// POST /api/post/like/{post_id}
  Future<void> likePost(int postId) async {
    try {
      // Optimistic update
      final postIndex = posts.indexWhere((p) => p.id == postId);
      if (postIndex == -1) return;

      final post = posts[postIndex];
      final wasLiked = post.isLiked;
      final wasDisliked = post.isDisliked;

      // Update UI immediately
      posts[postIndex] = post.copyWith(
        isLiked: !wasLiked,
        isDisliked: false,
        likesCount: wasLiked ? post.likesCount - 1 : post.likesCount + 1,
        dislikesCount: wasDisliked ? post.dislikesCount - 1 : post.dislikesCount,
      );

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: '${ServerConstApis.likePost}/$postId',
        method: "POST",
      );

      response.fold(
        (apiException) {
          // Revert on error
          posts[postIndex] = post;

          if (kDebugMode) {
            print("Error liking post: ${apiException.message}");
          }
        },
        (apiResponse) {
          if (kDebugMode) {
            print("Post like updated successfully");
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Exception liking post: $e");
      }
    }
  }

  /// Dislike Post
  /// POST /api/post/dislike/{post_id}
  Future<void> dislikePost(int postId) async {
    try {
      // Optimistic update
      final postIndex = posts.indexWhere((p) => p.id == postId);
      if (postIndex == -1) return;

      final post = posts[postIndex];
      final wasLiked = post.isLiked;
      final wasDisliked = post.isDisliked;

      // Update UI immediately
      posts[postIndex] = post.copyWith(
        isLiked: false,
        isDisliked: !wasDisliked,
        likesCount: wasLiked ? post.likesCount - 1 : post.likesCount,
        dislikesCount: wasDisliked ? post.dislikesCount - 1 : post.dislikesCount + 1,
      );

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: '${ServerConstApis.dislikePost}/$postId',
        method: "POST",
      );

      response.fold(
        (apiException) {
          // Revert on error
          posts[postIndex] = post;

          if (kDebugMode) {
            print("Error disliking post: ${apiException.message}");
          }
        },
        (apiResponse) {
          if (kDebugMode) {
            print("Post dislike updated successfully");
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Exception disliking post: $e");
      }
    }
  }

  /// Helper: Check if has more pages
  bool get hasMorePages => currentPage.value < totalPages.value;
}

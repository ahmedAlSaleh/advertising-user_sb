import 'package:advertising_user/main.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:advertising_user/seller_sb/core/server/server_config.dart';
import 'package:advertising_user/seller_sb/core/shared/controllers/pagination_controller.dart';
import 'package:advertising_user/seller_sb/features/posts/my_posts/model/post_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:advertising_user/seller_sb/features/posts/my_posts/model/trader_posts.dart';

import '../../../../../uses_app_sb/core/server/helper_api.dart';
import '../../../../../uses_app_sb/core/server/api_exception.dart';
import '../../../../../uses_app_sb/core/server/api_response.dart';
import '../../../../../uses_app_sb/core/shared/models/user.dart';
import '../../../../../uses_app_sb/core/shared/widgets/snacl_bar/snackbar_manager.dart';


class PostsController extends PaginationController<Post> {
  PostsController()
      : super(fetchDataCallback: _fetchData, cacheKey: "postsList");

  late Owner owner;
  final AudioPlayer audioPlayer = AudioPlayer();

  static Future<Either<ApiException, ApiResponse<dynamic>>> _fetchData(
      String url, int page, Map<String, dynamic> additionalParams) async {
    String apiUrl = "${ServerConstApis.showPost}?page=$page";
    return ApiHelper.makeRequest(
      targetRout: apiUrl,
      method: "GET",
      token: token,
    );
  }

  Future<void> playSound(String soundPath) async {
    await audioPlayer.play(AssetSource(soundPath));
  }

  @override
  handleDataSuccess(dynamic handlingResponse) {
    var traderJson = handlingResponse['trader'];
    owner = Owner.fromJson(traderJson);

    List<dynamic> postListJson = traderJson['posts']['data'];
    lastPageId = traderJson['posts']['last_page'];

    var postList =
        postListJson.map((jsonItem) => Post.fromJson(jsonItem)).toList();
    itemList.addAll(postList);

    if (pageId == lastPageId) {
      hasMoreData.value = false;
    }
    pageId++;
    isLoading.value = false;
    isLoadingMoreData.value = false;
  }

  Owner getOwner() {
    return owner;
  }

  // Method to like or dislike a post
  likeOrDislikePost(int postId, int modelIndex, bool isLike) async {
    late Either<ApiException, ApiResponse<dynamic>> response;
    bool isDoneSuccessfully = false;

    playSound('sounds/like_sound.mp3');
    if (isLike) {
      // Send like request
      response =
          await likePost("${ServerConstApis.likeOrDislikePost}/like/$postId");
    } else {
      // Send dislike request
      response = await dislikePost(
          "${ServerConstApis.likeOrDislikePost}/dislike/$postId");
    }

    // Handle the server response
    response.fold(
      (apiException) {
        // Handle error
        SnackbarManager.showSnackbar(
          "Failed to update like/dislike",
          backgroundColor: appTheme.error,
        );
      },
      (apiResponse) {
        // Assuming the result contains the status, likes, and dislikes
        if (apiResponse.isSuccess && apiResponse.data != null) {
          final result = apiResponse.data!;
          // Update the post's like and dislike count based on the server's response
          itemList[modelIndex].likesCount = result['likes'];
          itemList[modelIndex].disLikesCount = result['dislikes'];

          // Toggle the like/dislike state based on the action
          if (isLike) {
            // If it was liked, now toggle it off (unlike it)
            itemList[modelIndex].isLiked = !itemList[modelIndex].isLiked;
            if (itemList[modelIndex].isLiked) {
              itemList[modelIndex].isDisliked =
                  false; // If liked, ensure it's not disliked
            }
          } else {
            // If it was disliked, now toggle it off (undislike it)
            itemList[modelIndex].isDisliked = !itemList[modelIndex].isDisliked;
            if (itemList[modelIndex].isDisliked) {
              itemList[modelIndex].isLiked =
                  false; // If disliked, ensure it's not liked
            }
          }

          // Play the sound on success
          update();
        }
      },
    );

    // Update the UI after the state has been updated
    if (isDoneSuccessfully) {
      update();
    }
  }

  // Send like request to the API
  Future<Either<ApiException, ApiResponse<dynamic>>> likePost(String url) async {
    return await ApiHelper.makeRequest(
      targetRout: url,
      token: token,
      data: {'is_trader': true},
      method: "POST",
    );
  }

  // Send dislike request to the API
  Future<Either<ApiException, ApiResponse<dynamic>>> dislikePost(String url) async {
    return await ApiHelper.makeRequest(
      targetRout: url,
      token: token,
      data: {'is_trader': true},
      method: "POST",
    );
  }

  void deletePost(int postId) async {
    try {
      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: '${ServerConstApis.deletePost}/$postId',
        method: "Post",
        token: token,
      );

      response.fold(
        (apiException) {
          isLoading.value = false;
          isError.value = true;
          SnackbarManager.showSnackbar(apiException.message,
              backgroundColor: appTheme.error);
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            refreshData();
            SnackbarManager.showSnackbar(
                apiResponse.data!['message'] ?? "Post deleted successfully",
                backgroundColor: appTheme.success);
          } else {
            isLoading.value = false;
            isError.value = true;
            SnackbarManager.showSnackbar(
                apiResponse.message ?? "Failed to delete post",
                backgroundColor: appTheme.error);
          }
        },
      );
    } catch (e) {
      SnackbarManager.showSnackbar('UnExpected Error',
          backgroundColor: appTheme.error);
    }
  }
}

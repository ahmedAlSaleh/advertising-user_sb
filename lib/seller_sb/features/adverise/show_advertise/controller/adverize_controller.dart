import 'package:advertising_user/main.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

import '../../../../../uses_app_sb/core/server/helper_api.dart';
import '../../../../../uses_app_sb/core/server/api_exception.dart';
import '../../../../../uses_app_sb/core/server/api_response.dart';
import '../../../../../uses_app_sb/core/shared/models/user.dart';
import '../../../../../uses_app_sb/core/shared/widgets/snacl_bar/snackbar_manager.dart';
import '../../../../core/server/server_config.dart';
import '../../../../core/shared/controllers/pagination_controller.dart';
import '../model/advertise_model.dart';

class AdverizeController extends PaginationController<Advertise> {
  AdverizeController()
      : super(fetchDataCallback: _fetchData, cacheKey: "AdvertiseList");

  static Future<Either<ApiException, ApiResponse<dynamic>>> _fetchData(
      String url, int page, Map<String, dynamic> additionalParams) async {
    String apiUrl = "${ServerConstApis.showAdvertize}?page=$page";
    return ApiHelper.makeRequest(
      targetRout: apiUrl,
      method: "GET",
      token: token,
    );
  }

  @override
  handleDataSuccess(dynamic handlingResponse) {
    List<dynamic> postListJson = handlingResponse['data']['data'];
    lastPageId = handlingResponse['data']['last_page'];

    var postList =
        postListJson.map((jsonItem) => Advertise.fromJson(jsonItem)).toList();
    itemList.addAll(postList);

    if (pageId == lastPageId) {
      hasMoreData.value = false;
    }
    pageId++;
    isLoading.value = false;
    isLoadingMoreData.value = false;
  }

  deleteAds(int adsId) async {
    try {
      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: '${ServerConstApis.deleteAdvertize}/$adsId',
        method: "Post",
        token: token,
      );

      response.fold(
        (apiException) {
          isLoading.value = false;
          isError.value = true;
          Get.back();
          SnackbarManager.showSnackbar(apiException.message,
              backgroundColor: appTheme.error);
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            Get.back();
            refreshData();
            SnackbarManager.showSnackbar(
                apiResponse.data!['message'] ?? "Advertisement deleted successfully",
                backgroundColor: appTheme.success);
          } else {
            isLoading.value = false;
            isError.value = true;
            Get.back();
            SnackbarManager.showSnackbar(
                apiResponse.message ?? "Failed to delete advertisement",
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

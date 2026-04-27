import 'dart:developer';

import 'package:advertising_user/main.dart';
import 'package:advertising_user/uses_app_sb/core/server/api_response.dart';
import 'package:advertising_user/uses_app_sb/core/server/api_exception.dart';
import 'package:advertising_user/uses_app_sb/core/services/cache_service.dart';
import 'package:advertising_user/uses_app_sb/core/services/connectivity_service.dart';
import 'package:advertising_user/uses_app_sb/core/shared/widgets/snacl_bar/snackbar_manager.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

/// PaginationController is a generic class for managing paginated data.
/// It is designed to be extended by specific controllers for different types of data.
///
/// Type [T] represents the type of data in the list (e.g., Event).
class PaginationController<T> extends GetxController {
  // A function that is responsible for fetching data. It takes the URL, page number, and any additional parameters.
  late Future<Either<ApiException, ApiResponse<dynamic>>> Function(
          String url, int page, Map<String, dynamic> additionalParams)
      fetchDataCallback;

  // Reactive variables to track loading states.m
  late RxBool isLoading;
  late RxBool isLoadingMoreData;
  RxBool isError = false.obs;

  // A ScrollController to listen to scroll events for implementing 'load more' functionality.
  late ScrollController scrollController;
  late PageController pageController;

  // Variables for managing pagination.
  late int dataLimit;
  late int pageId;
  late int lastPageId;
  bool isDataLoaded = false;
  late RxBool hasMoreData;
  late CacheService cacheService;
  final String cacheKey;
  final ConnectivityService _connectivityService = Get.find();

  // A reactive list to hold the items of type [T].
  late RxList<T> itemList;

  // A reactive list to hold any error messages that might occur during data fetching.
  late RxList<String> errorMessage;
  bool isFetchInProgress = false;

  // Constructor: Initializes variables and sets up the scroll listener.
  PaginationController(
      {required this.fetchDataCallback, required this.cacheKey}) {
    isLoading = false.obs;
    isLoadingMoreData = false.obs;
    dataLimit = 4;
    pageId = 1;
    hasMoreData = true.obs;

    errorMessage = <String>[].obs;
    itemList = <T>[].obs;
    scrollController = ScrollController();
    pageController = PageController();
    cacheService = cacheService = CacheService(cacheKey);
    // Scroll listener to handle 'load more' functionality on scroll.
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
              scrollController.offset &&
          hasMoreData.value) {
        isLoadingMoreData.value = true;
        fetchData();
      }
    });

    pageController.addListener(() {
      if (pageController.position.maxScrollExtent == pageController.offset &&
          hasMoreData.value) {
        isLoadingMoreData.value = true;
        fetchData();
      }
    });
    _connectivityService.isConnected.listen((isConnected) {
      if (isConnected) {
        refreshData(); // Refetch data when connection is back
        SnackbarManager.showSnackbar(
          "You are back online.",
          icon: Icon(Icons.wifi_outlined, color: appTheme.primaryText),
          backgroundColor: appTheme.primaryBackground,
        );
      } else {
        SnackbarManager.showSnackbar(
          "No internet connection.",
          icon: Icon(Icons.wifi_off_outlined, color: appTheme.primaryText),
          backgroundColor: appTheme.primaryBackground,
        );
      }
    });
  }

  // Add a new parameter for categoryId
  Future refreshData({Map<String, dynamic>? para}) async {
    pageId = 1; // Reset pagination to the first page
    lastPageId = 1; // Reset this as well if you're using it to track pagination
    hasMoreData.value = true; // Assume there's more data to fetch
    itemList.clear(); // Clear existing items
    fetchData(para: para); // Fetch new data with categoryId
  }

  // Called immediately after the controller is allocated memory. Initiates the first data fetch.
  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  // Method to fetch data using the provided callback. It handles the response and updates the controller's state.
  fetchData({Map<String, dynamic>? para}) async {
    // Prevent fetching if a fetch operation is already in progress
    if (isFetchInProgress) return;

    // Indicate that a fetch operation is now in progress
    isFetchInProgress = true;

    // try {
    isLoading.value = itemList.isNotEmpty ? false : true;
    if (!_connectivityService.isConnected.value) {
      log("from cache");
      final d = await cacheService.getObject<Map<String, dynamic>>(
        cacheKey: cacheKey,
        deserializeFunction: (jsonMap) => jsonMap,
      );
      if (d != null) {
        handleDataSuccess(d);
      } else {
        isLoading.value = false;
      }
    } else {
      print("ssssssssssssss$para");
      // Pass categoryId to fetchDataCallback
      Either<ApiException, ApiResponse<dynamic>> response =
          await fetchDataCallback('your-api-url', pageId,
              para ?? {}); // Replace 'your-api-url' and {} with actual values

      response.fold(
        (apiException) {
          // Handle API error
          errorMessage.value = [apiException.message];
          isError.value = true;
        },
        (apiResponse) {
          // Handle successful response
          if (apiResponse.isSuccess && apiResponse.data != null) {
            handleDataSuccess(apiResponse.data);
            cacheService.cacheObject<Map<String, dynamic>>(
              object: apiResponse.data as Map<String, dynamic>,
              cacheKey: cacheKey,
              serializeFunction: (data) => data,
            );
          } else {
            errorMessage.value = [apiResponse.message ?? 'Unknown error'];
            isError.value = true;
          }
        },
      );
    }
    isLoading.value = false;
    isLoadingMoreData.value = false;
    isFetchInProgress = false;
    // } catch (e) {
    //   isLoading.value = false;
    //   isLoadingMoreData.value = false;
    //   isError.value = true;
    //   isFetchInProgress = false;
    // }
  }

  // A method that can be overridden in subclasses to handle data differently upon successful fetch.
  handleDataSuccess(dynamic handlingResponse) {
    // This method should be implemented in subclasses to handle successful data fetches.
  }

  // Cleans up the controller, disposing the scroll controller.
  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void handleNoCachedData() {
    // Implement logic for handling no cached data
    // For example, show a message to the user, update the UI, etc.
    log("No cached data available. Unable to fetch data from the server.");
    // You can update errorMessage or any other state variable to notify the user
    errorMessage.value = [
      "No internet connection and no cached data available."
    ];
    // Update any other relevant state to reflect the situation
  }
}

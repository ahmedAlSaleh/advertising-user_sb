
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/server/helper_api.dart';
import '../../../core/server/api_exception.dart';
import '../../../core/server/api_response.dart';
import '../../../core/server/server_config.dart';
import '../../../core/shared/models/user.dart';
import '../../../core/shared/models/store_category.dart';
import '../../posts/model/trader_posts.dart';
import '../../../../seller_sb/core/shared/models/city.dart';

class StoreController extends GetxController {
  RxBool isLoading = false.obs; // Loading state
  RxBool isError = false.obs; // Error state
  RxList<Store> data = <Store>[].obs; // Store data list
  late Datum category; // The category object passed as an argument
  RxList<Datum> subCategories = <Datum>[].obs; // Subcategories list
  RxList<Datum> selectedSubCategories = <Datum>[].obs; // Multiple selected subcategories

  // Search and filter
  final TextEditingController searchController = TextEditingController();
  RxList<City> cities = <City>[].obs;
  RxBool isLoadingCities = false.obs;
  Rx<City?> selectedCity = Rx<City?>(null);
  RxBool isSearching = false.obs; // Search loading state

  @override
  void onInit() {
    print('============ StoreController onInit ============');
    final args = Get.arguments;
    category = args['category'];
    print('Category ID: ${category.id}');
    print('Category Name: ${category.name}');
    print('Subcategories: ${category.subCategories?.length ?? 0}');

    // Set up subcategories list
    if (category.subCategories != null && category.subCategories!.isNotEmpty) {
      subCategories.value = category.subCategories!;
      print('Subcategories loaded: ${subCategories.length}');
      for (var sub in subCategories) {
        print('  - ID: ${sub.id}, Name: ${sub.name}');
      }

      // Automatically select the first subcategory
      print('Auto-selecting first subcategory: ${subCategories.first.name}');
      selectedSubCategories.add(subCategories.first);
      print('First subcategory selected, fetching stores...');

      // Fetch stores for the first subcategory
      getStore();
    } else {
      print('No subcategories found');
    }

    getCities(); // Fetch cities

    // Listen to search text changes
    searchController.addListener(() {
      onSearchChanged();
    });

    print('================================================');
    super.onInit();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // Handle search text changes
  void onSearchChanged() {
    if (searchController.text.length > 2) {
      searchStores();
    } else if (searchController.text.isEmpty) {
      // Reset to original category stores when search is empty
      getStore();
    }
  }

  // Handle subcategory selection (toggle)
  void toggleSubCategory(Datum subCategory) {
    print('============ SubCategory Toggled ============');
    print('SubCategory: ${subCategory.name}');
    print('SubCategory ID: ${subCategory.id}');

    // Check if already selected
    final index = selectedSubCategories.indexWhere((item) => item.id == subCategory.id);

    if (index != -1) {
      // Already selected, remove it
      selectedSubCategories.removeAt(index);
      print('Action: Removed from selection');
    } else {
      // Not selected, add it
      selectedSubCategories.add(subCategory);
      print('Action: Added to selection');
    }

    print('Total selected: ${selectedSubCategories.length}');
    if (selectedSubCategories.isNotEmpty) {
      print('Selected IDs: ${selectedSubCategories.map((e) => e.id).join(", ")}');
    }
    print('=============================================');

    // Fetch stores if at least one subcategory is selected
    if (selectedSubCategories.isNotEmpty) {
      getStore();
    }
  }

  // Check if a subcategory is selected
  bool isSubCategorySelected(Datum subCategory) {
    return selectedSubCategories.any((item) => item.id == subCategory.id);
  }

  // Fetch the stores from the API
  getStore() async {
    try {
      isLoading.value = true;
      isError.value = false;

      print('============ Fetching Stores ============');
      print('Selected Subcategories Count: ${selectedSubCategories.length}');

      if (selectedSubCategories.isEmpty) {
        print('No subcategories selected, clearing data');
        data.clear();
        isLoading.value = false;
        return;
      }

      String apiEndpoint = token.isNotEmpty
          ? ServerConstApis.getStoresByCategory
          : ServerConstApis.getStoresByCategoryGuest;

      print('API Endpoint: $apiEndpoint');
      print('Token Available: ${token.isNotEmpty}');

      // Make parallel API calls for each selected subcategory
      List<Future<Either<ApiException, ApiResponse<dynamic>>>> requests = [];

      for (var subCategory in selectedSubCategories) {
        print('Fetching stores for subcategory: ${subCategory.name} (ID: ${subCategory.id})');
        requests.add(ApiHelper.makeRequest(
          targetRout: '$apiEndpoint/${subCategory.id}',
          method: "Get",
          token: token.isNotEmpty ? token : null,
        ));
      }

      // Wait for all requests to complete
      List<Either<ApiException, ApiResponse<dynamic>>> responses =
          await Future.wait(requests);

      // Combine all stores from all responses
      List<Store> allStores = [];
      Set<int> storeIds = {}; // To avoid duplicates

      for (int i = 0; i < responses.length; i++) {
        responses[i].fold(
          (apiException) {
            print('ERROR for subcategory ${selectedSubCategories[i].name}: ${apiException.message}');
            if (kDebugMode) {
              print("Error fetching stores: ${apiException.message}");
            }
          },
          (apiResponse) {
            if (apiResponse.isSuccess && apiResponse.data != null) {
              List<dynamic> filesJson = apiResponse.data['data'];
              print('Subcategory ${selectedSubCategories[i].name}: ${filesJson.length} stores');

              for (var fileJson in filesJson) {
                Store store = Store.fromJson(fileJson);
                // Add only if not duplicate
                if (!storeIds.contains(store.id)) {
                  allStores.add(store);
                  storeIds.add(store.id);
                }
              }
            }
          },
        );
      }

      // Update data with combined results
      data.value = allStores;

      if (data.isEmpty) {
        print('No stores found across all selected subcategories');
        isError.value = false;
      } else {
        print('Total stores loaded: ${data.length}');
        print('Stores:');
        for (var store in data) {
          print('  - ${store.storeName}');
        }
      }

      print('=========================================');
    } catch (e) {
      isError.value = true; // Set error state
      print('EXCEPTION: $e');
      if (kDebugMode) {
        print("Exception fetching stores: $e");
      }
    } finally {
      isLoading.value = false; // End loading state
    }
  }

  // Fetch cities from the API
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

  // Search stores via API
  Future<void> searchStores() async {
    try {
      isSearching.value = true;
      isError.value = false;

      String searchText = searchController.text;
      String cityName = selectedCity.value?.nameAr ?? '';

      Map<String, dynamic> requestData = {
        'name': searchText,
        'city': cityName,
      };

      String apiEndpoint = token.isNotEmpty
          ? ServerConstApis.searchStore
          : ServerConstApis.searchStoreGuest;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: apiEndpoint,
        method: "Post",
        data: requestData,
        token: token.isNotEmpty ? token : null,
      );

      response.fold(
        (apiException) {
          isError.value = true;
          if (kDebugMode) {
            print("Error searching stores: ${apiException.message}");
          }
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            // Parse the response and map to Store objects
            List<dynamic> filesJson = apiResponse.data!['data'];
            data.value =
                filesJson.map((fileJson) => Store.fromJson(fileJson)).toList();

            // If no data is found, clear the list
            if (data.isEmpty) {
              isError.value = false;
            }
          } else {
            isError.value = true;
          }
        },
      );
    } catch (e) {
      isError.value = true;
      if (kDebugMode) {
        print("Exception searching stores: $e");
      }
    } finally {
      isSearching.value = false;
    }
  }

  // Handle city selection change
  void onCityChanged(City? city) {
    selectedCity.value = city;
    // Trigger search if text has more than 2 characters
    if (searchController.text.length > 2) {
      searchStores();
    }
  }
}

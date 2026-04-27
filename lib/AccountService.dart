import 'package:advertising_user/main.dart';
import 'package:advertising_user/uses_app_sb/core/shared/models/user.dart';
import 'package:get/get.dart';

class AccountService extends GetxController {
  static AccountService get instance => Get.find<AccountService>();

  RxString accountType = ''.obs;
  RxBool isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadAccountData();
  }

  Future<void> _loadAccountData() async {
    try {
      String? savedAccountType = await storeService.readString('account_type');
      if (savedAccountType != null) {
        accountType.value = savedAccountType;
      }

      bool hasToken = await storeService.isContainKey('token');
      if (hasToken) {
        String? savedToken = await storeService.readString('token');
        if (savedToken != null && savedToken.isNotEmpty) {
          token = savedToken;
          isLoggedIn.value = true;
        } else {
          await logout();
        }
      }
    } catch (e) {
      print('Error loading account data: $e');
      await logout();
    }
  }

  Future<void> login(String userToken, String userAccountType) async {
    try {
      await storeService.createString('token', userToken);
      await storeService.createString('account_type', userAccountType);

      token = userToken;
      accountType.value = userAccountType;
      isLoggedIn.value = true;

      _navigateToMainScreen();
    } catch (e) {
      print('Error during login: $e');
    }
  }

  Future<void> logout() async {
    try {
      await storeService.clearStorage();

      token = '';
      accountType.value = '';
      isLoggedIn.value = false;

      Get.offAllNamed('/');
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  Future<void> switchAccountType() async {
    await logout();
    Get.offAllNamed('/AccountTypeSelection');
  }

  void _navigateToMainScreen() {
    if (accountType.value == 'user') {
      Get.offAllNamed('/UserMainBottomNavigationBarWidget');
    } else if (accountType.value == 'seller') {
      Get.offAllNamed('/SellerMainBottomNavigationBarWidget');
    } else {
      Get.offAllNamed('/AccountTypeSelection');
    }
  }

  String getSignInRoute() {
    if (accountType.value == 'user') {
      return '/UserSignInScreen';
    } else if (accountType.value == 'seller') {
      return '/SellerSignInScreen';
    } else {
      return '/AccountTypeSelection';
    }
  }

  String getAccountTypeDisplayName() {
    switch (accountType.value) {
      case 'user':
        return 'User Account'.tr;
      case 'seller':
        return 'Store Owner'.tr;
      default:
        return 'No Account'.tr;
    }
  }

  bool isAccountType(String type) {
    return accountType.value == type;
  }
}
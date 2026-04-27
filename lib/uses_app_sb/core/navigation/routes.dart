// app_routes.dart
import 'package:advertising_user/AccountTypeSelectionScreen.dart';
import 'package:advertising_user/uses_app_sb/features/about_app/about_us_screen.dart';
import 'package:advertising_user/uses_app_sb/features/about_app/data_policy_screen.dart';
import 'package:advertising_user/uses_app_sb/features/about_app/licensing_screen.dart';
import 'package:advertising_user/uses_app_sb/features/about_app/privacy_policy.dart';
import 'package:advertising_user/uses_app_sb/features/about_app/terms_service.dart';
import 'package:advertising_user/uses_app_sb/features/app_support/view/app_support_screen.dart';
import 'package:advertising_user/uses_app_sb/features/auth/on_boarding/on_boarding_screen.dart';
import 'package:advertising_user/uses_app_sb/features/blocked_stores/view/blocked_stores_screen.dart';
import 'package:advertising_user/uses_app_sb/features/main_bottom_navigation_bar/view/main_bottom_navigation_widget.dart';
import 'package:advertising_user/uses_app_sb/features/store_by_category/controller/advertizing_by_category_binding.dart';
import 'package:advertising_user/uses_app_sb/features/store_by_category/view/advertizing_by_category_screen.dart';
import 'package:advertising_user/uses_app_sb/features/empty_screen/empty_screen.dart';
import 'package:advertising_user/uses_app_sb/features/force_update/force_update_screen.dart';
import 'package:advertising_user/uses_app_sb/features/posts/view/posts_screen.dart';
import 'package:advertising_user/uses_app_sb/features/auth/sign_in/controller/sign_in_binding.dart';
import 'package:advertising_user/uses_app_sb/features/auth/sign_in/view/sign_in_screen.dart';
import 'package:advertising_user/uses_app_sb/features/main_bottom_navigation_bar/controller/main_bottom_navigation_binding.dart';

import 'package:advertising_user/uses_app_sb/core/shared/widgets/loaders/combined_loaders.dart';

import 'package:advertising_user/seller_sb/features/adverise/add_advertise/view/add_advertise_screen.dart';
import 'package:advertising_user/seller_sb/features/auth/sign_in/controller/sign_in_binding.dart' as SellerSignInBinding;
import 'package:advertising_user/seller_sb/features/auth/sign_in/view/sign_in_screen.dart' as SellerSignIn;
import 'package:advertising_user/seller_sb/features/auth/sign_up/view/sign_up_screen.dart' as SellerSignUp;
import 'package:advertising_user/seller_sb/features/main_bottom_navigation_bar/controller/main_bottom_navigation_binding.dart' as SellerMainBinding;
import 'package:advertising_user/seller_sb/features/main_bottom_navigation_bar/view/main_bottom_navigation_widget.dart' as SellerMainNav;
import 'package:advertising_user/seller_sb/features/points/recharge_points/view/recharge_points_secreen.dart';
import 'package:advertising_user/seller_sb/features/posts/add_post/view/add_post_screen.dart';
import 'package:advertising_user/seller_sb/features/setting/view/edit_account_screen.dart' as SellerEditAccount;
import 'package:advertising_user/uses_app_sb/features/setting/view/edit_account_screen.dart' as UserEditAccount;

import 'package:get/get.dart';

import '../../../seller_sb/features/auth/sign_up/controller/sing_up_binding.dart';
import '../../features/store_detailes/view/store_detailes.dart';

appRoutes() => [
  GetPage(
    name: '/',
    page: () => const OnBoardingScreen(),
  ),

  GetPage(
    name: '/AccountTypeSelection',
    page: () => const AccountTypeSelectionScreen(),
  ),

  GetPage(
    name: '/UserSignInScreen',
    page: () => SignInScreen(),
    binding: SignInBinding(),
  ),

  GetPage(
    name: '/SellerSignInScreen',
    page: () => SellerSignIn.SignInScreen(),
    binding: SellerSignInBinding.SignInBinding(),
  ),

  GetPage(
    name: '/SellerSignUpScreen',
    page: () => SellerSignUp.SignUpScreen(),
    binding: SignUpBinding(),
  ),

  GetPage(
    name: '/UserMainBottomNavigationBarWidget',
    page: () => MainBottomNavigationBarWidget(),
    binding: MainBottomNavigationBinding(),
  ),

  GetPage(
    name: '/SellerMainBottomNavigationBarWidget',
    page: () => SellerMainNav.MainBottomNavigationBarWidget(),
    binding: SellerMainBinding.MainBottomNavigationBinding(),
  ),

  GetPage(
    name: '/PostsScreen',
    page: () => const PostsScreen(),
  ),

  GetPage(
    name: '/StoreDetailsPage',
    page: () => StoreDetailsPage(),
  ),

  GetPage(
    name: '/StoreListScreen',
    page: () => StoreListScreen(),
    binding: AdvertizingByCategoryBinding(),
  ),

  GetPage(
    name: '/AddPostScreen',
    page: () => AddPostScreen(),
  ),

  GetPage(
    name: '/AddAdvertiseScreen',
    page: () => AddAdvertiseScreen(),
  ),

  GetPage(
    name: '/RechargePointsScreen',
    page: () => RechargePointsScreen(),
  ),

  GetPage(
    name: '/SellerEditAccountScreen',
    page: () => SellerEditAccount.EditAccountScreen(),
  ),

  GetPage(
    name: '/UserEditAccountScreen',
    page: () => UserEditAccount.EditAccountScreen(),
  ),

  GetPage(
    name: '/EmptyScreen',
    page: () => const EmptyScreen(),
  ),

  GetPage(
    name: '/ForceUpdateScreen',
    page: () => const ForceUpdateScreen(),
  ),

  GetPage(
    name: '/AboutUsScreen',
    page: () => const AboutUsScreen(),
  ),

  GetPage(
    name: '/LicensingScreen',
    page: () => const LicensingScreen(),
  ),

  GetPage(
    name: '/DataPolicyScreen',
    page: () => const DataPolicyScreen(),
  ),

  GetPage(
    name: '/TermsService',
    page: () => const TermsService(),
  ),

  GetPage(
    name: '/PrivacyPolicy',
    page: () => const PrivacyPolicy(),
  ),

  GetPage(
    name: '/AppSupportScreen',
    page: () => const AppSupportScreen(),
  ),

  GetPage(
    name: '/BlockedStoresScreen',
    page: () => const BlockedStoresScreen(),
  ),

  GetPage(
    name: '/SignInScreen',
    page: () => const AccountTypeSelectionScreen(),
  ),

  GetPage(
    name: '/MainBottomNavigationBarWidget',
    page: () => const AccountTypeSelectionScreen(),
  ),


];
import 'package:advertising_user/uses_app_sb/core/services/responsive.dart';
import 'package:advertising_user/uses_app_sb/core/shared/functions/validation/phone_validation.dart';
import 'package:advertising_user/uses_app_sb/core/shared/widgets/bottom_sheet/show_bottom_sheet.dart';
import 'package:advertising_user/uses_app_sb/core/theme/app_theme.dart';
import 'package:advertising_user/uses_app_sb/features/auth/sign_in/controller/sign_in_controller.dart';
import 'package:advertising_user/uses_app_sb/features/auth/sign_up/controller/sign_up_controller.dart';
import 'package:advertising_user/uses_app_sb/features/auth/sign_up/view/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:advertising_user/uses_app_sb/core/shared/functions/helper/divide.dart';
import 'package:advertising_user/uses_app_sb/core/shared/functions/validation/name_validation.dart';
import 'package:advertising_user/main.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/shared/functions/validation/password_validation.dart';
import '../../../../core/shared/widgets/buttons/button_widget.dart';
import '../../../../core/shared/widgets/text_fields/app_text_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final SignInController signInController = Get.find<SignInController>();

  // Cache color values to avoid repeated withOpacity() calls
  static const Color _primaryColor = Color(0xFF9C7FE8); // Soft lavender purple
  static const Color _secondaryColor = Color(0xFFB399F5); // Light purple

  final Color _backButtonBg = Colors.white.withOpacity(0.2);
  final Color _subtitleColor = Colors.white.withOpacity(0.9);
  final Color _glassBorder = Colors.white.withOpacity(0.3);
  final Color _glassButtonBg = Colors.white.withOpacity(0.2);
  final Color _dividerColor = Colors.white.withOpacity(0.3);
  final Color _orTextColor = Colors.white.withOpacity(0.8);
  final Color _shadowColor = Colors.black.withOpacity(0.1);
  final Color _buttonShadowColor = Colors.black.withOpacity(0.15);

  Future<bool> _onWillPop() async {
    // Check if we can go back
    if (Navigator.of(context).canPop()) {
      return true;
    }

    // Show exit confirmation dialog
    final result = await Get.dialog<bool>(
      _ExitConfirmationDialog(),
      barrierDismissible: false,
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    appTheme = AppTheme.of(context);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final shouldPop = await _onWillPop();
          if (shouldPop && context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        body: RepaintBoundary(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _primaryColor,
                  _secondaryColor,
                ],
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  // Back button
                  Positioned(
                    top: 16.h,
                    left: 16.w,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _backButtonBg,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.white, size: 24),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ),
                  ),
                  // Content
                  SingleChildScrollView(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 80.h),
                    child: Form(
                      key: signInController.formstate,
                      child: Column(
                        children: [
                          // Logo/Brand
                          RepaintBoundary(
                            child: Column(
                              children: [
                                Container(
                                  width: 90.w,
                                  height: 90.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: _shadowColor,
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.storefront_rounded,
                                    size: 50.sp,
                                    color: _primaryColor,
                                  ),
                                ),
                                SizedBox(height: 24.h),
                                const Text(
                                  "Welcome Back!",
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  "Sign in to continue".tr,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: _subtitleColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 50.h),
                          // Phone Number Field
                          _buildGlassField(
                            child: AppTextField(
                              hint: "Phone Number".tr,
                              keyboardType: TextInputType.number,
                              validator: (value) => phoneValidation(value),
                              controller: signInController.phoneController,
                            ),
                          ),
                          SizedBox(height: 16.h),

                          // Password Field
                          _buildGlassField(
                            child: AppTextField(
                              isPassWordVisible: true,
                              hint: "Password".tr,
                              validator: (value) => passwordValidation(value),
                              controller: signInController.passwordController,
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // Forget Password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: null,
                              child: const Text(
                                "Forgot password?",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // Login Button
                          Obx(
                            () => _buildGradientButton(
                              text: 'Log in'.tr,
                              onPressed: () {
                                signInController.onPressContinue();
                              },
                              isLoading: signInController.isLoading.value,
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // Sign Up Button
                          _buildGlassButton(
                            text: 'Create new account'.tr,
                            onPressed: () async {
                              Get.lazyPut(() => SignUpController());
                              await Get.to(() => SignUpScreen())?.then(
                                  (value) => Get.delete<SignUpController>());
                            },
                            icon: Icons.person_add_outlined,
                            textColor: Colors.white,
                          ),
                          SizedBox(height: 40.h),

                          // Divider with "OR"
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: _dividerColor,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Text(
                                  "OR".tr,
                                  style: TextStyle(
                                    color: _orTextColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: _dividerColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30.h),

                          // Store Owner Link
                          _buildGlassButton(
                            text: 'Login as Store Owner'.tr,
                            onPressed: () {
                              Get.delete<SignInController>();
                              Get.offNamed('/SellerSignInScreen');
                            },
                            icon: Icons.store_outlined,
                            textColor: Colors.white,
                          ),
                          SizedBox(height: 20.h),

                          TextButton(
                            onPressed: () {
                              Get.delete<SignInController>();
                              Get.offAllNamed(
                                  '/UserMainBottomNavigationBarWidget');
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  color: _subtitleColor,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Continue without logging in'.tr,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: _subtitleColor,
                                    decorationColor: _subtitleColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 40.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassField({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: _shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildGradientButton({
    required String text,
    required VoidCallback onPressed,
    required bool isLoading,
  }) {
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: _buttonShadowColor,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
      ),
    );
  }

  Widget _buildGlassButton({
    required String text,
    required VoidCallback onPressed,
    required IconData icon,
    Color? textColor,
  }) {
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        color: _glassButtonBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: _glassBorder,
          width: 1.5,
        ),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor ?? Colors.white, size: 22),
            SizedBox(width: 10.w),
            Text(
              text,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: textColor ?? Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Beautiful exit confirmation dialog
class _ExitConfirmationDialog extends StatelessWidget {
  static const Color _primaryColor = Color(0xFF9C7FE8); // Soft lavender purple
  static const Color _secondaryColor = Color(0xFFB399F5); // Light purple

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_primaryColor, _secondaryColor],
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 70.w,
              height: 70.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.exit_to_app_rounded,
                size: 40.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20.h),

            // Title
            const Text(
              "Exit App?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12.h),

            // Message
            Text(
              "Are you sure you want to exit the application?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.9),
                height: 1.4,
              ),
            ),
            SizedBox(height: 30.h),

            // Buttons
            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: TextButton(
                      onPressed: () => Get.back(result: false),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),

                // Exit Button
                Expanded(
                  child: Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () => Get.back(result: true),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: const Text(
                        "Exit",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

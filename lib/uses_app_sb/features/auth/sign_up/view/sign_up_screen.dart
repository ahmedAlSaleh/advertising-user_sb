import 'package:advertising_user/uses_app_sb/core/shared/functions/validation/email_validation.dart';
import 'package:advertising_user/uses_app_sb/core/shared/functions/validation/name_validation.dart';
import 'package:advertising_user/uses_app_sb/core/shared/functions/validation/password_validation.dart';
import 'package:advertising_user/uses_app_sb/core/shared/functions/validation/phone_validation.dart';
import 'package:advertising_user/uses_app_sb/core/shared/widgets/text_fields/app_text_field.dart';
import 'package:advertising_user/uses_app_sb/features/auth/sign_up/controller/sign_up_controller.dart';
import 'package:advertising_user/uses_app_sb/features/auth/sign_up/view/widgets/terms_and_condision_texts.dart';
import 'package:advertising_user/main.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SignUpController signUpController = Get.find<SignUpController>();


  static const Color _primaryColor = Color(0xFF9C7FE8); // Soft lavender purple
  static const Color _secondaryColor = Color(0xFFB399F5); // Light purple

  final Color _backButtonBg = Colors.white.withOpacity(0.2);
  final Color _subtitleColor = Colors.white.withOpacity(0.9);
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
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                ),
                // Content
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 80.h),
                  child: Form(
                    key: signUpController.formstate,
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
                                  Icons.person_add_rounded,
                                  size: 50.sp,
                                  color: _primaryColor,
                                ),
                              ),
                              SizedBox(height: 24.h),
                              const Text(
                                "Create Account",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                "Sign up to get started".tr,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: _subtitleColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40.h),

                        // User Name Field
                        _buildWhiteField(
                          child: AppTextField(
                            hint: "User name".tr,
                            validator: (value) => nameValidation(value),
                            controller: signUpController.nameController,
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Email Field
                        _buildWhiteField(
                          child: AppTextField(
                            hint: "Email".tr,
                            validator: (value) => emailValidation(value),
                            controller: signUpController.emailController,
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Phone Field
                        _buildWhiteField(
                          child: AppTextField(
                            hint: "Phone Number".tr,
                            keyboardType: TextInputType.number,
                            validator: (value) => phoneValidation(value),
                            controller: signUpController.phoneController,
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Password Field
                        _buildWhiteField(
                          child: AppTextField(
                            hint: "Password".tr,
                            isPassWordVisible: true,
                            validator: (value) => passwordValidation(value),
                            controller: signUpController.passwordController,
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Confirm Password Field
                        _buildWhiteField(
                          child: AppTextField(
                            hint: "Confirm Password".tr,
                            isPassWordVisible: true,
                            validator: (value) {
                              if (value != signUpController.passwordController.text) {
                                return "Passwords do not match".tr;
                              }
                              return null;
                            },
                            controller: signUpController.confirmPasswordController,
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // Terms and Conditions
                          TermsAndCondisionTexts(),
                        SizedBox(height: 24.h),

                        // Create Account Button
                        Obx(
                          () => _buildGradientButton(
                            text: 'Create my account'.tr,
                            onPressed: () {
                              signUpController.onPressContinue();
                            },
                            isLoading: signUpController.isLoading.value,
                          ),
                        ),
                        SizedBox(height: 20.h),


                        TextButton(
                          onPressed: () {
                            Get.delete<SignUpController>();
                            Get.offAllNamed('/UserMainBottomNavigationBarWidget');
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

  Widget _buildWhiteField({required Widget child}) {
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

// sign_in_screen.dart
import 'package:advertising_user/seller_sb/features/auth/sign_in/controller/sign_in_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../uses_app_sb/core/shared/functions/validation/password_validation.dart';
import '../../../../../uses_app_sb/core/shared/functions/validation/phone_validation.dart';
import '../../../../../uses_app_sb/core/shared/widgets/text_fields/app_text_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final SignInController signInController = Get.find<SignInController>();

  // Cache color values to avoid repeated withOpacity() calls
  late final Color _backButtonBg;
  late final Color _subtitleColor;
  late final Color _shadowColor;
  late final Color _buttonShadowColor;
  late final Color _dividerColor;
  late final Color _orTextColor;
  late final Color _glassButtonBg;
  late final Color _glassButtonBorder;

  // Cache BorderRadius values
  late final BorderRadius _fieldRadius;
  late final BorderRadius _buttonRadius;

  @override
  void initState() {
    super.initState();
    _backButtonBg = Colors.white.withOpacity(0.2);
    _subtitleColor = Colors.white.withOpacity(0.9);
    _shadowColor = Colors.black.withOpacity(0.1);
    _buttonShadowColor = Colors.black.withOpacity(0.15);
    _dividerColor = Colors.white.withOpacity(0.3);
    _orTextColor = Colors.white.withOpacity(0.8);
    _glassButtonBg = Colors.white.withOpacity(0.2);
    _glassButtonBorder = Colors.white.withOpacity(0.3);
    _fieldRadius = BorderRadius.circular(16.r);
    _buttonRadius = BorderRadius.circular(16.r);
  }

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
                Color(0xFF4ECDC4), // Soft teal
                Color(0xFF44A08D), // Mint green
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
                      icon:
                          const Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
                      onPressed: () => Get.back(),
                    ),
                  ),
                ),
                // Content
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 80.h),
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
                                  Icons.store_rounded,
                                  size: 50.sp,
                                  color: const Color(0xFF4ECDC4),
                                ),
                              ),
                              SizedBox(height: 24.h),
                              const Text(
                                "Store Owner",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                "Sign in to manage your store".tr,
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
                            keyboardType: TextInputType.number,
                            hint: "Store owner number".tr,
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
                            onPressed: () {},
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
                          text: 'Create new store account'.tr,
                          onPressed: () {
                            Get.toNamed('/SellerSignUpScreen');
                          },
                          icon: Icons.store_outlined,
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

                        // User Login Link
                        _buildGlassButton(
                          text: 'Login as User'.tr,
                          onPressed: () {
                            Get.delete<SignInController>();
                            Get.offNamed('/UserSignInScreen');
                          },
                          icon: Icons.person_outline,
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
        borderRadius: _fieldRadius,
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
        gradient: const LinearGradient(
          colors: [Colors.white, Colors.white],
        ),
        borderRadius: _buttonRadius,
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
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: _buttonRadius,
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4ECDC4)),
                ),
              )
            : const Text(
                'Log in',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4ECDC4),
                ),
              ),
      ),
    );
  }

  Widget _buildGlassButton({
    required String text,
    required VoidCallback onPressed,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        color: _glassButtonBg,
        borderRadius: _buttonRadius,
        border: Border.all(
          color: _glassButtonBorder,
          width: 1.5,
        ),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: _buttonRadius,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            SizedBox(width: 10.w),
            Text(
              text,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.white,
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
  static const Color _primaryColor = Color(0xFF4ECDC4); // Soft teal
  static const Color _secondaryColor = Color(0xFF44A08D); // Mint green

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

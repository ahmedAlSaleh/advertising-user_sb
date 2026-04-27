import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:advertising_user/seller_sb/core/shared/models/city.dart';
import 'package:advertising_user/seller_sb/features/auth/sign_up/controller/sign_up_controller.dart';
import 'package:advertising_user/seller_sb/features/auth/sign_up/view/widgets/step_indicator.dart';
import 'package:advertising_user/seller_sb/features/auth/sign_up/view/widgets/terms_and_condision_texts.dart';
import 'package:advertising_user/main.dart';

import '../../../../../uses_app_sb/core/shared/functions/validation/name_validation.dart';
import '../../../../../uses_app_sb/core/shared/functions/validation/password_validation.dart';
import '../../../../../uses_app_sb/core/shared/functions/validation/phone_validation.dart';
import '../../../../../uses_app_sb/core/shared/models/store_category.dart';
import '../../../../../uses_app_sb/core/shared/widgets/buttons/button_widget.dart';
import '../../../../../uses_app_sb/core/shared/widgets/text_fields/app_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SignUpController signUpController = Get.find<SignUpController>();

  Future<bool> _onWillPop() async {
    if (signUpController.currentStep.value == 2) {
      signUpController.onPressPreviousStep();
      return false;
    }

    if (Navigator.of(context).canPop()) {
      return true;
    }

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
        backgroundColor: appTheme.primaryBackground,
        body: CustomScrollView(
          slivers: [
            // Beautiful Gradient Header
            SliverAppBar(
              expandedHeight: 180.h,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: Obx(() => signUpController.currentStep.value == 2
                  ? IconButton(
                      icon: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                      ),
                      onPressed: () => signUpController.onPressPreviousStep(),
                    )
                  : const SizedBox.shrink()),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        appTheme.primary,
                        appTheme.primary.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.r),
                      bottomRight: Radius.circular(30.r),
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 24.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Icon(
                                  Icons.store_rounded,
                                  color: Colors.white,
                                  size: 28.sp,
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Register Your Store'.tr,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      'Join our merchant community'.tr,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(height: 24.h),

                    // Step Indicator
                    Obx(() => StepIndicator(
                          currentStep: signUpController.currentStep.value,
                          totalSteps: 2,
                        )),

                    SizedBox(height: 32.h),

                    // Step Content
                    Obx(() {
                      if (signUpController.currentStep.value == 1) {
                        return _buildStep1();
                      } else {
                        return _buildStep2();
                      }
                    }),

                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Step 1: Store Information
  Widget _buildStep1() {
    return Form(
      key: signUpController.formstateStep1,
      child: Column(
        children: [
          // Section Header
          _SectionHeader(
            icon: Icons.info_outline_rounded,
            title: "Store Information".tr,
            subtitle: "Tell us about your business".tr,
          ),
          SizedBox(height: 24.h),

          // Category Selection
          Obx(() {
            if (signUpController.isLoadingFetchingCateogires.value) {
              return _LoadingCard(message: 'Loading categories'.tr);
            } else if (signUpController.storesCategory.isEmpty) {
              return _ErrorCard(message: 'Failed to load categories'.tr);
            } else {
              return _ModernCategoryDropdown(
                signUpController: signUpController,
              );
            }
          }),
          SizedBox(height: 16.h),

          // Subcategories Section
          Obx(() {
            if (signUpController.selectedCategory.value != null &&
                signUpController.selectedCategory.value!.subCategories != null &&
                signUpController.selectedCategory.value!.subCategories!.isNotEmpty) {
              return Column(
                children: [
                  _ModernSubcategoriesSection(
                    signUpController: signUpController,
                  ),
                  SizedBox(height: 16.h),
                ],
              );
            }
            return const SizedBox.shrink();
          }),

          // Store Name
          _ModernTextField(
            hint: "Store name".tr,
            icon: Icons.storefront_rounded,
            validator: (value) => nameValidation(value),
            controller: signUpController.storeNameController,
          ),
          SizedBox(height: 16.h),

          // Owner Name
          _ModernTextField(
            hint: "Store owner name".tr,
            icon: Icons.person_outline_rounded,
            validator: (value) => nameValidation(value),
            controller: signUpController.storeOwnerNameController,
          ),
          SizedBox(height: 16.h),

          // Store Number
          _ModernTextField(
            hint: "Store number".tr,
            icon: Icons.phone_outlined,
            validator: (value) => phoneValidation(value),
            controller: signUpController.storeNumberController,
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 16.h),

          // City Dropdown
          Obx(() {
            if (signUpController.isLoadingCities.value) {
              return _LoadingCard(message: 'Loading cities'.tr);
            } else if (signUpController.cities.isEmpty) {
              return _ErrorCard(message: 'Failed to load cities'.tr);
            } else {
              return _ModernCityDropdown(
                signUpController: signUpController,
              );
            }
          }),
          SizedBox(height: 16.h),

          // Image Upload Section
          _ModernImageUploadSection(
            signUpController: signUpController,
          ),

          SizedBox(height: 32.h),

          // Next Button
          _ModernGradientButton(
            onPressed: () => signUpController.onPressNextStep(),
            text: 'Continue'.tr,
            icon: Icons.arrow_forward_rounded,
          ),
        ],
      ),
    );
  }

  // Step 2: Owner Contact & Account
  Widget _buildStep2() {
    return Form(
      key: signUpController.formstateStep2,
      child: Column(
        children: [
          // Section Header
          _SectionHeader(
            icon: Icons.lock_outline_rounded,
            title: "Account Information".tr,
            subtitle: "Secure your merchant account".tr,
          ),
          SizedBox(height: 24.h),

          // Owner Contact Number
          _ModernTextField(
            hint: "Store owner number".tr,
            icon: Icons.phone_android_rounded,
            keyboardType: TextInputType.phone,
            validator: (value) => phoneValidation(value),
            controller: signUpController.storeOwnerNumberController,
          ),
          SizedBox(height: 16.h),

          // Password
          _ModernTextField(
            hint: "Password".tr,
            icon: Icons.lock_outline_rounded,
            obscureText: true,
            validator: (value) => passwordValidation(value),
            controller: signUpController.passwordController,
          ),
          SizedBox(height: 16.h),

          // Confirm Password
          _ModernTextField(
            hint: "Confirm Password".tr,
            icon: Icons.lock_outline_rounded,
            obscureText: true,
            validator: (value) {
              if (value != signUpController.passwordController.text) {
                return "Passwords do not match".tr;
              }
              return passwordValidation(value);
            },
            controller: signUpController.passwordConfirmationController,
          ),
          SizedBox(height: 24.h),

          // Terms and Conditions
          TermsAndCondisionTexts(),
          SizedBox(height: 32.h),

          // Register Button
          Obx(
            () => _ModernGradientButton(
              onPressed: () => signUpController.onPressContinue(),
              text: 'Create Account'.tr,
              icon: Icons.check_circle_outline_rounded,
              isLoading: signUpController.isLoading.value,
            ),
          ),
        ],
      ),
    );
  }
}

// Modern Section Header Widget
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            appTheme.primary.withOpacity(0.1),
            appTheme.primary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: appTheme.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  appTheme.primary,
                  appTheme.primary.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: appTheme.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: appTheme.primaryText,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: appTheme.secondaryText,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Modern TextField Widget
class _ModernTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;

  const _ModernTextField({
    required this.hint,
    required this.icon,
    required this.validator,
    required this.controller,
    this.keyboardType,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: appTheme.secondaryBackground,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: TextStyle(
          color: appTheme.primaryText,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: appTheme.secondaryText.withOpacity(0.6),
            fontSize: 14.sp,
          ),
          prefixIcon: Container(
            margin: EdgeInsets.all(12.w),
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  appTheme.primary.withOpacity(0.2),
                  appTheme.primary.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              icon,
              color: appTheme.primary,
              size: 20.sp,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(
              color: appTheme.primary.withOpacity(0.5),
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(
              color: Colors.red.withOpacity(0.5),
              width: 2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

// Modern Gradient Button
class _ModernGradientButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData icon;
  final bool isLoading;

  const _ModernGradientButton({
    required this.onPressed,
    required this.text,
    required this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            appTheme.primary,
            appTheme.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: appTheme.primary.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: isLoading
                ? Center(
                    child: SizedBox(
                      width: 24.w,
                      height: 24.h,
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        text,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        icon,
                        color: Colors.white,
                        size: 22.sp,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

// Loading Card Widget
class _LoadingCard extends StatelessWidget {
  final String message;

  const _LoadingCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: appTheme.secondaryBackground,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20.w,
            height: 20.h,
            child: CircularProgressIndicator(
              color: appTheme.primary,
              strokeWidth: 2.5,
            ),
          ),
          SizedBox(width: 16.w),
          Text(
            message,
            style: TextStyle(
              color: appTheme.secondaryText,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Error Card Widget
class _ErrorCard extends StatelessWidget {
  final String message;

  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.red.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: Colors.red,
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.red,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Modern Category Dropdown
class _ModernCategoryDropdown extends StatelessWidget {
  final SignUpController signUpController;

  const _ModernCategoryDropdown({
    required this.signUpController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 12.h),
          child: Row(
            children: [
              Icon(
                Icons.category_rounded,
                color: appTheme.primary,
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Store Category'.tr,
                style: TextStyle(
                  color: appTheme.primaryText,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: appTheme.secondaryBackground,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: DropdownButtonFormField<Datum>(
            value: signUpController.selectedCategory.value,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 18.h,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
            ),
            dropdownColor: appTheme.secondaryBackground,
            style: TextStyle(
              color: appTheme.primaryText,
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
            hint: Text(
              'Select category'.tr,
              style: TextStyle(
                color: appTheme.secondaryText.withOpacity(0.6),
                fontSize: 14.sp,
              ),
            ),
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: appTheme.primary,
              size: 24.sp,
            ),
            isExpanded: true,
            menuMaxHeight: 300.h,
            items: signUpController.storesCategory.map((category) {
              return DropdownMenuItem<Datum>(
                value: category,
                child: Text(
                  category.name,
                  style: TextStyle(
                    color: appTheme.primaryText,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              signUpController.onCategoryChanged(value);
            },
            validator: (value) {
              if (value == null) {
                return 'Please select a category'.tr;
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}

// Modern City Dropdown
class _ModernCityDropdown extends StatelessWidget {
  final SignUpController signUpController;

  const _ModernCityDropdown({
    required this.signUpController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 12.h),
          child: Row(
            children: [
              Icon(
                Icons.location_city_rounded,
                color: appTheme.primary,
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'City'.tr,
                style: TextStyle(
                  color: appTheme.primaryText,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: appTheme.secondaryBackground,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: DropdownButtonFormField<City>(
            value: signUpController.selectedCity.value,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 18.h,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
            ),
            dropdownColor: appTheme.secondaryBackground,
            style: TextStyle(
              color: appTheme.primaryText,
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
            hint: Text(
              'Select city'.tr,
              style: TextStyle(
                color: appTheme.secondaryText.withOpacity(0.6),
                fontSize: 14.sp,
              ),
            ),
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: appTheme.primary,
              size: 24.sp,
            ),
            isExpanded: true,
            menuMaxHeight: 300.h,
            items: signUpController.cities.map((city) {
              return DropdownMenuItem<City>(
                value: city,
                child: Text(
                  city.name,
                  style: TextStyle(
                    color: appTheme.primaryText,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                signUpController.selectedCity.value = value;
              }
            },
            validator: (value) {
              if (value == null) {
                return 'Please select a city'.tr;
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}

// Modern Subcategories Section
class _ModernSubcategoriesSection extends StatelessWidget {
  final SignUpController signUpController;

  const _ModernSubcategoriesSection({
    required this.signUpController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 12.h),
          child: Row(
            children: [
              Icon(
                Icons.grid_view_rounded,
                color: appTheme.primary,
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Select Subcategories'.tr,
                style: TextStyle(
                  color: appTheme.primaryText,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: appTheme.secondaryBackground,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: EdgeInsets.all(16.w),
          child: Obx(() {
            final subCategories =
                signUpController.selectedCategory.value?.subCategories ?? [];

            return Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: subCategories.map((subCategory) {
                return Obx(() {
                  final isSelected = signUpController.selectedSubCategoryIds
                      .contains(subCategory.id);

                  return GestureDetector(
                    onTap: () {
                      signUpController.toggleSubCategory(subCategory.id);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(
                        horizontal: 18.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  appTheme.primary,
                                  appTheme.primary.withOpacity(0.8),
                                ],
                              )
                            : null,
                        color: isSelected
                            ? null
                            : appTheme.primaryText.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(25.r),
                        border: Border.all(
                          color: isSelected
                              ? Colors.white.withOpacity(0.5)
                              : appTheme.primaryText.withOpacity(0.15),
                          width: isSelected ? 2 : 1.5,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: appTheme.primary.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isSelected
                                ? Icons.check_circle_rounded
                                : Icons.radio_button_unchecked,
                            size: 18.sp,
                            color: isSelected
                                ? Colors.white
                                : appTheme.secondaryText,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            subCategory.name,
                            style: TextStyle(
                              color:
                                  isSelected ? Colors.white : appTheme.primaryText,
                              fontSize: 13.sp,
                              fontWeight:
                                  isSelected ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
              }).toList(),
            );
          }),
        ),
      ],
    );
  }
}

// Modern Image Upload Section
class _ModernImageUploadSection extends StatelessWidget {
  final SignUpController signUpController;

  const _ModernImageUploadSection({
    required this.signUpController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 12.h),
          child: Row(
            children: [
              Icon(
                Icons.add_photo_alternate_rounded,
                color: appTheme.primary,
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Store Image'.tr,
                style: TextStyle(
                  color: appTheme.primaryText,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: appTheme.secondaryText.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'Optional'.tr,
                  style: TextStyle(
                    color: appTheme.secondaryText,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        Obx(() {
          if (signUpController.selectedImage.value != null) {
            // Image Preview
            return Container(
              decoration: BoxDecoration(
                color: appTheme.secondaryBackground,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: appTheme.primary.withOpacity(0.15),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
                border: Border.all(
                  color: appTheme.primary.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(14.r),
                      topRight: Radius.circular(14.r),
                    ),
                    child: Stack(
                      children: [
                        Image.file(
                          signUpController.selectedImage.value!,
                          height: 220.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 12.h,
                          right: 12.w,
                          child: Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check_circle_rounded,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Buttons
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              signUpController.removeSelectedImage();
                            },
                            icon: const Icon(Icons.delete_outline_rounded),
                            label: Text('Remove'.tr),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: BorderSide(color: Colors.red, width: 1.5),
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              signUpController.showImageSourceDialog();
                            },
                            icon: const Icon(Icons.edit_rounded),
                            label: Text('Change'.tr),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: appTheme.primary,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Upload Button
            return GestureDetector(
              onTap: () {
                signUpController.showImageSourceDialog();
              },
              child: Container(
                height: 200.h,
                decoration: BoxDecoration(
                  color: appTheme.secondaryBackground,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: appTheme.primaryText.withOpacity(0.15),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            appTheme.primary.withOpacity(0.15),
                            appTheme.primary.withOpacity(0.05),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add_a_photo_rounded,
                        size: 40.sp,
                        color: appTheme.primary,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Upload Store Image'.tr,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: appTheme.primaryText,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_rounded,
                          size: 16.sp,
                          color: appTheme.secondaryText,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Camera',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: appTheme.secondaryText,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          '•',
                          style: TextStyle(
                            color: appTheme.secondaryText,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Icon(
                          Icons.photo_library_rounded,
                          size: 16.sp,
                          color: appTheme.secondaryText,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Gallery',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: appTheme.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        }),
      ],
    );
  }
}

// Beautiful exit confirmation dialog
class _ExitConfirmationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: EdgeInsets.all(28.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              appTheme.primary,
              appTheme.primary.withOpacity(0.85),
            ],
          ),
          borderRadius: BorderRadius.circular(24.r),
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
                size: 36.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 24.h),

            // Title
            Text(
              "Exit App?".tr,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12.h),

            // Message
            Text(
              "Are you sure you want to exit?".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.white.withOpacity(0.9),
                height: 1.4,
              ),
            ),
            SizedBox(height: 32.h),

            // Buttons
            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: Container(
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: TextButton(
                      onPressed: () => Get.back(result: false),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: Text(
                        "Cancel".tr,
                        style: TextStyle(
                          fontSize: 15.sp,
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
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: TextButton(
                      onPressed: () => Get.back(result: true),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: Text(
                        "Exit".tr,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: appTheme.primary,
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

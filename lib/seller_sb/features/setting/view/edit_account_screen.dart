import 'package:advertising_user/uses_app_sb/core/shared/functions/helper/divide.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:advertising_user/seller_sb/core/shared/models/city.dart';
import 'package:advertising_user/seller_sb/features/setting/controller/edit_account_controller.dart';
import 'package:advertising_user/main.dart';

import '../../../../uses_app_sb/core/shared/functions/validation/name_validation.dart';
import '../../../../uses_app_sb/core/shared/functions/validation/phone_validation.dart';
import '../../../../uses_app_sb/core/shared/models/store_category.dart';
import '../../../../uses_app_sb/core/shared/widgets/app_bar/general_app_bar.dart';
import '../../../../uses_app_sb/core/shared/widgets/buttons/button_widget.dart';
import '../../../../uses_app_sb/core/shared/widgets/loaders/combined_loaders.dart';
import '../../../../uses_app_sb/core/shared/widgets/text_fields/app_text_field.dart';

class EditAccountScreen extends StatelessWidget {
  EditAccountScreen({super.key});
  final EditAccountController editAccountController = Get.put(EditAccountController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.primaryBackground,
      appBar: generalAppBar(
          context: context,
          title: Text(
            'Edit Account'.tr,
            style: appTheme.text16.copyWith(
                color: appTheme.primaryText,
                fontWeight: FontWeight.bold
            ),
          )
      ),
      body: Obx(() {
        if (editAccountController.isLoadingProfile.value) {
          return const Center(
            child: GlowingBoxLoader(message: 'Loading data'),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Form(
            key: editAccountController.formstate,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // // العنوان الرئيسي
                Text(
                  "Edit Your Store Information".tr,
                  style: appTheme.text18.copyWith(
                      fontWeight: FontWeight.bold,
                      color: appTheme.primaryText
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 24.h),

                // Category Dropdown
                Obx(() {
                  if (editAccountController.isLoadingFetchingCateogires.value) {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: CircularProgressIndicator(
                        color: appTheme.primary,
                      ),
                    );
                  } else if (editAccountController.storesCategory.isEmpty) {
                    return Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: appTheme.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        'Failed to load categories'.tr,
                        style: appTheme.text14.copyWith(color: appTheme.error),
                      ),
                    );
                  } else {
                    return Container(
                      margin: EdgeInsets.only(bottom: 16.h),
                      decoration: BoxDecoration(
                        color: appTheme.secondaryBackground,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: appTheme.primary.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      child: DropdownButtonFormField<Datum>(
                        value: editAccountController.selectedCategory.value,
                        decoration: InputDecoration(
                          labelText: 'Select Store Category'.tr,
                          labelStyle: appTheme.text14.copyWith(
                            color: appTheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                          prefixIcon: Icon(
                            Icons.category_rounded,
                            color: appTheme.primary,
                            size: 22.sp,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 16.h,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: appTheme.error,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: appTheme.error,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                        ),
                        dropdownColor: appTheme.secondaryBackground,
                        style: appTheme.text14.copyWith(
                          color: appTheme.primaryText,
                          fontWeight: FontWeight.w500,
                        ),
                        hint: Row(
                          children: [
                            Icon(
                              Icons.category_outlined,
                              size: 18.sp,
                              color: appTheme.secondaryText.withOpacity(0.6),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Select Store Category'.tr,
                              style: appTheme.text14.copyWith(
                                color: appTheme.secondaryText.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: appTheme.primary,
                          size: 28.sp,
                        ),
                        menuMaxHeight: 200.h,
                        items: editAccountController.storesCategory.map((category) {
                          return DropdownMenuItem<Datum>(
                            value: category,
                            child: Text(
                              category.name,
                              style: appTheme.text14.copyWith(
                                color: appTheme.primaryText,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          editAccountController.onCategoryChanged(value);
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a category'.tr;
                          }
                          return null;
                        },
                      ),
                    );
                  }
                }),

                // Subcategories Section
                Obx(() {
                  if (editAccountController.selectedCategory.value != null &&
                      editAccountController.selectedCategory.value!.subCategories != null &&
                      editAccountController.selectedCategory.value!.subCategories!.isNotEmpty) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 4.w, bottom: 12.h),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.list_alt_rounded,
                                  color: appTheme.primary,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Select Subcategories'.tr,
                                  style: appTheme.text14.copyWith(
                                    color: appTheme.primaryText,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: appTheme.secondaryBackground,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: appTheme.primaryText.withOpacity(0.15),
                                width: 1.5,
                              ),
                            ),
                            padding: EdgeInsets.all(16.w),
                            child: Obx(() {
                              final subCategories = editAccountController.selectedCategory.value?.subCategories ?? [];

                              return Wrap(
                                spacing: 10.w,
                                runSpacing: 10.h,
                                children: subCategories.map((subCategory) {
                                  return Obx(() {
                                    final isSelected = editAccountController.selectedSubCategoryIds.contains(subCategory.id);

                                    return GestureDetector(
                                      onTap: () {
                                        editAccountController.toggleSubCategory(subCategory.id);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.w,
                                          vertical: 10.h,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: isSelected
                                              ? LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              appTheme.primary,
                                              appTheme.primary.withOpacity(0.85),
                                            ],
                                          )
                                              : null,
                                          color: isSelected ? null : Colors.white.withOpacity(0.05),
                                          borderRadius: BorderRadius.circular(20.r),
                                          border: Border.all(
                                            color: isSelected
                                                ? appTheme.primary
                                                : appTheme.primaryText.withOpacity(0.2),
                                            width: isSelected ? 2 : 1.5,
                                          ),
                                          boxShadow: isSelected
                                              ? [
                                            BoxShadow(
                                              color: appTheme.primary.withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 3),
                                            ),
                                          ]
                                              : null,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              isSelected
                                                  ? Icons.check_circle
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
                                                color: isSelected
                                                    ? Colors.white
                                                    : appTheme.primaryText,
                                                fontSize: 13.sp,
                                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
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
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),

                SizedBox(height: 8.h),

                // حقول الإدخال
                AppTextField(
                    hint: "Store name".tr,
                    validator: (value) {
                      return nameValidation(value);
                    },
                    controller: editAccountController.storeNameController),

                SizedBox(height: 16.h),

                AppTextField(
                    hint: "Store owner name".tr,
                    validator: (value) {
                      return nameValidation(value);
                    },
                    controller: editAccountController.storeOwnerNameController),

                SizedBox(height: 16.h),

                AppTextField(
                    hint: "Store number".tr,
                    validator: (value) {
                      return phoneValidation(value);
                    },
                    controller: editAccountController.storeNumberController),

                SizedBox(height: 16.h),

                AppTextField(
                    hint: "Store owner number".tr,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      return phoneValidation(value);
                    },
                    controller: editAccountController.storeOwnerNumberController),

                SizedBox(height: 16.h),

                // City Dropdown
                Obx(() {
                  if (editAccountController.isLoadingCities.value) {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: CircularProgressIndicator(
                        color: appTheme.primary,
                      ),
                    );
                  } else if (editAccountController.cities.isEmpty) {
                    return Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: appTheme.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        'Failed to load cities'.tr,
                        style: appTheme.text14.copyWith(color: appTheme.error),
                      ),
                    );
                  } else {
                    return Container(
                      margin: EdgeInsets.only(bottom: 16.h),
                      decoration: BoxDecoration(
                        color: appTheme.secondaryBackground,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: appTheme.primary.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      child: DropdownButtonFormField<City>(
                        value: editAccountController.selectedCity.value,
                        decoration: InputDecoration(
                          labelText: 'Select City'.tr,
                          labelStyle: appTheme.text14.copyWith(
                            color: appTheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                          prefixIcon: Icon(
                            Icons.location_city_rounded,
                            color: appTheme.primary,
                            size: 22.sp,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 16.h,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: appTheme.error,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: appTheme.error,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                        ),
                        dropdownColor: appTheme.secondaryBackground,
                        style: appTheme.text14.copyWith(
                          color: appTheme.primaryText,
                          fontWeight: FontWeight.w500,
                        ),
                        hint: Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 18.sp,
                              color: appTheme.secondaryText.withOpacity(0.6),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Select City'.tr,
                              style: appTheme.text14.copyWith(
                                color: appTheme.secondaryText.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: appTheme.primary,
                          size: 28.sp,
                        ),
                        menuMaxHeight: 200.h,
                        items: editAccountController.cities.map((city) {
                          return DropdownMenuItem<City>(
                            value: city,
                            child: Text(
                              city.name,
                              style: appTheme.text14.copyWith(
                                color: appTheme.primaryText,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            editAccountController.selectedCity.value = value;
                          }
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a city'.tr;
                          }
                          return null;
                        },
                      ),
                    );
                  }
                }),

                SizedBox(height: 16.h),

                AppTextField(
                    hint: "WhatsApp number".tr,
                    validator: (value) {
                      return null; // Optional field
                    },
                    controller: editAccountController.whatsappNumberController),

                SizedBox(height: 16.h),

                AppTextField(
                    hint: "Telegram number".tr,
                    validator: (value) {
                      return null; // Optional field
                    },
                    controller: editAccountController.telegramPhoneNumber),

                SizedBox(height: 16.h),

                AppTextField(
                    hint: "Social media link".tr,
                    validator: (value) {
                      return null; // Optional field
                    },
                    controller: editAccountController.socialMediaController),

                SizedBox(height: 32.h),

                // // زر التحديث
                Obx(
                      () => ButtonWidget(
                    showLoadingIndicator: editAccountController.isLoading.value,
                    onPressed: () {
                      editAccountController.onPressUpdate();
                    },
                    text: 'Update'.tr,
                    options: ButtonOptions(
                      width: double.infinity,
                      height: 50.h,
                      color: appTheme.primary,
                      textStyle: appTheme.text14.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                  ),
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      }),
    );
  }
}
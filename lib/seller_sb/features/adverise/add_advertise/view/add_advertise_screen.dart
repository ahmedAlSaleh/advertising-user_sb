import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
 import 'package:advertising_user/seller_sb/features/adverise/add_advertise/controller/add_advertise_controller.dart';
import 'package:advertising_user/seller_sb/main.dart';
import 'package:advertising_user/main.dart';

import '../../../../../uses_app_sb/core/shared/widgets/app_bar/general_app_bar.dart';
import '../../../../../uses_app_sb/core/shared/widgets/buttons/button_widget.dart';
import '../../../../../uses_app_sb/core/shared/widgets/snacl_bar/snackbar_manager.dart';
import '../../../../../uses_app_sb/core/shared/widgets/text_fields/app_text_field.dart';

class AddAdvertiseScreen extends StatelessWidget {
  final AddAdvertiseController controller = Get.put(AddAdvertiseController());

  final _formKey = GlobalKey<FormState>();

  AddAdvertiseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.primaryBackground,
      appBar: generalAppBar(
        context: context,
        title: Text("Add New Advertisement".tr,
            style: appTheme.text18.copyWith(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Field
                AppTextField(
                  controller: controller.titleController,
                  hint: "Enter advertisement title".tr,
                  validator: (value) =>
                      value!.isEmpty ? "Title is required".tr : null,
                ),
                SizedBox(height: 16.h),

                // Description Field
                AppTextField(
                  controller: controller.descriptionController,
                  hint: "Enter advertisement description".tr,
                  maxLines: 2,
                  validator: (value) =>
                      value!.isEmpty ? "Description is required".tr : null,
                ),
                SizedBox(height: 16.h),

                // Optional Notes Field
                AppTextField(
                  controller: controller.notesController,
                  hint: "Add optional notes".tr,
                  maxLines: 3,
                  validator: (value) => null,
                ),
                SizedBox(height: 16.h),

                //price Filed
                AppTextField(
                  controller: controller.priceController,
                  hint: "Enter advertisement price".tr,
                  validator: (value) =>
                      value!.isEmpty ? "price is required".tr : null,
                ),
                // SizedBox(height: 16.h),
                // SizedBox(height: 20.h),

                // Checkbox for Special Advertisement
                Obx(() {
                  return CheckboxListTile(
                    title: Row(
                      children: [
                        Text("Make this advertisement ".tr),
                        GestureDetector(
                          onTap: () {
                            // Show dialog explaining featured ad
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: appTheme.primaryBackground,
                                  title: Text(
                                    "Featured Ad".tr,
                                    style: appTheme.text16.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: appTheme.primaryText,
                                    ),
                                  ),
                                  content: Text(
                                    "This ad will appear in the first results and get more visibility"
                                        .tr,
                                    style: appTheme.text14.copyWith(
                                      color: appTheme.secondaryText,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "OK".tr,
                                        style: appTheme.text14.copyWith(
                                          color: appTheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            "special".tr,
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: appTheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    value: controller.isSpecial.value,
                    onChanged: (bool? value) {
                      controller.isSpecial.value = value ?? false;
                    },
                  );
                }),

                // Image Picker Section
                Text("Images".tr, style: appTheme.text16),
                SizedBox(height: 10.h),

                Obx(() {
                  return Wrap(
                    spacing: 10.w,
                    runSpacing: 10.h,
                    children: [
                      // Display Selected Images
                      ...controller.images.map((image) => Stack(
                            children: [
                              Image.file(
                                image,
                                width: 100.w,
                                height: 100.h,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: Icon(Icons.remove_circle,
                                      color: appTheme.error),
                                  onPressed: () =>
                                      controller.images.remove(image),
                                ),
                              )
                            ],
                          )),

                      if (controller.images.length < 5)
                        GestureDetector(
                          onTap: controller.pickImage,
                          child: Container(
                            width: 100.w,
                            height: 100.h,
                            decoration: BoxDecoration(
                              color: appTheme.secondaryText.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16.sp),
                            ),
                            child: Icon(Icons.add, size: 40.w),
                          ),
                        ),
                    ],
                  );
                }),

                SizedBox(height: 30.h),

                Obx(
                  () => ButtonWidget(
                    showLoadingIndicator: controller.isLoading.value,
                    onPressed: () {
                      // Validate the form before submitting
                      if (_formKey.currentState!.validate()) {
                        if (controller.images.isEmpty) {
                          SnackbarManager.showSnackbar(
                              "At least one image is required".tr);
                        } else {
                          controller.submitAdvertise();
                        }
                      }
                    },
                    text: 'Submit'.tr,
                    options: ButtonOptions(
                      width: 400.w,
                      height: 45.h,
                      color: appTheme.primary,
                      textStyle: appTheme.text14.copyWith(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

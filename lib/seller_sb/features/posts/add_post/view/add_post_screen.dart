import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
 import 'package:advertising_user/seller_sb/features/posts/add_post/controller/add_post_controller.dart';
import 'package:advertising_user/seller_sb/main.dart';
import 'package:advertising_user/main.dart';

import '../../../../../uses_app_sb/core/shared/widgets/app_bar/general_app_bar.dart';
import '../../../../../uses_app_sb/core/shared/widgets/buttons/button_widget.dart';
import '../../../../../uses_app_sb/core/shared/widgets/snacl_bar/snackbar_manager.dart';
import '../../../../../uses_app_sb/core/shared/widgets/text_fields/app_text_field.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final AddPostController controller = Get.put(AddPostController());

  // Global key for the form
  final _formKey = GlobalKey<FormState>();

  // Cache color values to avoid repeated withOpacity() calls
  late final Color _pickerBackgroundColor;

  // Cache BorderRadius values
  late final BorderRadius _pickerRadius;
  late final BorderRadius _buttonRadius;

  @override
  void initState() {
    super.initState();
    _pickerBackgroundColor = appTheme.secondaryText.withOpacity(0.1);
    _pickerRadius = BorderRadius.circular(16.sp);
    _buttonRadius = BorderRadius.circular(50.r);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.primaryBackground,
      appBar: generalAppBar(

        context: context,
        title: Text("Add New Post".tr,
            style: appTheme.text18.copyWith(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey, // Assign the key to the Form widget
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Field
                AppTextField(
                  controller: controller.titleController,
                  hint: "Enter post title".tr,
                  validator: (value) =>
                      value!.isEmpty ? "Title is required".tr : null,
                ),
                SizedBox(height: 16.h),

                // Image Picker Section
                Text("Images".tr, style: appTheme.text16),
                SizedBox(height: 10.h),

                // Image Thumbnails and Picker Button
                Obx(() {
                  return Wrap(
                    spacing: 10.w,
                    runSpacing: 10.h,
                    children: [
                      // Display Selected Images
                      ...controller.images.map((image) => _ImageThumbnail(
                            image: image,
                            onRemove: () => controller.removeImage(
                                controller.images.indexOf(image)),
                          )),

                      if (controller.images.length < 5)
                        _AddImageButton(
                          onTap: controller.pickImage,
                          backgroundColor: _pickerBackgroundColor,
                          borderRadius: _pickerRadius,
                        ),
                    ],
                  );
                }),

                SizedBox(height: 20.h),
                // Submit Button
                Obx(
                  () => ButtonWidget(
                    showLoadingIndicator: controller.isLoading.value,
                    onPressed: () {
                      // Validate the form before submitting
                      if (_formKey.currentState!.validate()) {
                        if (controller.images.isEmpty) {


                          SnackbarManager.showSnackbar(
                              "At least one image is required",
                              backgroundColor: appTheme.error
                          );



                        } else {
                          controller.submitPost();
                        }
                      }
                    },
                    text: 'Submit'.tr, // Replace with localization if needed.
                    options: ButtonOptions(
                      width: 400.w,
                      height: 45.h,
                      color: appTheme.primary,
                      textStyle: appTheme.text14.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      borderRadius: _buttonRadius,
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

// Extracted widget for image thumbnail
class _ImageThumbnail extends StatelessWidget {
  final dynamic image;
  final VoidCallback onRemove;

  const _ImageThumbnail({
    required this.image,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.sp),
          child: Image.file(
            File(image.path),
            width: 100.w,
            height: 100.h,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: Icon(Icons.remove_circle, color: appTheme.error),
            onPressed: onRemove,
          ),
        )
      ],
    );
  }
}

// Extracted widget for add image button
class _AddImageButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color backgroundColor;
  final BorderRadius borderRadius;

  const _AddImageButton({
    required this.onTap,
    required this.backgroundColor,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100.w,
        height: 100.h,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
        ),
        child: Icon(Icons.add, size: 40.w),
      ),
    );
  }
}

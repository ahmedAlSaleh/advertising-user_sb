import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:advertising_user/uses_app_sb/core/shared/functions/helper/divide.dart';
import 'package:advertising_user/uses_app_sb/core/shared/functions/validation/name_validation.dart';
import 'package:advertising_user/uses_app_sb/core/shared/functions/validation/phone_validation.dart';
import 'package:advertising_user/uses_app_sb/core/shared/functions/validation/email_validation.dart';
import 'package:advertising_user/uses_app_sb/features/setting/controller/edit_account_controller.dart';
import 'package:advertising_user/uses_app_sb/core/shared/widgets/buttons/button_widget.dart';
import 'package:advertising_user/uses_app_sb/core/shared/widgets/text_fields/app_text_field.dart';
import 'package:advertising_user/main.dart';
import 'package:advertising_user/uses_app_sb/core/shared/widgets/app_bar/general_app_bar.dart';

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
          return Center(
            child: CircularProgressIndicator(
              color: appTheme.primary,
            ),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Form(
            key: editAccountController.formstate,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Edit Your Profile Information".tr,
                  style: appTheme.text18.copyWith(
                      fontWeight: FontWeight.bold, color: appTheme.primaryText),
                ),

                SizedBox(height: 16.h),

                AppTextField(
                    hint: "Name".tr,
                    validator: (value) {
                      return nameValidation(value);
                    },
                    controller: editAccountController.nameController),
                AppTextField(
                    hint: "Phone".tr,
                    validator: (value) {
                      return phoneValidation(value);
                    },
                    controller: editAccountController.phoneController),
                AppTextField(
                    hint: "Email".tr,
                    validator: (value) {
                      return emailValidation(value);
                    },
                    controller: editAccountController.emailController),
                Obx(
                      () => ButtonWidget(
                    showLoadingIndicator: editAccountController.isLoading.value,
                    onPressed: () {
                      editAccountController.onPressUpdate();
                    },
                    text: 'Update'.tr,
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
              ].divide(SizedBox(height: 24.h)),
            ),
          ),
        );
      }),
    );
  }
}

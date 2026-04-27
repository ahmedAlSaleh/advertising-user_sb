import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:advertising_user/seller_sb/features/about_app/terms_service.dart';
import 'package:advertising_user/seller_sb/features/auth/sign_up/controller/sign_up_controller.dart';
import 'package:advertising_user/main.dart';

class TermsAndCondisionTexts extends StatelessWidget {
  TermsAndCondisionTexts({super.key});
  final SignUpController signupController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 5,
        ),
        Text(
          "By joining, I agree to".tr,
          style: appTheme.text12.copyWith(
            fontFamily: "NotoNaskhArabic",
            color: appTheme.secondaryText,
            fontSize: 10,
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return const TermsService();
                      });
                },
                child: Text(
                  "Advertize Terms of Use".tr,
                  style: appTheme.text10.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: appTheme.secondary,
                    fontFamily: "NotoNaskhArabic",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                child: Icon(
                  Icons.arrow_right_alt_outlined,
                  color: appTheme.secondaryText,
                  size: 24,
                ),
              ),
              const Spacer(),
              Obx(
                    () => Checkbox(
                  value: signupController.isAgreedOn.value,
                  side: BorderSide(
                      color: signupController.isAgreedError.value
                          ? appTheme.error
                          : appTheme.primary),
                  onChanged: (value) {
                    signupController.isAgreedOn.value = value!;
                  },
                  activeColor: appTheme.primary,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
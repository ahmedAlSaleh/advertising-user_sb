import 'package:advertising_user/main.dart';
 import 'package:advertising_user/seller_sb/features/setting/controller/setting_controller.dart';
import 'package:advertising_user/uses_app_sb/core/shared/functions/helper/divide.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../uses_app_sb/core/shared/widgets/buttons/button_widget.dart';

class DeleteAccountWidget extends StatelessWidget {
  DeleteAccountWidget({super.key});
  final SettingController logOutController = Get.put(SettingController());
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: appTheme.secondaryBackground,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              child: Divider(
                thickness: 3,
                color: appTheme.secondary,
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(0, -1),
              child: Text(
                "Delete Account".tr,
                textAlign: TextAlign.center,
                style: appTheme.text18.copyWith(
                  fontFamily: "NotoNaskhArabic",
                  color: appTheme.error,
                ),
              ),
            ),
            Divider(
              thickness: 1,
              indent: 12,
              endIndent: 12,
              color: appTheme.secondary,
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "Are you sure you want to Delete your account ?? you will lose your data"
                      .tr,
                  textAlign: TextAlign.center,
                  style: appTheme.text16,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ButtonWidget(
                        onPressed: () async {
                          Get.back();
                        },
                        text: ("Cancel".tr),
                        options: ButtonOptions(
                          width: 120,
                          height: 45,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              20, 0, 20, 0),
                          iconPadding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          color: appTheme.secondaryBackground,
                          textStyle: appTheme.text14.copyWith(
                            fontFamily: "NotoNaskhArabic",
                            color: appTheme.primary,
                            fontSize: 14,
                          ),
                          elevation: 0,
                          borderSide: BorderSide(
                            color: appTheme.primary,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        showLoadingIndicator: false,
                      ),
                      Obx(
                        () => ButtonWidget(
                          onPressed: () async {
                            logOutController.deleteAccount();
                          },
                          text: ("Yes, Delete".tr),
                          options: ButtonOptions(
                            width: logOutController.isLoadingDeleteAccount.value
                                ? 130
                                : null,
                            height: 45,
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 0, 20, 0),
                            iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 0),
                            color: appTheme.primary,
                            textStyle: appTheme.text16.copyWith(
                              fontFamily: "NotoNaskhArabic",
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            elevation: 0,
                            borderSide: BorderSide(
                              color: appTheme.primary,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          showLoadingIndicator:
                              logOutController.isLoadingDeleteAccount.value,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ].divide(const SizedBox(height: 8)),
        ),
      ),
    );
  }
}

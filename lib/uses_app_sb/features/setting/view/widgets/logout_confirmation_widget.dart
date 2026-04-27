import 'package:advertising_user/main.dart';
import 'package:advertising_user/uses_app_sb/core/shared/functions/helper/divide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/shared/widgets/buttons/button_widget.dart';
import '../../controller/setting_controller.dart';

class LogoutWidget extends StatelessWidget {
  LogoutWidget({super.key});
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
        padding: EdgeInsetsDirectional.fromSTEB(16.w, 4.h, 16.w, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 50.w,
              child: Divider(
                thickness: 3,
                color: appTheme.secondary,
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(0, -1),
              child: Text(
                "Logout".tr,
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
                  "Are you sure you want to Logout?".tr,
                  textAlign: TextAlign.center,
                  style: appTheme.text18,
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20.h, 0, 0),
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
                          width: 120.w,
                          height: 45.h,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              20.w, 0, 20.w, 0),
                          iconPadding:
                              EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          color: appTheme.secondaryBackground,
                          textStyle: appTheme.text14.copyWith(
                            fontFamily: "NotoNaskhArabic",
                            color: appTheme.primary,
                            fontSize: 14.sp,
                          ),
                          elevation: 0,
                          borderSide: BorderSide(
                            color: appTheme.primary,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        showLoadingIndicator: false,
                      ),
                      Obx(
                        () => ButtonWidget(
                          onPressed: () async {
                            logOutController.logout();
                          },
                          text: ("Yes, Logout".tr),
                          options: ButtonOptions(
                            width:
                                logOutController.isLoading.value ? 130.w : null,
                            height: 45.h,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                20.w, 0, 20.w, 0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 0),
                            color: appTheme.primary,
                            textStyle: appTheme.text16.copyWith(
                              fontFamily: "NotoNaskhArabic",
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                            elevation: 0,
                            borderSide: BorderSide(
                              color: appTheme.primary,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          showLoadingIndicator:
                              logOutController.isLoading.value,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ].divide(SizedBox(height: 8.h)),
        ),
      ),
    );
  }
}

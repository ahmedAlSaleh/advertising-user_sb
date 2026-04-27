import 'package:advertising_user/main.dart';
 import 'package:flutter/material.dart';

generalAppBar({

  required BuildContext context,
  Widget? title,
  Widget? leading,
  List<Widget>? actions
 }) {
  return AppBar(
    backgroundColor: appTheme.primaryBackground,
    title: title,
    centerTitle: true,
    leading: leading,
    surfaceTintColor: appTheme.primaryBackground,
    elevation: 0,
  );
}

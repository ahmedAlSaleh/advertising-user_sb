import 'package:flutter/material.dart';

Future<void> showCustomBottomSheet(
    {required BuildContext context,
    required Widget widget,
    required double height}) async {
  return await showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    enableDrag: false,
    context: context,
    builder: (context) {
      return Padding(
        padding: MediaQuery.viewInsetsOf(context),
        child: SizedBox(
          height: (height),
          child: widget,
        ),
      );
    },
  );
}

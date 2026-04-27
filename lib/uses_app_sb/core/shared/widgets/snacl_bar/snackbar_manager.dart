import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarManager {
  static final RxBool _isSnackbarActive = false.obs;

  static showSnackbar(String message,
      {SnackPosition position = SnackPosition.BOTTOM,
      Widget? icon,
      Color backgroundColor = Colors.blue,
      Color textColor = Colors.white}) {
    if (_isSnackbarActive.value) {
      // A snackbar is already being shown
      return;
    }
    _isSnackbarActive.value = true;

    Get.rawSnackbar(
      message: message,
      icon: icon,
      snackPosition: position,
      backgroundColor: backgroundColor,
      padding:
          const EdgeInsets.fromLTRB(24, 8, 24, 8), // Adjust padding as needed

      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      duration: const Duration(seconds: 2), // Adjust duration as needed
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
    ); // Use a timer to reset _isSnackbarActive after the duration of the snackbar
    Timer(const Duration(seconds: 3), () {
      _isSnackbarActive.value = false;
    });
  }
}

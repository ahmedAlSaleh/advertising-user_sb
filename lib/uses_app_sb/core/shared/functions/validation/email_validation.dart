import 'package:get/get.dart';

String? emailValidation(String? value) {
  // Check if the value is null or empty
  if (value == null || value.isEmpty) {
    return "please_enter_email".tr; // Handle null or empty input
  }

  // Regular expression to validate email addresses
  String emailPattern = r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';

  if (!RegExp(emailPattern).hasMatch(value)) {
    return "please_enter_valid_email".tr;
  }

  // No error found
  return null;
}

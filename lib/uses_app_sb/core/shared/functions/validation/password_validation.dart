import 'package:get/get.dart';

String? passwordValidation(String? value) {
  if (value == null || value.isEmpty) {
    return "password_is_required".tr; // Password is required
  }
  if (value.length < 8) {
    return "password_must_be_at_least_8_characters_long"
        .tr; // Check for minimum length
  }
  // Check for at least one letter
  if (!RegExp(r'(?=.*[A-Za-z])').hasMatch(value)) {
    return "password_must_contain_at_least_one_letter"
        .tr; // Check for at least one letter
  }
  // Check for at least one number
  if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
    return "password_must_contain_at_least_one_number"
        .tr; // Check for at least one number
  }
  return null; // If all conditions are met, return null (valid)
}

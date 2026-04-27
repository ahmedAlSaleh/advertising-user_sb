import 'package:get/get.dart';

String? nameValidation(String? value) {
  if (value == null || value.isEmpty) {
    return "please_enter_a_name".tr; // Handle null or empty input
  }
  if (value.length <= 2) {
    return "please_type_longer_name".tr;
  } else if (value.length > 20) {
    return "please_type_shorter_name".tr;
  }

  return null;
}

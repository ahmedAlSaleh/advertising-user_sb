import 'package:advertising_user/uses_app_sb/core/server/handling_status_code.dart';
import 'package:advertising_user/uses_app_sb/core/server/status_request.dart';

/// ⚠️ DEPRECATED: استخدم ApiException بدلاً من هذا الـ class
/// هذا الـ class محفوظ للتوافق مع الكود القديم فقط
@Deprecated('Use ApiException instead')
class ErrorResponse {
  StatusRequest?
      status; // Status indicating the success or failure of the API call
  String? message; // General message describing the error
  ValidationError?
      validationErrors; // Object holding detailed validation errors

  // Constructor for creating an ErrorResponse instance
  ErrorResponse({this.status, this.message, this.validationErrors});

  // Factory constructor to create an ErrorResponse instance from JSON map and status code
  factory ErrorResponse.fromJson(int statusCode, Map<String, dynamic> json) {
    return ErrorResponse(
      status: getStatusFromCode(statusCode),
      message: json['message'] ?? "",
      validationErrors: json['errors'] != null
          ? ValidationError.fromJson(json['errors'])
          : null,
    );
  }

  // Extracts and returns a list of error messages from the ErrorResponse instance
  List<String> getErrorMessages() {
    List<String> errors = [];
    if (message != null) {
      // Add the general error message, if available
      errors.add(message!);
    }
    if (validationErrors != null) {
      // Add detailed validation error messages, if available
      errors.addAll(validationErrors!.getAllMessages());
    }
    return errors;
  }

  // Overrides toString to provide a readable string representation of the error
  @override
  String toString() {
    List<String> errors = getErrorMessages();
    // If there are error messages, join them with line breaks; otherwise, return a default message
    return errors.isNotEmpty ? errors.join('\n') : "Unknown Error";
  }
}

/// ⚠️ DEPRECATED: استخدم ApiException بدلاً من هذا الـ class
@Deprecated('Use ApiException instead')
class ValidationError {
  Map<String, List<String>> errors;

  ValidationError(this.errors);

  // Factory constructor to create ValidationError instance from JSON map
  factory ValidationError.fromJson(Map<String, dynamic> json) {
    Map<String, List<String>> castedErrorData = {};
    json.forEach((key, value) {
      if (value is List) {
        // Ensure that the value is a list and cast it to List<String>
        castedErrorData[key] = List<String>.from(value);
      }
    });
    return ValidationError(castedErrorData);
  }

  // Returns all error messages
  List<String> getAllMessages() {
    List<String> messages = [];
    errors.forEach((field, errorList) {
      messages.addAll(errorList);
    });
    return messages;
  }

  // Returns error messages for a specific field
  List<String> getFieldMessages(String field) {
    return errors[field] ?? [];
  }
}

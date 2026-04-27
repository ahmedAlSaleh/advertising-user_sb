import 'package:advertising_user/uses_app_sb/core/server/status_request.dart';
import 'package:get/get_utils/get_utils.dart';

StatusRequest getStatusFromCode(int code) {
  switch (code) {
    case 200:
      return StatusRequest.success; // Typo correction: 'sucess' -> 'success'
    case 201:
      return StatusRequest.created;
    case 204:
      return StatusRequest.noContent;
    case 202:
      return StatusRequest.accepted;
    case 203:
      return StatusRequest.nonAuthoritative;
    case 205:
      return StatusRequest.resetContent;
    case 400:
      return StatusRequest.badRequest;
    case 401:
      return StatusRequest
          .authError; // Typo correction: 'authErorr' -> 'authError'
    case 402:
      return StatusRequest.paymentRequired;
    case 403:
      return StatusRequest.forbidden;
    case 404:
      return StatusRequest.urlError;
    case 422:
      return StatusRequest.validationError;
    case 500:
      return StatusRequest.serverError;
    default:
      return StatusRequest
          .unknownError; // It's better to have a fallback for unknown statuses
  }
}

String getMessageFromStatus(StatusRequest status) {
  switch (status) {
    case StatusRequest.success:
      return 'Request successful.'.tr;
    case StatusRequest.created:
      return 'Resource created successfully.'.tr;
    case StatusRequest.noContent:
      return 'No content to display.'.tr;
    case StatusRequest.accepted:
      return 'Request accepted and processing.'.tr;
    case StatusRequest.nonAuthoritative:
      return 'Non-authoritative information.'.tr;
    case StatusRequest.resetContent:
      return 'Please reset content.'.tr;
    case StatusRequest.badRequest:
      return 'Bad request. Please check your input.'.tr;
    case StatusRequest.authError:
      return 'Authentication error. Please log in.'.tr;
    case StatusRequest.paymentRequired:
      return 'Payment required.'.tr;
    case StatusRequest.forbidden:
      return 'Access denied. You do not have the necessary permissions.'.tr;
    case StatusRequest.urlError:
      return 'Resource not found.'.tr;
    case StatusRequest.validationError:
      return 'Validation error. Please check your input.'.tr;
    case StatusRequest.serverError:
      return 'Server error. Please try again later.'.tr;
    case StatusRequest.unknownError:
      return 'An unknown error occurred.'.tr;
    default:
      return 'Unexpected status. Please contact support.'.tr;
  }
}

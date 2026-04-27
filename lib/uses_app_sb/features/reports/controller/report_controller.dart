import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../core/server/helper_api.dart';
import '../../../core/server/server_config.dart';
import '../../../core/shared/models/report_model.dart';
import '../../../core/shared/models/user.dart';
import '../../../core/shared/widgets/snacl_bar/snackbar_manager.dart';

class ReportController extends GetxController {
  // Loading states
  RxBool isLoadingReasons = false.obs;
  RxBool isSubmitting = false.obs;
  RxBool isLoadingMyReports = false.obs;

  // Data
  RxList<ReportReasonModel> reasons = <ReportReasonModel>[].obs;
  RxList<ReportModel> myReports = <ReportModel>[].obs;
  Rx<String?> selectedReason = Rx<String?>(null);
  RxString description = ''.obs;

  /// Get Report Reasons
  /// GET /api/reports/reasons (no auth)
  Future<void> getReportReasons() async {
    try {
      isLoadingReasons.value = true;

      final response = await ApiHelper.makeRequest<List<dynamic>>(
        targetRout: ServerConstApis.getReportReasons,
        method: "GET",
        // No token - public endpoint
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error loading report reasons: ${apiException.message}");
          }
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            reasons.value = List<ReportReasonModel>.from(
              apiResponse.data!.map((x) => ReportReasonModel.fromJson(x)),
            );

            if (kDebugMode) {
              print("Report reasons loaded: ${reasons.length}");
            }
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Exception loading report reasons: $e");
      }
    } finally {
      isLoadingReasons.value = false;
    }
  }

  /// Submit Report
  /// POST /api/reports
  Future<bool> submitReport({
    required String reportableType,
    required int reportableId,
    required String reason,
    String? description,
  }) async {
    try {
      isSubmitting.value = true;

      final reportRequest = ReportRequest(
        reportableType: reportableType,
        reportableId: reportableId,
        reason: reason,
        description: description,
      );

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: ServerConstApis.submitReport,
        method: "POST",
        token: token,
        data: reportRequest.toJson(),
      );

      bool success = false;

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error submitting report: ${apiException.message}");
          }
          SnackbarManager.showSnackbar(
            apiException.message,
            backgroundColor: appTheme.error,
          );
          success = false;
        },
        (apiResponse) {
          if (apiResponse.isSuccess) {
            SnackbarManager.showSnackbar(
              'تم إرسال البلاغ بنجاح',
              backgroundColor: appTheme.success,
            );

            if (kDebugMode) {
              print("Report submitted successfully");
            }

            success = true;
          }
        },
      );

      return success;
    } catch (e) {
      if (kDebugMode) {
        print("Exception submitting report: $e");
      }
      SnackbarManager.showSnackbar(
        'حدث خطأ أثناء إرسال البلاغ',
        backgroundColor: appTheme.error,
      );
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  /// Get My Reports
  /// GET /api/user/reports
  Future<void> getMyReports() async {
    try {
      isLoadingMyReports.value = true;

      final response = await ApiHelper.makeRequest<List<dynamic>>(
        targetRout: ServerConstApis.getMyReports,
        method: "GET",
        token: token,
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error loading my reports: ${apiException.message}");
          }
          SnackbarManager.showSnackbar(
            apiException.message,
            backgroundColor: appTheme.error,
          );
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            myReports.value = List<ReportModel>.from(
              apiResponse.data!.map((x) => ReportModel.fromJson(x)),
            );

            if (kDebugMode) {
              print("My reports loaded: ${myReports.length}");
            }
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Exception loading my reports: $e");
      }
      SnackbarManager.showSnackbar(
        'حدث خطأ أثناء تحميل البلاغات',
        backgroundColor: appTheme.error,
      );
    } finally {
      isLoadingMyReports.value = false;
    }
  }

  /// Reset form
  void resetForm() {
    selectedReason.value = null;
    description.value = '';
  }

  /// Helper: Get reason label by value
  String? getReasonLabel(String value) {
    try {
      final reason = reasons.firstWhere((r) => r.value == value);
      return reason.label;
    } catch (e) {
      return null;
    }
  }

  /// Helper: Check if has reasons
  bool get hasReasons => reasons.isNotEmpty;

  /// Helper: Check if has my reports
  bool get hasMyReports => myReports.isNotEmpty;
}

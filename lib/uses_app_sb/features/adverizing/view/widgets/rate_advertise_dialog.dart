import 'package:advertising_user/main.dart';
import 'package:advertising_user/uses_app_sb/core/server/helper_api.dart';
import 'package:advertising_user/uses_app_sb/core/server/server_config.dart';
import 'package:advertising_user/uses_app_sb/core/shared/models/user.dart';
import 'package:advertising_user/uses_app_sb/core/shared/widgets/dialogs/auth_required_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RateAdvertiseDialog extends StatefulWidget {
  final int advertiseId;

  const RateAdvertiseDialog({super.key, required this.advertiseId});

  @override
  State<RateAdvertiseDialog> createState() => _RateAdvertiseDialogState();
}

class _RateAdvertiseDialogState extends State<RateAdvertiseDialog> {
  int _rating = 0;
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitRating() async {
    if (_rating == 0) {
      Get.snackbar(
        'Error'.tr,
        'Please select a rating'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: appTheme.error,
        colorText: Colors.white,
      );
      return;
    }

    if (_commentController.text.trim().isEmpty) {
      Get.snackbar(
        'Error'.tr,
        'Please enter a comment'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: appTheme.error,
        colorText: Colors.white,
      );
      return;
    }

    // Check if user is authenticated
    if (token.isEmpty) {
      Get.back();
      showAuthRequiredDialog();
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      Map<String, dynamic> data = {
        "rate": _rating,
        "comment": _commentController.text.trim(),
        "adv_id": widget.advertiseId,
      };

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: ServerConstApis.submitRating,
        method: "POST",
        token: token,
        data: data,
      );

      setState(() {
        _isSubmitting = false;
      });

      response.fold(
        (apiException) {
          // Handle error response
          if (kDebugMode) {
            print("Error rating advertise: ${apiException.message}");
          }
          Get.snackbar(
            'Error'.tr,
            apiException.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: appTheme.error,
            colorText: Colors.white,
          );
        },
        (apiResponse) {
          // Handle success response
          if (apiResponse.isSuccess) {
            Get.back(); // Close the dialog
            Get.snackbar(
              'Success'.tr,
              apiResponse.message ?? 'Rating submitted successfully'.tr,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: appTheme.primary,
              colorText: Colors.white,
            );
          } else {
            Get.snackbar(
              'Error'.tr,
              apiResponse.message ?? "Failed to submit rating",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: appTheme.error,
              colorText: Colors.white,
            );
          }
        },
      );
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      if (kDebugMode) {
        print("Exception rating advertise: $e");
      }
      Get.snackbar(
        'Error'.tr,
        'An error occurred'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: appTheme.error,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: appTheme.primaryBackground,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            Icon(
              Icons.star_rate,
              size: 48.sp,
              color: appTheme.primary,
            ),
            SizedBox(height: 12.h),
            Text(
              'Rate Advertisement'.tr,
              style: appTheme.text18.copyWith(
                fontWeight: FontWeight.bold,
                color: appTheme.primaryText,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 6.h),
            Text(
              'Please rate this advertisement'.tr,
              style: appTheme.text14.copyWith(
                color: appTheme.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            // Star Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                  child: Icon(
                    Icons.star,
                    size: 40.sp,
                    color: index < _rating
                        ? appTheme.primary
                        : appTheme.secondaryText.withOpacity(0.3),
                  ),
                );
              }),
            ),
            SizedBox(height: 16.h),
            // Comment TextField
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Enter your comment...'.tr,
                hintStyle: appTheme.text14.copyWith(
                  color: appTheme.secondaryText,
                ),
                filled: true,
                fillColor: appTheme.secondaryBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.all(12.w),
              ),
              style: appTheme.text14,
            ),
            SizedBox(height: 16.h),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isSubmitting
                        ? null
                        : () {
                            Get.back();
                          },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: appTheme.primaryText,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      side: BorderSide(color: appTheme.secondaryText, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Cancel'.tr,
                      style: appTheme.text14.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitRating,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appTheme.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: _isSubmitting
                        ? SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Submit'.tr,
                            style: appTheme.text14.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
          ),
        ),
      ),
    );
  }
}

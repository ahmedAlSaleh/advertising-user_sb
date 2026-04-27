import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../main.dart';
import '../../controller/rating_controller.dart';

class RatingDialog extends StatefulWidget {
  final int storeId;
  final String storeName;

  const RatingDialog({
    super.key,
    required this.storeId,
    required this.storeName,
  });

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int selectedRating = 5;
  final TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final RatingController controller = Get.find<RatingController>();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber[700], size: 28),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'تقييم المتجر',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: appTheme.primary,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Store name
            Text(
              widget.storeName,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Star rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starValue = index + 1;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedRating = starValue;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      selectedRating >= starValue ? Icons.star : Icons.star_border,
                      color: Colors.amber[700],
                      size: 40,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),

            // Rating text
            Text(
              _getRatingText(selectedRating),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _getRatingColor(selectedRating),
              ),
            ),
            const SizedBox(height: 20),

            // Comment field
            TextField(
              controller: commentController,
              maxLines: 4,
              maxLength: 200,
              decoration: InputDecoration(
                hintText: 'اكتب تعليقك هنا (اختياري)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: appTheme.primary, width: 2),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 20),

            // Submit button
            Obx(() {
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isSubmittingRating.value
                      ? null
                      : () async {
                          await controller.submitRating(
                            storeId: widget.storeId,
                            rating: selectedRating,
                            comment: commentController.text.trim().isEmpty
                                ? null
                                : commentController.text.trim(),
                          );

                          if (!controller.isSubmittingRating.value) {
                            Get.back();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: controller.isSubmittingRating.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'إرسال التقييم',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 5:
        return 'ممتاز';
      case 4:
        return 'جيد جداً';
      case 3:
        return 'جيد';
      case 2:
        return 'مقبول';
      case 1:
        return 'ضعيف';
      default:
        return '';
    }
  }

  Color _getRatingColor(int rating) {
    switch (rating) {
      case 5:
        return Colors.green;
      case 4:
        return Colors.lightGreen;
      case 3:
        return Colors.orange;
      case 2:
        return Colors.deepOrange;
      case 1:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

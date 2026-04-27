import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../main.dart';
import '../../controller/rating_controller.dart';

class StoreRatingsWidget extends StatelessWidget {
  final int storeId;

  const StoreRatingsWidget({
    super.key,
    required this.storeId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RatingController(), tag: 'rating_$storeId');

    // Load ratings on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getStoreRatings(storeId);
    });

    return Obx(() {
      if (controller.isLoadingRatings.value && controller.storeRatings.value == null) {
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      final ratings = controller.storeRatings.value;
      if (ratings == null || ratings.totalRatings == 0) {
        return _buildEmptyState();
      }

      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              'التقييمات والآراء',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Rating summary
            _buildRatingSummary(ratings, controller),
            const SizedBox(height: 20),

            // Rating distribution
            _buildRatingDistribution(controller),
            const SizedBox(height: 20),

            // Reviews list
            _buildReviewsList(ratings),
          ],
        ),
      );
    });
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.star_border,
              size: 60,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              'لا توجد تقييمات بعد',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'كن أول من يقيّم هذا المتجر',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSummary(storeRatings, RatingController controller) {
    return Row(
      children: [
        // Average rating
        Column(
          children: [
            Text(
              storeRatings.averageRating.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < storeRatings.averageRating.floor()
                      ? Icons.star
                      : Icons.star_border,
                  color: Colors.amber[700],
                  size: 20,
                );
              }),
            ),
            const SizedBox(height: 4),
            Text(
              '${storeRatings.totalRatings} تقييم',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(width: 20),

        // Rating bars
        Expanded(
          child: Column(
            children: List.generate(5, (index) {
              final starValue = 5 - index;
              final percentages = controller.getRatingPercentages();
              final percentage = percentages[starValue] ?? 0.0;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Text(
                      '$starValue',
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.star, color: Colors.amber[700], size: 12),
                    const SizedBox(width: 8),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: percentage / 100,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.amber[700]!,
                        ),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 35,
                      child: Text(
                        '${percentage.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingDistribution(RatingController controller) {
    final distribution = controller.getRatingDistribution();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(5, (index) {
          final starValue = 5 - index;
          final count = distribution[starValue] ?? 0;

          return Column(
            children: [
              Icon(
                Icons.star,
                color: _getStarColor(starValue),
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                '$count',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildReviewsList(storeRatings) {
    if (storeRatings.ratings.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'آراء العملاء (${storeRatings.ratings.length})',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: storeRatings.ratings.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final rating = storeRatings.ratings[index];
            return _buildReviewCard(rating);
          },
        ),
      ],
    );
  }

  Widget _buildReviewCard(rating) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info and rating
          Row(
            children: [
              // User avatar
              CircleAvatar(
                radius: 18,
                backgroundColor: appTheme.primary.withValues(alpha: 0.1),
                child: Text(
                  rating.user.name.isNotEmpty ? rating.user.name[0].toUpperCase() : '؟',
                  style: TextStyle(
                    color: appTheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // User name and date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rating.user.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _formatDate(rating.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // Star rating
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < rating.rate ? Icons.star : Icons.star_border,
                    color: Colors.amber[700],
                    size: 16,
                  );
                }),
              ),
            ],
          ),

          // Comment
          if (rating.comment != null && rating.comment!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              rating.comment!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStarColor(int starValue) {
    switch (starValue) {
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'اليوم';
    } else if (difference.inDays == 1) {
      return 'أمس';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} أيام';
    } else if (difference.inDays < 30) {
      return 'منذ ${(difference.inDays / 7).floor()} أسابيع';
    } else if (difference.inDays < 365) {
      return 'منذ ${(difference.inDays / 30).floor()} شهر';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }
}

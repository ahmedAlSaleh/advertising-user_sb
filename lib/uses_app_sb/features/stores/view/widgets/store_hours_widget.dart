import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../main.dart';
import '../../../../../seller_sb/features/store_hours/controller/store_hours_controller.dart';

class StoreHoursWidget extends StatelessWidget {
  final int storeId;

  const StoreHoursWidget({
    super.key,
    required this.storeId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StoreHoursController(), tag: 'store_$storeId');

    return Obx(() {
      if (controller.isLoadingHours.value && controller.storeHours.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (controller.storeHours.isEmpty) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'أوقات العمل',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildOpenNowBadge(controller),
              ],
            ),
            const SizedBox(height: 12),

            // Hours list
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: controller.storeHours.asMap().entries.map((entry) {
                  final index = entry.key;
                  final hour = entry.value;
                  final isLast = index == controller.storeHours.length - 1;

                  return Column(
                    children: [
                      _buildHourRow(hour),
                      if (!isLast) Divider(height: 1, color: Colors.grey[200]),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildOpenNowBadge(StoreHoursController controller) {
    final isOpen = controller.isStoreOpenNow();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isOpen
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isOpen ? Colors.green : Colors.red,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOpen ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: isOpen ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 4),
          Text(
            isOpen ? 'مفتوح الآن' : 'مغلق الآن',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isOpen ? Colors.green[700] : Colors.red[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourRow(hour) {
    final now = DateTime.now();
    final currentDay = _getDayName(now.weekday);
    final isToday = hour.day.toLowerCase() == currentDay.toLowerCase();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: isToday ? appTheme.primary.withValues(alpha: 0.05) : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (isToday)
                Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: appTheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              Text(
                hour.dayNameAr,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  color: isToday ? appTheme.primary : Colors.grey[800],
                ),
              ),
            ],
          ),
          Row(
            children: [
              if (hour.isClosed)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'مغلق',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else
                Text(
                  hour.formattedHours,
                  style: TextStyle(
                    fontSize: 14,
                    color: isToday ? appTheme.primary : Colors.grey[600],
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 7:
        return 'Sunday';
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      default:
        return '';
    }
  }
}

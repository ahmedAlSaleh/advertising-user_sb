import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../controller/store_hours_controller.dart';

class StoreHoursScreen extends StatelessWidget {
  const StoreHoursScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final StoreHoursController controller = Get.put(StoreHoursController());

    return Scaffold(
      appBar: AppBar(
        title: Text('أوقات العمل'.tr),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.getStoreHours(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoadingHours.value && controller.storeHours.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Info card
            _buildInfoCard(),

            // Hours list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.storeHours.length,
                itemBuilder: (context, index) {
                  return _buildDayCard(context, controller, index);
                },
              ),
            ),

            // Save button
            _buildSaveButton(controller),
          ],
        );
      }),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue[700], size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'حدد أوقات عمل متجرك ليتمكن العملاء من معرفة متى تكون متاحاً',
              style: TextStyle(
                fontSize: 13,
                color: Colors.blue[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCard(
    BuildContext context,
    StoreHoursController controller,
    int index,
  ) {
    final hour = controller.storeHours[index];

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Day name and closed toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  hour.dayNameAr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      hour.isClosed ? 'مغلق' : 'مفتوح',
                      style: TextStyle(
                        fontSize: 14,
                        color: hour.isClosed ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Switch(
                      value: !hour.isClosed,
                      onChanged: (value) => controller.toggleDayClosed(index),
                      activeColor: appTheme.primary,
                    ),
                  ],
                ),
              ],
            ),

            if (!hour.isClosed) ...[
              const SizedBox(height: 16),
              // Time pickers
              Row(
                children: [
                  Expanded(
                    child: _buildTimePicker(
                      context,
                      controller,
                      index,
                      'من',
                      hour.opensAt ?? '09:00',
                      true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTimePicker(
                      context,
                      controller,
                      index,
                      'إلى',
                      hour.closesAt ?? '21:00',
                      false,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker(
    BuildContext context,
    StoreHoursController controller,
    int index,
    String label,
    String initialTime,
    bool isOpening,
  ) {
    return InkWell(
      onTap: () => _showTimePicker(
        context,
        controller,
        index,
        initialTime,
        isOpening,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            Row(
              children: [
                Text(
                  initialTime,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.access_time, color: appTheme.primary, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showTimePicker(
    BuildContext context,
    StoreHoursController controller,
    int index,
    String initialTime,
    bool isOpening,
  ) async {
    final timeParts = initialTime.split(':');
    final initialTimeOfDay = TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTimeOfDay,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: appTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final hour = controller.storeHours[index];
      final formattedTime =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';

      if (isOpening) {
        controller.updateDayHours(
          index,
          formattedTime,
          hour.closesAt ?? '21:00',
        );
      } else {
        controller.updateDayHours(
          index,
          hour.opensAt ?? '09:00',
          formattedTime,
        );
      }
    }
  }

  Widget _buildSaveButton(StoreHoursController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Quick actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showApplyToAllDialog(controller),
                  icon: const Icon(Icons.copy_all, size: 18),
                  label: const Text('تطبيق على الكل'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: appTheme.primary,
                    side: BorderSide(color: appTheme.primary),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => controller.resetToDefault(),
                  icon: const Icon(Icons.restore, size: 18),
                  label: const Text('الافتراضي'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[700]!,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Save button
          SizedBox(
            width: double.infinity,
            child: Obx(() => ElevatedButton.icon(
                  onPressed: controller.isUpdating.value
                      ? null
                      : () => controller.updateStoreHours(),
                  icon: controller.isUpdating.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(
                    controller.isUpdating.value ? 'جاري الحفظ...' : 'حفظ التغييرات',
                    style: const TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  void _showApplyToAllDialog(StoreHoursController controller) {
    // Get first open day hours as default
    final firstOpenDay = controller.storeHours.firstWhere(
      (h) => !h.isClosed,
      orElse: () => controller.storeHours[0],
    );

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.copy_all, color: appTheme.primary),
            const SizedBox(width: 12),
            const Text('تطبيق على جميع الأيام'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'سيتم تطبيق الأوقات التالية على جميع الأيام المفتوحة:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'من ${firstOpenDay.opensAt}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text('→'),
                  const SizedBox(width: 16),
                  Text(
                    'إلى ${firstOpenDay.closesAt}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.applyToAllDays(
                firstOpenDay.opensAt!,
                firstOpenDay.closesAt!,
              );
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: appTheme.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('تطبيق'),
          ),
        ],
      ),
    );
  }
}

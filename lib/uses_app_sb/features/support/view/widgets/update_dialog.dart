import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../main.dart';
import '../../controller/support_controller.dart';

class UpdateDialog extends StatelessWidget {
  final bool isForceUpdate;

  const UpdateDialog({
    super.key,
    required this.isForceUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final SupportController controller = Get.find<SupportController>();
    final version = controller.appVersion.value;

    return WillPopScope(
      onWillPop: () async => !isForceUpdate,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              isForceUpdate ? Icons.warning : Icons.info_outline,
              color: isForceUpdate ? appTheme.error : appTheme.primary,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isForceUpdate ? 'تحديث مطلوب' : 'تحديث متوفر',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isForceUpdate) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.red[700]),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'يجب تحديث التطبيق للمتابعة',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            const Text(
              'يتوفر إصدار جديد من التطبيق',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.update, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                Text(
                  'الإصدار الحالي: ${controller.currentVersion}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.new_releases, color: appTheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'الإصدار الجديد: ${version?.version ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: appTheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'الإصدار الجديد يحتوي على تحسينات ومزايا جديدة',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          if (!isForceUpdate)
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('لاحقاً'),
            ),
          ElevatedButton(
            onPressed: () {
              controller.openUpdateUrl();
              if (!isForceUpdate) {
                Get.back();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isForceUpdate ? appTheme.error : appTheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'تحديث الآن',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Show update dialog
void showUpdateDialog({required bool isForceUpdate}) {
  Get.dialog(
    UpdateDialog(isForceUpdate: isForceUpdate),
    barrierDismissible: !isForceUpdate,
  );
}

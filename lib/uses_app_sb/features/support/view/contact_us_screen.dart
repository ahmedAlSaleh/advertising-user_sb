import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../core/shared/widgets/snacl_bar/snackbar_manager.dart';
import '../controller/support_controller.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SupportController controller = Get.put(SupportController());

    // Load support info
    if (!controller.hasSupportInfo) {
      controller.getSupportInfo();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('تواصل معنا'),
        backgroundColor: appTheme.primary,
      ),
      body: Obx(() {
        if (controller.isLoadingSupportInfo.value &&
            !controller.hasSupportInfo) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!controller.hasSupportInfo) {
          return _buildErrorState(controller);
        }

        final support = controller.supportInfo.value!;

        return RefreshIndicator(
          onRefresh: controller.getSupportInfo,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                _buildHeaderCard(),
                const SizedBox(height: 24),

                // Contact Methods
                const Text(
                  'طرق التواصل',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Phone
                _buildContactCard(
                  icon: Icons.phone,
                  title: 'الهاتف',
                  subtitle: support.phone,
                  color: Colors.blue,
                  onTap: () => controller.makePhoneCall(),
                  onCopy: () => _copyToClipboard(support.phone, 'رقم الهاتف'),
                ),
                const SizedBox(height: 12),

                // Email
                _buildContactCard(
                  icon: Icons.email,
                  title: 'البريد الإلكتروني',
                  subtitle: support.email,
                  color: Colors.red,
                  onTap: () => controller.sendEmail(),
                  onCopy: () => _copyToClipboard(support.email, 'البريد الإلكتروني'),
                ),
                const SizedBox(height: 12),

                // WhatsApp
                _buildContactCard(
                  icon: Icons.message,
                  title: 'واتساب',
                  subtitle: support.whatsapp,
                  color: Colors.green,
                  onTap: () => controller.launchWhatsApp(),
                  onCopy: () => _copyToClipboard(support.whatsapp, 'رقم واتساب'),
                ),
                const SizedBox(height: 12),

                // Telegram
                _buildContactCard(
                  icon: Icons.send,
                  title: 'تيليجرام',
                  subtitle: support.telegram,
                  color: Colors.blueAccent,
                  onTap: () => controller.launchTelegram(),
                  onCopy: () => _copyToClipboard(support.telegram, 'حساب تيليجرام'),
                ),

                const SizedBox(height: 24),

                // Working Hours
                _buildWorkingHoursCard(support.workingHours),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [appTheme.primary, appTheme.primary.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.support_agent,
            size: 60,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          const Text(
            'نحن هنا لمساعدتك',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'تواصل معنا في أي وقت، سنكون سعداء بخدمتك',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    required VoidCallback onCopy,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.copy, color: Colors.grey[600]),
                onPressed: onCopy,
                tooltip: 'نسخ',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkingHoursCard(String workingHours) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.access_time,
            color: Colors.orange[700],
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أوقات العمل',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[900],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  workingHours,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.orange[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(SupportController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'تعذر تحميل معلومات الدعم',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => controller.getSupportInfo(),
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة المحاولة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: appTheme.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    SnackbarManager.showSnackbar('تم نسخ $label');
  }
}

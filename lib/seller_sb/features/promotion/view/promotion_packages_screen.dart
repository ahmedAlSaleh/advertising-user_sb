import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../core/shared/models/promotion_model.dart';
import '../controller/promotion_controller.dart';

class PromotionPackagesScreen extends StatelessWidget {
  final int advertisementId;
  final String advertisementTitle;

  const PromotionPackagesScreen({
    super.key,
    required this.advertisementId,
    required this.advertisementTitle,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PromotionController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('اختر باقة الترويج'),
        backgroundColor: appTheme.primary,
      ),
      body: Obx(() {
        if (controller.isLoadingPackages.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!controller.hasPackages) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'لا توجد باقات متاحة حالياً',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.getPackages,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ad Info Card
                _buildAdInfoCard(),
                const SizedBox(height: 24),

                // Packages Title
                const Text(
                  'الباقات المتاحة',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Packages List
                ...controller.packages.map((package) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildPackageCard(package, controller),
                  );
                }).toList(),

                const SizedBox(height: 16),

                // Info Card
                _buildInfoCard(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildAdInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appTheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: appTheme.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.campaign,
            color: appTheme.primary,
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'الإعلان المراد ترويجه',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  advertisementTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageCard(
    PromotionPackageModel package,
    PromotionController controller,
  ) {
    // Determine package color and icon
    Color packageColor;
    IconData packageIcon;
    bool isRecommended = false;

    if (package.id == 1) {
      // Bronze
      packageColor = const Color(0xFFCD7F32);
      packageIcon = Icons.workspace_premium;
    } else if (package.id == 2) {
      // Silver - Recommended
      packageColor = const Color(0xFFC0C0C0);
      packageIcon = Icons.workspace_premium;
      isRecommended = true;
    } else {
      // Gold
      packageColor = const Color(0xFFFFD700);
      packageIcon = Icons.workspace_premium;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isRecommended ? appTheme.primary : Colors.grey[300]!,
          width: isRecommended ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Recommended Badge
          if (isRecommended)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: appTheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'الأكثر شعبية',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

          // Package Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Icon and Name
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: packageColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        packageIcon,
                        color: packageColor,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            package.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            package.nameEn,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Duration
                _buildInfoRow(
                  Icons.calendar_today,
                  'المدة',
                  package.formattedDuration,
                ),
                const SizedBox(height: 12),

                // Features
                _buildInfoRow(
                  Icons.star_outline,
                  'المميزات',
                  package.features,
                ),
                const SizedBox(height: 16),

                // Divider
                Divider(color: Colors.grey[300]),
                const SizedBox(height: 16),

                // Price and Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'التكلفة',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          package.formattedPrice,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: packageColor,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: controller.isPromoting.value
                          ? null
                          : () => _handlePromote(package, controller),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: packageColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: controller.isPromoting.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'ترويج الآن',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue[200]!,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.blue[700],
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'معلومات هامة',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '• سيتم خصم النقاط من رصيدك فوراً\n'
                  '• سيظهر إعلانك في قسم الإعلانات المميزة\n'
                  '• سيحصل إعلانك على ترتيب أعلى في نتائج البحث\n'
                  '• يمكنك تجديد الترويج بعد انتهاء المدة',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.blue[800],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePromote(
    PromotionPackageModel package,
    PromotionController controller,
  ) async {
    // Show confirmation dialog
    final confirmed = await controller.showPromotionConfirmation(
      context: Get.context!,
      adTitle: advertisementTitle,
      package: package,
    );

    if (!confirmed) return;

    // Promote the ad
    final success = await controller.promoteAd(
      advertisementId: advertisementId,
      packageId: package.id,
    );

    if (success) {
      // Go back to previous screen
      Get.back(result: true);
    }
  }
}

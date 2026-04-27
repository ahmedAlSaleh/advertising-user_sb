import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../../uses_app_sb/core/shared/models/advertisement_model.dart';
import '../controller/trader_ads_controller.dart';
import '../../promotion/view/promotion_packages_screen.dart';
import 'widgets/trader_ad_card.dart';

class MyAdsScreen extends StatelessWidget {
  const MyAdsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TraderAdsController controller = Get.put(TraderAdsController());

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('إعلاناتي'.tr),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: 'نشطة'.tr),
              Tab(text: 'غير نشطة'.tr),
              Tab(text: 'مجدولة'.tr),
              Tab(text: 'منتهية'.tr),
            ],
            isScrollable: false,
            labelColor: appTheme.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: appTheme.primary,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => controller.loadMyAdvertisements(),
            ),
          ],
        ),
        body: Obx(() {
          if (controller.isLoadingMyAds.value &&
              controller.myAdvertisements.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return TabBarView(
            children: [
              // Active Ads Tab
              _buildAdsList(
                controller: controller,
                ads: controller.activeAds,
                emptyMessage: 'لا توجد إعلانات نشطة',
                emptyIcon: Icons.shopping_bag_outlined,
              ),

              // Inactive Ads Tab
              _buildAdsList(
                controller: controller,
                ads: controller.inactiveAds,
                emptyMessage: 'لا توجد إعلانات غير نشطة',
                emptyIcon: Icons.visibility_off_outlined,
              ),

              // Scheduled Ads Tab
              _buildScheduledAdsList(controller),

              // Expired Ads Tab
              _buildExpiredAdsList(controller),
            ],
          );
        }),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _navigateToCreateAd(controller),
          icon: const Icon(Icons.add),
          label: const Text('إضافة إعلان'),
          backgroundColor: appTheme.primary,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildAdsList({
    required TraderAdsController controller,
    required List<AdvertisementModel> ads,
    required String emptyMessage,
    required IconData emptyIcon,
  }) {
    return Obx(() {
      if (ads.isEmpty) {
        return _buildEmptyState(emptyMessage, emptyIcon);
      }

      return RefreshIndicator(
        onRefresh: () => controller.loadMyAdvertisements(),
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: ads.length,
          itemBuilder: (context, index) {
            return TraderAdCard(
              advertisement: ads[index],
              onToggleStatus: () =>
                  controller.updateAdStatus(ads[index].id, !ads[index].isActive),
              onDelete: () => _showDeleteDialog(context, controller, ads[index]),
              onEdit: () => _navigateToEditAd(controller, ads[index]),
              onPromote: () => _navigateToPromote(ads[index]),
            );
          },
        ),
      );
    });
  }

  Widget _buildScheduledAdsList(TraderAdsController controller) {
    return Obx(() {
      if (controller.isLoadingScheduled.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.scheduledAds.isEmpty) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildEmptyState(
              'لا توجد إعلانات مجدولة',
              Icons.schedule_outlined,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => controller.getScheduledAds(),
              icon: const Icon(Icons.refresh),
              label: const Text('تحديث'),
              style: ElevatedButton.styleFrom(
                backgroundColor: appTheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      }

      return RefreshIndicator(
        onRefresh: () => controller.getScheduledAds(),
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: controller.scheduledAds.length,
          itemBuilder: (context, index) {
            final ad = controller.scheduledAds[index];
            return TraderAdCard(
              advertisement: ad,
              onToggleStatus: () =>
                  controller.updateAdStatus(ad.id, !ad.isActive),
              onDelete: () => _showDeleteDialog(context, controller, ad),
              onEdit: () => _navigateToEditAd(controller, ad),
              onPromote: () => _navigateToPromote(ad),
              showScheduleInfo: true,
            );
          },
        ),
      );
    });
  }

  Widget _buildExpiredAdsList(TraderAdsController controller) {
    return Obx(() {
      if (controller.isLoadingExpired.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.expiredAds.isEmpty) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildEmptyState(
              'لا توجد إعلانات منتهية',
              Icons.event_busy_outlined,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => controller.getExpiredAds(),
              icon: const Icon(Icons.refresh),
              label: const Text('تحديث'),
              style: ElevatedButton.styleFrom(
                backgroundColor: appTheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      }

      return RefreshIndicator(
        onRefresh: () => controller.getExpiredAds(),
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: controller.expiredAds.length,
          itemBuilder: (context, index) {
            final ad = controller.expiredAds[index];
            return TraderAdCard(
              advertisement: ad,
              onRenew: () => _showRenewDialog(context, controller, ad),
              onDelete: () => _showDeleteDialog(context, controller, ad),
              showExpiredInfo: true,
            );
          },
        ),
      );
    });
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    TraderAdsController controller,
    AdvertisementModel ad,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: appTheme.error),
            const SizedBox(width: 12),
            const Text('تأكيد الحذف'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('هل أنت متأكد من حذف هذا الإعلان؟'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ad.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${ad.price.toStringAsFixed(0)} د.ع',
                    style: TextStyle(
                      color: appTheme.primary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'لا يمكن التراجع عن هذا الإجراء',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
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
              Get.back();
              controller.deleteAdvertisement(ad.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: appTheme.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _showRenewDialog(
    BuildContext context,
    TraderAdsController controller,
    AdvertisementModel ad,
  ) {
    int selectedDays = 30;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.refresh, color: appTheme.primary),
              const SizedBox(width: 12),
              const Text('تجديد الإعلان'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ad.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              const Text('اختر مدة التجديد:'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildDurationChip(7, selectedDays, (days) {
                    setState(() => selectedDays = days);
                  }),
                  _buildDurationChip(14, selectedDays, (days) {
                    setState(() => selectedDays = days);
                  }),
                  _buildDurationChip(30, selectedDays, (days) {
                    setState(() => selectedDays = days);
                  }),
                  _buildDurationChip(60, selectedDays, (days) {
                    setState(() => selectedDays = days);
                  }),
                  _buildDurationChip(90, selectedDays, (days) {
                    setState(() => selectedDays = days);
                  }),
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
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'سيتم تفعيل الإعلان لمدة $selectedDays يوم',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[700],
                        ),
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
            ElevatedButton.icon(
              onPressed: () {
                Get.back();
                controller.renewAdvertisement(ad.id, selectedDays);
              },
              icon: const Icon(Icons.check),
              label: const Text('تجديد'),
              style: ElevatedButton.styleFrom(
                backgroundColor: appTheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationChip(
    int days,
    int selectedDays,
    Function(int) onSelected,
  ) {
    final isSelected = days == selectedDays;
    return ChoiceChip(
      label: Text('$days يوم'),
      selected: isSelected,
      onSelected: (selected) => onSelected(days),
      selectedColor: appTheme.primary.withValues(alpha: 0.2),
      labelStyle: TextStyle(
        color: isSelected ? appTheme.primary : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  void _navigateToCreateAd(TraderAdsController controller) {
    // Navigate to create ad screen
    // Get.toNamed('/create-ad');
    Get.snackbar(
      'إضافة إعلان',
      'شاشة إضافة الإعلان قيد التطوير',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _navigateToEditAd(
    TraderAdsController controller,
    AdvertisementModel ad,
  ) {
    // Navigate to edit ad screen
    // Get.toNamed('/edit-ad', arguments: ad);
    Get.snackbar(
      'تعديل إعلان',
      'شاشة تعديل الإعلان قيد التطوير',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _navigateToPromote(AdvertisementModel ad) async {
    final result = await Get.to<bool>(
      () => PromotionPackagesScreen(
        advertisementId: ad.id,
        advertisementTitle: ad.title,
      ),
    );

    // If promotion was successful, refresh the ads list
    if (result == true) {
      final controller = Get.find<TraderAdsController>();
      controller.loadMyAdvertisements();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../advertisements/view/widgets/ad_card.dart';
import '../controller/favorites_controller.dart';
import 'widgets/favorite_store_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoritesController controller = Get.put(FavoritesController());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('المفضلة'.tr),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(
                icon: const Icon(Icons.shopping_bag_outlined),
                text: 'الإعلانات'.tr,
              ),
              Tab(
                icon: const Icon(Icons.store_outlined),
                text: 'المتاجر'.tr,
              ),
            ],
            labelColor: appTheme.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: appTheme.primary,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => controller.refreshFavorites(),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            // Favorite Advertisements Tab
            _buildFavoriteAdsTab(controller),

            // Favorite Stores Tab
            _buildFavoriteStoresTab(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteAdsTab(FavoritesController controller) {
    return Obx(() {
      if (controller.isLoadingAds.value && controller.favoriteAds.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.favoriteAds.isEmpty) {
        return _buildEmptyState(
          Icons.favorite_border,
          'لا توجد إعلانات مفضلة',
          'قم بإضافة إعلانات إلى المفضلة لتظهر هنا',
        );
      }

      return RefreshIndicator(
        onRefresh: () => controller.getFavoriteAds(),
        child: GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: controller.favoriteAds.length,
          itemBuilder: (context, index) {
            final ad = controller.favoriteAds[index];
            return Stack(
              children: [
                AdCard(
                  advertisement: ad,
                  isGridView: true,
                ),
                // Remove from favorites button
                Positioned(
                  top: 8,
                  left: 8,
                  child: InkWell(
                    onTap: () => _showRemoveDialog(
                      controller,
                      'إزالة من المفضلة',
                      'هل تريد إزالة "${ad.title}" من المفضلة؟',
                      () => controller.toggleAdFavorite(ad.id),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: appTheme.error,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    });
  }

  Widget _buildFavoriteStoresTab(FavoritesController controller) {
    return Obx(() {
      if (controller.isLoadingStores.value &&
          controller.favoriteStores.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.favoriteStores.isEmpty) {
        return _buildEmptyState(
          Icons.store_outlined,
          'لا توجد متاجر مفضلة',
          'قم بإضافة متاجر إلى المفضلة لتظهر هنا',
        );
      }

      return RefreshIndicator(
        onRefresh: () => controller.getFavoriteStores(),
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: controller.favoriteStores.length,
          itemBuilder: (context, index) {
            final store = controller.favoriteStores[index];
            return FavoriteStoreCard(
              store: store,
              onRemove: () => _showRemoveDialog(
                controller,
                'إزالة من المفضلة',
                'هل تريد إزالة "${store.storeName}" من المفضلة؟',
                () => controller.toggleStoreFavorite(store.id),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildEmptyState(IconData icon, String title, String subtitle) {
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
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRemoveDialog(
    FavoritesController controller,
    String title,
    String message,
    VoidCallback onConfirm,
  ) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.delete_outline, color: appTheme.error),
            const SizedBox(width: 12),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: appTheme.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('إزالة'),
          ),
        ],
      ),
    );
  }
}

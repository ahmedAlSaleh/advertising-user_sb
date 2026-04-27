import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../main.dart';
import '../../../core/shared/models/store_model.dart';
import '../../rating/controller/rating_controller.dart';
import '../../rating/view/widgets/rating_dialog.dart';
import '../../rating/view/widgets/store_ratings_widget.dart';
import '../../reports/view/widgets/report_dialog.dart';
import '../controller/stores_controller.dart';
import 'widgets/store_hours_widget.dart';

class StoreDetailsScreen extends StatelessWidget {
  final int storeId;
  final bool isGuest;

  const StoreDetailsScreen({
    super.key,
    required this.storeId,
    this.isGuest = false,
  });

  @override
  Widget build(BuildContext context) {
    final StoresController controller = Get.put(StoresController());

    // Load store details
    controller.showStoreDetails(storeId, isGuest: isGuest);
    controller.getStorePosts(storeId);
    controller.getStoreAdvertisements(storeId, isGuest: isGuest);

    return Scaffold(
      body: Obx(() {
        if (controller.isLoadingStoreDetails.value &&
            controller.selectedStore.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final store = controller.selectedStore.value;
        if (store == null) {
          return _buildErrorState();
        }

        return CustomScrollView(
          slivers: [
            // App Bar with image
            _buildAppBar(store),

            // Store Info
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStoreHeader(store),
                  const Divider(),
                  _buildStoreStats(store),
                  const Divider(),
                  _buildContactButtons(store),
                  const Divider(),

                  // Rate Store Button
                  if (!isGuest) _buildRateButton(store),
                  if (!isGuest) const Divider(),

                  // Store Hours Widget
                  StoreHoursWidget(storeId: storeId),
                  const Divider(),

                  // Categories
                  if (store.categories.isNotEmpty) ...[
                    _buildCategoriesSection(store),
                    const Divider(),
                  ],

                  // Store Ratings Widget
                  StoreRatingsWidget(storeId: storeId),
                  const Divider(),

                  // Posts Section
                  _buildPostsSection(controller),

                  // Advertisements Section
                  _buildAdvertisementsSection(controller),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildAppBar(StoreModel store) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          store.storeName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black54,
                blurRadius: 10,
              ),
            ],
          ),
        ),
        background: store.image != null
            ? Image.network(
                store.image!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholderImage();
                },
              )
            : _buildPlaceholderImage(),
      ),
      actions: [
        // Report button
        if (!isGuest)
          IconButton(
            icon: const Icon(
              Icons.flag,
              color: Colors.white,
            ),
            onPressed: () => _showReportDialog(store),
          ),
        // Favorite button
        IconButton(
          icon: Icon(
            store.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: store.isFavorite ? Colors.red : Colors.white,
          ),
          onPressed: () {
            // Toggle favorite
          },
        ),
      ],
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey[300],
      child: Icon(
        Icons.store,
        size: 80,
        color: Colors.grey[400],
      ),
    );
  }

  Widget _buildStoreHeader(StoreModel store) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store name
          Text(
            store.storeName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Owner name
          Text(
            'المالك: ${store.storeOwnerName}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),

          // City
          if (store.trader?.city != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  store.trader!.city!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],

          // Rating
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber[700], size: 24),
              const SizedBox(width: 4),
              Text(
                store.averageRating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(${store.totalReviews} تقييم)',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStoreStats(StoreModel store) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            Icons.shopping_bag_outlined,
            store.advertisementsCount.toString(),
            'إعلان',
            appTheme.primary,
          ),
          _buildStatItem(
            Icons.article_outlined,
            store.postsCount.toString(),
            'منشور',
            Colors.orange,
          ),
          _buildStatItem(
            Icons.star_outline,
            store.totalReviews.toString(),
            'تقييم',
            Colors.amber[700]!,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildContactButtons(StoreModel store) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (store.trader?.whatsappNumber != null)
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _launchWhatsApp(store.trader!.whatsappNumber!),
                icon: const Icon(Icons.phone, size: 20),
                label: const Text('واتساب'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          if (store.trader?.whatsappNumber != null &&
              store.trader?.telegramNumber != null)
            const SizedBox(width: 12),
          if (store.trader?.telegramNumber != null)
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _launchTelegram(store.trader!.telegramNumber!),
                icon: const Icon(Icons.send, size: 20),
                label: const Text('تيليجرام'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0088cc),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRateButton(StoreModel store) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton.icon(
        onPressed: () {
          // Initialize rating controller if not exists
          Get.put(RatingController(), tag: 'rating_$storeId');

          // Show rating dialog
          Get.dialog(
            RatingDialog(
              storeId: storeId,
              storeName: store.storeName,
            ),
          );
        },
        icon: const Icon(Icons.star_outline, size: 20),
        label: const Text('قيّم المتجر'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber[700],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(StoreModel store) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'التصنيفات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: store.categories.map((category) {
              return Chip(
                label: Text(category.name),
                backgroundColor: appTheme.primary.withValues(alpha: 0.1),
                labelStyle: TextStyle(color: appTheme.primary),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsSection(StoresController controller) {
    return Obx(() {
      if (controller.isLoadingPosts.value) {
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.storePosts.isEmpty) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'المنشورات',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.storePosts.length,
              itemBuilder: (context, index) {
                final post = controller.storePosts[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post.content),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              post.isLiked ? Icons.favorite : Icons.favorite_border,
                              size: 18,
                              color: post.isLiked ? Colors.red : Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text('${post.likesCount}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _buildAdvertisementsSection(StoresController controller) {
    return Obx(() {
      if (controller.isLoadingAds.value) {
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.storeAdvertisements.isEmpty) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الإعلانات',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: controller.storeAdvertisements.length,
              itemBuilder: (context, index) {
                final ad = controller.storeAdvertisements[index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ad.images.isNotEmpty
                            ? Image.network(
                                ad.images.first,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              )
                            : Container(color: Colors.grey[300]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ad.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${ad.price.toStringAsFixed(0)} د.ع',
                              style: TextStyle(color: appTheme.primary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text('لم يتم العثور على المتجر'),
        ],
      ),
    );
  }

  void _launchWhatsApp(String number) async {
    final url = 'https://wa.me/$number';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  void _launchTelegram(String username) async {
    final url = 'https://t.me/$username';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  void _showReportDialog(StoreModel store) {
    Get.dialog(
      ReportDialog(
        reportableType: 'store',
        reportableId: store.id,
        itemTitle: store.storeName,
      ),
    );
  }
}

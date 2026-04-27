import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../controller/advertisement_controller.dart';
import 'widgets/ad_card.dart';
import 'widgets/filter_dialog.dart';

class AdvertisementsScreen extends StatelessWidget {
  const AdvertisementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AdvertisementController controller =
        Get.put(AdvertisementController());

    return Scaffold(
      appBar: AppBar(
        title: Text('الإعلانات'.tr),
        centerTitle: true,
        actions: [
          // View toggle button
          Obx(() => IconButton(
                icon: Icon(
                  controller.isGridView.value ? Icons.list : Icons.grid_view,
                ),
                onPressed: () => controller.toggleView(),
              )),
          // Filter button
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context, controller),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading && controller.advertisements.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.advertisements.isEmpty) {
          return _buildEmptyState(controller);
        }

        return RefreshIndicator(
          onRefresh: () => controller.refreshData(),
          child: CustomScrollView(
            controller: controller.scrollController,
            slivers: [
              // Featured Ads Section
              if (controller.featuredAds.isNotEmpty)
                SliverToBoxAdapter(
                  child: _buildFeaturedSection(controller),
                ),

              // Active Filter Chips
              Obx(() {
                if (controller.hasActiveFilter) {
                  return SliverToBoxAdapter(
                    child: _buildActiveFilters(controller),
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              }),

              // Advertisements Grid/List
              Obx(() {
                if (controller.isGridView.value) {
                  return SliverPadding(
                    padding: const EdgeInsets.all(8),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return AdCard(
                            advertisement: controller.advertisements[index],
                            isGridView: true,
                          );
                        },
                        childCount: controller.advertisements.length,
                      ),
                    ),
                  );
                } else {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return AdCard(
                          advertisement: controller.advertisements[index],
                          isGridView: false,
                        );
                      },
                      childCount: controller.advertisements.length,
                    ),
                  );
                }
              }),

              // Loading More Indicator
              Obx(() {
                if (controller.isLoadingMore.value) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              }),

              // End of list message
              Obx(() {
                if (controller.advertisements.isNotEmpty &&
                    !controller.hasMore) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Text(
                          'لا توجد المزيد من الإعلانات',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              }),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildFeaturedSection(AdvertisementController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.star, color: Colors.amber[700], size: 24),
              const SizedBox(width: 8),
              Text(
                'إعلانات مميزة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: appTheme.primaryText,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: controller.featuredAds.length,
            itemBuilder: (context, index) {
              return SizedBox(
                width: 160,
                child: AdCard(
                  advertisement: controller.featuredAds[index],
                  isGridView: true,
                  isFeatured: true,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        const Divider(),
      ],
    );
  }

  Widget _buildActiveFilters(AdvertisementController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (controller.filter.value.categoryId != null)
            _buildFilterChip(
              'التصنيف',
              () => controller.clearFilter('category'),
            ),
          if (controller.filter.value.city != null)
            _buildFilterChip(
              controller.filter.value.city!,
              () => controller.clearFilter('city'),
            ),
          if (controller.filter.value.minPrice != null ||
              controller.filter.value.maxPrice != null)
            _buildFilterChip(
              'السعر',
              () => controller.clearFilter('price'),
            ),
          if (controller.filter.value.type != null)
            _buildFilterChip(
              controller.filter.value.type == 'special' ? 'مميز' : 'عادي',
              () => controller.clearFilter('type'),
            ),
          // Clear all button
          InkWell(
            onTap: () => controller.resetFilter(),
            child: Chip(
              label: const Text('مسح الكل'),
              deleteIcon: const Icon(Icons.close, size: 18),
              onDeleted: () => controller.resetFilter(),
              backgroundColor: appTheme.error.withValues(alpha: 0.1),
              labelStyle: TextStyle(color: appTheme.error, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onDelete) {
    return Chip(
      label: Text(label),
      deleteIcon: const Icon(Icons.close, size: 18),
      onDeleted: onDelete,
      backgroundColor: appTheme.primary.withValues(alpha: 0.1),
      labelStyle: TextStyle(color: appTheme.primary, fontSize: 12),
    );
  }

  Widget _buildEmptyState(AdvertisementController controller) {
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
            'لا توجد إعلانات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'جرب تغيير الفلاتر للعثور على إعلانات',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          if (controller.hasActiveFilter)
            ElevatedButton.icon(
              onPressed: () => controller.resetFilter(),
              icon: const Icon(Icons.refresh),
              label: const Text('مسح الفلاتر'),
              style: ElevatedButton.styleFrom(
                backgroundColor: appTheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  void _showFilterDialog(
      BuildContext context, AdvertisementController controller) {
    showDialog(
      context: context,
      builder: (context) => FilterDialog(controller: controller),
    );
  }
}

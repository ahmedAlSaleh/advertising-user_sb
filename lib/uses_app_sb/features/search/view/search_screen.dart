import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../main.dart';
import '../../advertisements/view/widgets/ad_card.dart';
import '../../posts/view/widgets/post_card.dart';
import '../controller/search_controller.dart' as app_search;

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app_search.SearchController controller = Get.put(app_search.SearchController());

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: controller.searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'ابحث عن إعلانات، منشورات، متاجر...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey[400]),
          ),
          onSubmitted: (query) => controller.simpleSearch(query),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => Get.toNamed('/advanced-search'),
            tooltip: 'بحث متقدم',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isSearching.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!controller.hasResults) {
          return _buildEmptyState();
        }

        return DefaultTabController(
          length: 3,
          child: Column(
            children: [
              TabBar(
                labelColor: appTheme.primary,
                unselectedLabelColor: Colors.grey,
                indicatorColor: appTheme.primary,
                tabs: [
                  Tab(
                    text: 'الإعلانات (${controller.searchResults.value?.advertisements.length ?? 0})',
                  ),
                  Tab(
                    text: 'المنشورات (${controller.searchResults.value?.posts.length ?? 0})',
                  ),
                  Tab(
                    text: 'المتاجر (${controller.searchResults.value?.stores.length ?? 0})',
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildAdvertisementsTab(controller),
                    _buildPostsTab(controller),
                    _buildStoresTab(controller),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'ابدأ البحث',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'اكتب كلمة البحث في الأعلى',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvertisementsTab(app_search.SearchController controller) {
    final ads = controller.searchResults.value?.advertisements ?? [];

    if (ads.isEmpty) {
      return Center(
        child: Text('لا توجد إعلانات', style: TextStyle(color: Colors.grey[600])),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: ads.length,
      itemBuilder: (context, index) {
        return AdCard(advertisement: ads[index], isGridView: true);
      },
    );
  }

  Widget _buildPostsTab(app_search.SearchController controller) {
    final posts = controller.searchResults.value?.posts ?? [];

    if (posts.isEmpty) {
      return Center(
        child: Text('لا توجد منشورات', style: TextStyle(color: Colors.grey[600])),
      );
    }

    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return PostCard(post: posts[index]);
      },
    );
  }

  Widget _buildStoresTab(app_search.SearchController controller) {
    final stores = controller.searchResults.value?.stores ?? [];

    if (stores.isEmpty) {
      return Center(
        child: Text('لا توجد متاجر', style: TextStyle(color: Colors.grey[600])),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: stores.length,
      itemBuilder: (context, index) {
        final store = stores[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: appTheme.primary.withValues(alpha: 0.1),
              child: Icon(Icons.store, color: appTheme.primary),
            ),
            title: Text(store.storeName, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: store.trader?.city != null ? Text(store.trader!.city!) : null,
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Get.toNamed('/store-details', arguments: {'storeId': store.id}),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../controller/categories_controller.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoriesController controller = Get.put(CategoriesController());

    // Load categories on init
    if (!controller.hasCategories) {
      controller.getCategories();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('التصنيفات'),
        backgroundColor: appTheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.getCategories(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoadingCategories.value &&
            controller.categories.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!controller.hasCategories) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: controller.getCategories,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
              final category = controller.categories[index];
              return _buildCategoryCard(category);
            },
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
          Icon(
            Icons.category_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد تصنيفات',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(category) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: appTheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.category,
            color: appTheme.primary,
          ),
        ),
        title: Text(
          category.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: category.hasSubCategories
            ? Text(
                '${category.subCategories.length} تصنيف فرعي',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              )
            : null,
        children: category.subCategories.isEmpty
            ? [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'لا توجد تصنيفات فرعية',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ),
              ]
            : category.subCategories
                .map<Widget>((subCategory) => ListTile(
                      leading: Icon(
                        Icons.subdirectory_arrow_right,
                        color: Colors.grey[600],
                      ),
                      title: Text(subCategory.name),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey[400],
                      ),
                      onTap: () {
                        // Navigate to sub-category items
                        // Get.toNamed('/category-items', arguments: subCategory);
                      },
                    ))
                .toList(),
      ),
    );
  }
}

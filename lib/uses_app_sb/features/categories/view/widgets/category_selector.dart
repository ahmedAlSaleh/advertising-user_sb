import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../main.dart';
import '../../../../core/shared/models/category_model.dart';
import '../../controller/categories_controller.dart';

class CategorySelector extends StatelessWidget {
  final int? selectedCategoryId;
  final int? selectedSubCategoryId;
  final Function(int?) onCategoryChanged;
  final Function(int?)? onSubCategoryChanged;
  final bool showSubCategory;

  const CategorySelector({
    super.key,
    this.selectedCategoryId,
    this.selectedSubCategoryId,
    required this.onCategoryChanged,
    this.onSubCategoryChanged,
    this.showSubCategory = true,
  });

  @override
  Widget build(BuildContext context) {
    final CategoriesController controller = Get.put(CategoriesController());

    // Load categories if not loaded
    if (!controller.hasCategories) {
      controller.getCategories();
    }

    return Obx(() {
      if (controller.isLoadingCategories.value) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 12),
              Text('جاري تحميل التصنيفات...'),
            ],
          ),
        );
      }

      if (!controller.hasCategories) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.orange[300]!),
            borderRadius: BorderRadius.circular(8),
            color: Colors.orange[50],
          ),
          child: Row(
            children: [
              Icon(Icons.warning_amber, color: Colors.orange[700]),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('تعذر تحميل التصنيفات'),
              ),
              TextButton(
                onPressed: () => controller.getCategories(),
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        );
      }

      return Column(
        children: [
          // Category Dropdown
          _buildCategoryDropdown(controller),

          // Sub-Category Dropdown (if enabled and category selected)
          if (showSubCategory && selectedCategoryId != null) ...[
            const SizedBox(height: 12),
            _buildSubCategoryDropdown(controller),
          ],
        ],
      );
    });
  }

  Widget _buildCategoryDropdown(CategoriesController controller) {
    return DropdownButtonFormField<int>(
      value: selectedCategoryId,
      decoration: InputDecoration(
        hintText: 'اختر التصنيف',
        prefixIcon: Icon(Icons.category, color: appTheme.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: appTheme.primary, width: 2),
        ),
      ),
      items: [
        const DropdownMenuItem<int>(
          value: null,
          child: Text('جميع التصنيفات'),
        ),
        ...controller.categories.map((category) {
          return DropdownMenuItem<int>(
            value: category.id,
            child: Text(category.name),
          );
        }),
      ],
      onChanged: (value) {
        onCategoryChanged(value);
        // Reset sub-category when category changes
        if (onSubCategoryChanged != null) {
          onSubCategoryChanged!(null);
        }
      },
    );
  }

  Widget _buildSubCategoryDropdown(CategoriesController controller) {
    final selectedCategory = controller.getCategoryById(selectedCategoryId!);

    if (selectedCategory == null || !selectedCategory.hasSubCategories) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[50],
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.grey[600]),
            const SizedBox(width: 12),
            const Expanded(
              child: Text('لا توجد تصنيفات فرعية'),
            ),
          ],
        ),
      );
    }

    return DropdownButtonFormField<int>(
      value: selectedSubCategoryId,
      decoration: InputDecoration(
        hintText: 'اختر التصنيف الفرعي',
        prefixIcon: Icon(Icons.subdirectory_arrow_right, color: appTheme.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: appTheme.primary, width: 2),
        ),
      ),
      items: [
        const DropdownMenuItem<int>(
          value: null,
          child: Text('جميع التصنيفات الفرعية'),
        ),
        ...selectedCategory.subCategories.map((subCategory) {
          return DropdownMenuItem<int>(
            value: subCategory.id,
            child: Text(subCategory.name),
          );
        }),
      ],
      onChanged: onSubCategoryChanged,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../main.dart';
import '../../../../core/shared/models/advertisement_model.dart';
import '../../controller/advertisement_controller.dart';

class FilterDialog extends StatefulWidget {
  final AdvertisementController controller;

  const FilterDialog({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late int? selectedCategoryId;
  late int? selectedSubCategoryId;
  late String? selectedCity;
  late double? minPrice;
  late double? maxPrice;
  late String? selectedType;

  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();

  // Sample cities - should be loaded from API
  final List<String> cities = [
    'بغداد',
    'البصرة',
    'نينوى',
    'أربيل',
    'النجف',
    'كربلاء',
    'ديالى',
    'الأنبار',
    'ذي قار',
    'القادسية',
    'المثنى',
    'واسط',
    'صلاح الدين',
    'بابل',
    'ميسان',
    'دهوك',
    'السليمانية',
    'كركوك',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize with current filter values
    selectedCategoryId = widget.controller.filter.value.categoryId;
    selectedSubCategoryId = widget.controller.filter.value.subCategoryId;
    selectedCity = widget.controller.filter.value.city;
    minPrice = widget.controller.filter.value.minPrice;
    maxPrice = widget.controller.filter.value.maxPrice;
    selectedType = widget.controller.filter.value.type;

    // Set text controllers
    if (minPrice != null) {
      minPriceController.text = minPrice!.toStringAsFixed(0);
    }
    if (maxPrice != null) {
      maxPriceController.text = maxPrice!.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    minPriceController.dispose();
    maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(Icons.filter_list, color: appTheme.primary),
          const SizedBox(width: 12),
          const Text('تصفية الإعلانات'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // City filter
            _buildCityFilter(),
            const SizedBox(height: 16),

            // Price range filter
            _buildPriceRangeFilter(),
            const SizedBox(height: 16),

            // Type filter
            _buildTypeFilter(),
            const SizedBox(height: 16),

            // Category filter placeholder
            _buildCategoryPlaceholder(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => _resetFilters(),
          child: const Text('مسح الكل'),
        ),
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            'إلغاء',
            style: TextStyle(color: Colors.grey[700]),
          ),
        ),
        ElevatedButton(
          onPressed: () => _applyFilters(),
          style: ElevatedButton.styleFrom(
            backgroundColor: appTheme.primary,
            foregroundColor: Colors.white,
          ),
          child: const Text('تطبيق'),
        ),
      ],
    );
  }

  Widget _buildCityFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'المدينة',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedCity,
          decoration: InputDecoration(
            hintText: 'اختر المدينة',
            prefixIcon: const Icon(Icons.location_on),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text('جميع المدن'),
            ),
            ...cities.map((city) {
              return DropdownMenuItem<String>(
                value: city,
                child: Text(city),
              );
            }).toList(),
          ],
          onChanged: (value) {
            setState(() {
              selectedCity = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPriceRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نطاق السعر (د.ع)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: minPriceController,
                decoration: InputDecoration(
                  hintText: 'من',
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  minPrice = double.tryParse(value);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: maxPriceController,
                decoration: InputDecoration(
                  hintText: 'إلى',
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  maxPrice = double.tryParse(value);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نوع الإعلان',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              label: const Text('الكل'),
              selected: selectedType == null,
              onSelected: (selected) {
                setState(() {
                  selectedType = null;
                });
              },
              selectedColor: appTheme.primary.withValues(alpha: 0.2),
              labelStyle: TextStyle(
                color: selectedType == null ? appTheme.primary : Colors.grey[700],
              ),
            ),
            ChoiceChip(
              label: const Text('عادي'),
              selected: selectedType == 'normal',
              onSelected: (selected) {
                setState(() {
                  selectedType = 'normal';
                });
              },
              selectedColor: appTheme.primary.withValues(alpha: 0.2),
              labelStyle: TextStyle(
                color: selectedType == 'normal' ? appTheme.primary : Colors.grey[700],
              ),
            ),
            ChoiceChip(
              label: const Text('مميز'),
              selected: selectedType == 'special',
              onSelected: (selected) {
                setState(() {
                  selectedType = 'special';
                });
              },
              selectedColor: appTheme.primary.withValues(alpha: 0.2),
              labelStyle: TextStyle(
                color: selectedType == 'special' ? appTheme.primary : Colors.grey[700],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryPlaceholder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'التصنيف',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              Icon(Icons.category, color: Colors.grey[400]),
              const SizedBox(width: 8),
              Text(
                'التصنيفات (قريباً)',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _applyFilters() {
    final newFilter = AdvertisementFilter(
      categoryId: selectedCategoryId,
      subCategoryId: selectedSubCategoryId,
      city: selectedCity,
      minPrice: minPrice,
      maxPrice: maxPrice,
      type: selectedType,
      page: 1,
      perPage: widget.controller.filter.value.perPage,
    );

    widget.controller.applyFilter(newFilter);
    Get.back();
  }

  void _resetFilters() {
    setState(() {
      selectedCategoryId = null;
      selectedSubCategoryId = null;
      selectedCity = null;
      minPrice = null;
      maxPrice = null;
      selectedType = null;
      minPriceController.clear();
      maxPriceController.clear();
    });

    widget.controller.resetFilter();
    Get.back();
  }
}

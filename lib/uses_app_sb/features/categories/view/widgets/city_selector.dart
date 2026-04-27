import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../main.dart';
import '../../controller/categories_controller.dart';

class CitySelector extends StatelessWidget {
  final String? selectedCity;
  final Function(String?) onChanged;
  final String? hintText;

  const CitySelector({
    super.key,
    this.selectedCity,
    required this.onChanged,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final CategoriesController controller = Get.put(CategoriesController());

    // Load cities if not loaded
    if (!controller.hasCities) {
      controller.getCities();
    }

    return Obx(() {
      if (controller.isLoadingCities.value) {
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
              Text('جاري تحميل المدن...'),
            ],
          ),
        );
      }

      if (!controller.hasCities) {
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
                child: Text('تعذر تحميل المدن'),
              ),
              TextButton(
                onPressed: () => controller.getCities(),
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        );
      }

      return DropdownButtonFormField<String>(
        value: selectedCity,
        decoration: InputDecoration(
          hintText: hintText ?? 'اختر المدينة',
          prefixIcon: Icon(Icons.location_city, color: appTheme.primary),
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
          const DropdownMenuItem<String>(
            value: null,
            child: Text('جميع المدن'),
          ),
          ...controller.cities.map((city) {
            return DropdownMenuItem<String>(
              value: city,
              child: Text(city),
            );
          }).toList(),
        ],
        onChanged: onChanged,
      );
    });
  }
}

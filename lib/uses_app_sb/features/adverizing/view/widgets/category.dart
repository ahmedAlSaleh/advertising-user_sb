import 'package:advertising_user/uses_app_sb/core/shared/models/store_category.dart';
import 'package:advertising_user/uses_app_sb/features/adverizing/controlller/advertizing_controller.dart';
import 'package:advertising_user/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CategoryFilters extends StatelessWidget {
  const CategoryFilters({super.key});

  @override
  Widget build(BuildContext context) {
    final AdvertiseController controller = Get.find();

    return Obx(() => SizedBox(
          height: 45.h, // Fixed height
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.storesCategory.length,
            itemBuilder: (context, index) {
              final category = controller.storesCategory[index];
              return CategoryFilterButton(category: category);
            },
          ),
        ));
  }
}

class CategoryFilterButton extends StatefulWidget {
  final Datum category;

  const CategoryFilterButton({super.key, required this.category});

  @override
  State<CategoryFilterButton> createState() => _CategoryFilterButtonState();
}

class _CategoryFilterButtonState extends State<CategoryFilterButton> {
  final AdvertiseController controller = Get.find();

  // Cache color values to avoid repeated withOpacity() calls
  late final Color _unselectedBorderColor;

  // Cache BorderRadius value
  late final BorderRadius _buttonRadius;

  @override
  void initState() {
    super.initState();
    _unselectedBorderColor = appTheme.primary.withOpacity(0.2);
    _buttonRadius = BorderRadius.circular(20.r);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10.w),
      child: Obx(() {
        final selected = controller.selectedCategory.value == widget.category;
        return GestureDetector(
          onTap: () {
            controller.selectCategory(widget.category);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            decoration: BoxDecoration(
              gradient: selected
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        appTheme.primary,
                        appTheme.primary.withOpacity(0.85),
                      ],
                    )
                  : null,
              color: selected ? null : Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(25.r),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: appTheme.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              widget.category.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        );
      }),
    );
  }
}

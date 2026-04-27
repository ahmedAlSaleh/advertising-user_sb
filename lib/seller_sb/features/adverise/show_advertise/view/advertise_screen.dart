import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
 import 'package:advertising_user/seller_sb/features/adverise/show_advertise/controller/adverize_controller.dart';
import 'package:advertising_user/seller_sb/features/adverise/show_advertise/view/adverise_item.dart';
 import 'package:advertising_user/seller_sb/features/adverise/add_advertise/view/add_advertise_screen.dart'; // Import AddAdvertiseScreen
import 'package:advertising_user/main.dart';

import '../../../../../uses_app_sb/core/shared/widgets/app_bar/general_app_bar.dart';
import '../../../../../uses_app_sb/core/shared/widgets/loaders/combined_loaders.dart';
import '../../../../../uses_app_sb/core/shared/widgets/image/logo_app_widget.dart';

class AdvertiseScreen extends StatelessWidget {
  const AdvertiseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AdverizeController controller = Get.put(AdverizeController());

    return Scaffold(
      backgroundColor: appTheme.primaryBackground,
      appBar: generalAppBar(
        context: context,
        title: Row(
          children: [
            Text(
              'My Advertisements'.tr,
              style: appTheme.text16.copyWith(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            logoAppWidget(size: 35),
          ],
        ),
      ),
      body: Obx(() {
        // Handle loading state
        if (controller.isLoading.value) {
          return   Center(
            child: GlowingBoxLoader(message: 'Loading'.tr),
          );
        }

        // Handle error state
        if (controller.isError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Failed to load advertisements.'.tr,
                  style: appTheme.text16.copyWith(color: appTheme.error),
                ),
                SizedBox(height: 8.h),
                ElevatedButton(
                  onPressed: controller.refreshData, // Retry fetching data
                  child: Text('Retry'.tr),
                ),
              ],
            ),
          );
        }

        // Display empty message or advertisements with refresh indicator
        return RefreshIndicator(
          onRefresh: () async {
            await controller.refreshData();
          },
          child: controller.itemList.isEmpty
              ? ListView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.h),
                  children: [
                    300.verticalSpace,
                    Center(
                      child: Text(
                        'No advertisements available'.tr,
                        style: appTheme.text16
                            .copyWith(color: appTheme.secondaryText),
                      ),
                    ),
                  ],
                )
              : ListView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.h),
                  children: [
                    const SectionTitle(title: 'My Advertisements'),
                    SizedBox(height: 16.0.h),
                    ItemList(items: controller.itemList),
                  ],
                ),
        );
      }),

      // Add the Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the Add Advertisement screen
          Get.to(() =>
              AddAdvertiseScreen()); // Replace with the actual Add Advertise screen
        },
        backgroundColor: appTheme.primary,
        tooltip: 'Add New Advertisement'.tr,
        child: Icon(
          Icons.add,
          color: appTheme.primaryBackground,
          size: 24.sp,
        ),
      ),
    );
  }
}

// SectionTitle Widget
class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: appTheme.text18.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

import 'package:advertising_user/main.dart';
import 'package:advertising_user/uses_app_sb/core/shared/widgets/app_bar/general_app_bar.dart';
import 'package:advertising_user/uses_app_sb/core/shared/widgets/empty_data/empty_data_widget.dart';
import 'package:advertising_user/uses_app_sb/core/shared/widgets/image/network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/blocked_stores_controller.dart';
import '../model/blocked_store_model.dart';

class BlockedStoresScreen extends StatelessWidget {
  const BlockedStoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BlockedStoresController controller =
        Get.put(BlockedStoresController());

    return Scaffold(
      appBar: generalAppBar(
        context: context,
        title: Text(
          'Banned Stores'.tr,
          style: appTheme.text16.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: appTheme.primaryBackground,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: appTheme.primary,
            ),
          );
        }

        if (controller.isNotAuthenticated.value) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 80.sp,
                    color: appTheme.secondaryText,
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Login Required'.tr,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: appTheme.primaryText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Please log in to view your banned stores'.tr,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: appTheme.secondaryText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32.h),
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/SignInScreen');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appTheme.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 32.w,
                        vertical: 14.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Log In'.tr,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (controller.isError.value) {
          return EmptyData(
            icon: Icons.error_outline,
            message: 'Error loading blocked stores. Please try again later.'.tr,
            onTap: () {
              controller.getBlockedStores();
            },
          );
        }

        if (controller.blockedStores.isEmpty) {
          return EmptyData(
            icon: Icons.block,
            message: 'No'.tr,
            onTap: null,
          );
        }

        return ListView.separated(
          padding: EdgeInsets.all(16.w),
          itemCount: controller.blockedStores.length,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final store = controller.blockedStores[index];
            return RepaintBoundary(
              child: _BlockedStoreItem(
                store: store,
                controller: controller,
                index: index,
              ),
            );
          },
        );
      }),
    );
  }
}

class _BlockedStoreItem extends StatelessWidget {
  final BlockedStore store;
  final BlockedStoresController controller;
  final int index;

  const _BlockedStoreItem({
    required this.store,
    required this.controller,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    // Cache color value
    final borderColor = appTheme.primaryText.withOpacity(0.1);

    return Container(
      decoration: BoxDecoration(
        color: appTheme.secondaryBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          // Store Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: store.image != null && store.image!.isNotEmpty
                ? getImageNetwork(
                    url: store.image!,
                    width: 60.w,
                    height: 60.w,
                  )
                : Container(
                    width: 60.w,
                    height: 60.w,
                    color: appTheme.primaryBackground,
                    child: Icon(
                      Icons.store,
                      size: 30.sp,
                      color: appTheme.secondaryText,
                    ),
                  ),
          ),
          SizedBox(width: 12.w),
          // Store Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  store.storeName,
                  style: appTheme.text16.copyWith(
                    fontWeight: FontWeight.bold,
                    color: appTheme.primaryText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  store.storeOwnerName,
                  style: appTheme.text14.copyWith(
                    color: appTheme.secondaryText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  store.storeNumber,
                  style: appTheme.text12.copyWith(
                    color: appTheme.secondaryText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Unblock Button
          ElevatedButton(
            onPressed: () {
              _showUnblockDialog(context, controller, store.id, index);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: appTheme.error,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 10.h,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Unblock'.tr,
              style: appTheme.text14.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showUnblockDialog(
      BuildContext context, BlockedStoresController controller, int storeId, int index) {
    Get.dialog(
      _UnblockDialog(
        controller: controller,
        storeId: storeId,
        index: index,
      ),
      barrierDismissible: true,
    );
  }
}

class _UnblockDialog extends StatelessWidget {
  final BlockedStoresController controller;
  final int storeId;
  final int index;

  const _UnblockDialog({
    required this.controller,
    required this.storeId,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: appTheme.primaryBackground,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.block,
              size: 48.sp,
              color: appTheme.primary,
            ),
            SizedBox(height: 16.h),
            Text(
              'Unblock Store'.tr,
              style: appTheme.text18.copyWith(
                fontWeight: FontWeight.bold,
                color: appTheme.primaryText,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'Are you sure you want to unblock this store?'.tr,
              style: appTheme.text14.copyWith(
                color: appTheme.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: appTheme.primaryText,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      side: BorderSide(color: appTheme.secondaryText, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Cancel'.tr,
                      style: appTheme.text14.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Get.back();
                      await controller.unblockStore(storeId, index);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appTheme.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Unblock'.tr,
                      style: appTheme.text14.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

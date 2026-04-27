import 'package:flutter/services.dart';
import '../../../../uses_app_sb/core/shared/widgets/dialogs/exit_confirmation_dialog.dart';
import '../../../../uses_app_sb/core/theme/app_theme.dart';
import '../controller/main_bottom_navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:advertising_user/main.dart';

class MainBottomNavigationBarWidget extends StatefulWidget {
  const MainBottomNavigationBarWidget({super.key});

  @override
  State<MainBottomNavigationBarWidget> createState() =>
      _MainBottomNavigationBarWidgetState();
}

class _MainBottomNavigationBarWidgetState
    extends State<MainBottomNavigationBarWidget> {
  final MainBottomNavigationController mainBottomNavigationController =
      Get.find();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appTheme = AppTheme.of(context);
  }

  @override
  Widget build(BuildContext context) {
    // Calculate colors on each build so they update with theme changes
    final borderColor = appTheme.primaryText.withOpacity(0.08);
    final selectedBgColor = appTheme.primary.withOpacity(0.2);

    return PopScope(
      canPop: false,
      onPopInvoked: (popHandled) async {
        if (mainBottomNavigationController.selectedPage.value != 0) {
          mainBottomNavigationController.changePage(0);
        } else {
          // Show exit confirmation dialog
          final shouldExit = await showExitConfirmationDialog();
          if (shouldExit) {
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        body: Obx(() => mainBottomNavigationController
            .getScreen(mainBottomNavigationController.selectedPage.value)),
        extendBody: true,
        bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: appTheme.secondaryBackground,
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(
              color: borderColor,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: "Home".tr,
                index: 0,
                controller: mainBottomNavigationController,
                selectedBgColor: selectedBgColor,
              ),
              _NavItem(
                icon: Icons.local_offer_outlined,
                activeIcon: Icons.local_offer,
                label: "Advertizing".tr,
                index: 1,
                controller: mainBottomNavigationController,
                selectedBgColor: selectedBgColor,
              ),
              _NavItem(
                icon: Icons.article_outlined,
                activeIcon: Icons.article,
                label: "Posts".tr,
                index: 2,
                controller: mainBottomNavigationController,
                selectedBgColor: selectedBgColor,
              ),
              _NavItem(
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings,
                label: "Settings".tr,
                index: 3,
                controller: mainBottomNavigationController,
                selectedBgColor: selectedBgColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Extract nav item as separate widget for better performance
class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int index;
  final MainBottomNavigationController controller;
  final Color selectedBgColor;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.index,
    required this.controller,
    required this.selectedBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RepaintBoundary(
        child: Obx(() {
          final isSelected = controller.selectedPage.value == index;

          return GestureDetector(
            onTap: () => controller.changePage(index),
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isSelected ? 12.w : 8.w,
                vertical: 12.h,
              ),
              decoration: BoxDecoration(
                color: isSelected ? selectedBgColor : Colors.transparent,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isSelected ? activeIcon : icon,
                    size: 24.sp,
                    color: isSelected ? appTheme.primary : appTheme.secondaryText,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isSelected ? 12.sp : 11.sp,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? appTheme.primary : appTheme.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

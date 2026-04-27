import 'package:advertising_user/main.dart';
import 'package:advertising_user/uses_app_sb/features/store_detailes/view/widgets/offers_section.dart';
import 'package:advertising_user/uses_app_sb/features/store_detailes/view/widgets/ratingAndReviews.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/shared/models/user.dart';
import '../../../core/shared/widgets/dialogs/auth_required_dialog.dart';
import '../../../core/shared/widgets/empty_data/empty_data_widget.dart';
import '../../../core/shared/widgets/image/network_image.dart';
import '../../../core/shared/widgets/loaders/combined_loaders.dart';
import '../controller/store_detailes.dart';

class StoreDetailsPage extends StatefulWidget {
  const StoreDetailsPage({super.key});

  @override
  State<StoreDetailsPage> createState() => _StoreDetailsPageState();
}

class _StoreDetailsPageState extends State<StoreDetailsPage> {
  final StoreDetailesController storeDetailesController =
      Get.put(StoreDetailesController());

  // Cache color values to avoid repeated withOpacity() calls
  late final Color _gradientTopColor;
  late final Color _gradientBottomColor;
  late final Color _gradientOverlayColor;
  late final Color _borderWhiteColor;
  late final Color _contactBorderColor;
  late final Color _dividerColor;
  late final Color _offerIconBgColor;

  // Cache BorderRadius values
  late final BorderRadius _favoriteButtonRadius;
  late final BorderRadius _contactContainerRadius;
  late final BorderRadius _dialogRadius;
  late final BorderRadius _buttonRadius;

  @override
  void initState() {
    super.initState();
    _gradientTopColor = appTheme.primary.withOpacity(0.1);
    _gradientBottomColor = appTheme.primary.withOpacity(0.05);
    _gradientOverlayColor = appTheme.primaryBackground.withOpacity(0.7);
    _borderWhiteColor = Colors.white.withOpacity(0.3);
    _contactBorderColor = appTheme.primaryText.withOpacity(0.1);
    _dividerColor = appTheme.primaryText.withOpacity(0.1);
    _offerIconBgColor = const Color(0xFFFFB347).withOpacity(0.3);
    _favoriteButtonRadius = BorderRadius.circular(30);
    _contactContainerRadius = BorderRadius.circular(12.r);
    _dialogRadius = BorderRadius.circular(16.r);
    _buttonRadius = BorderRadius.circular(8.r);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.primaryBackground,
      body: Obx(
        () => storeDetailesController.isLoading.value
            ? Center(
                child: GlowingBoxLoader(message: 'Loading'),)
            : storeDetailesController.isError.value
                ? EmptyData(
                    icon: Icons.error_outline,
                    message:
                        'Error loading favorites. Please try again later.'.tr,
                    onTap: () {
                      storeDetailesController.getStoreDetailes();
                    },
                  )
                : storeDetailesController.store == null
                    ? Center(
                        child: Text('No data available'.tr),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            _StoreHeaderImage(
                              storeDetailesController: storeDetailesController,
                              gradientTopColor: _gradientTopColor,
                              gradientBottomColor: _gradientBottomColor,
                              gradientOverlayColor: _gradientOverlayColor,
                              borderWhiteColor: _borderWhiteColor,
                              favoriteButtonRadius: _favoriteButtonRadius,
                            ),

                            // Store Details Content
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6.w, vertical: 16.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Rating and Reviews
                                  RatingAndReviews(
                                    storeRate: storeDetailesController
                                        .store!.storeRate ?? 0,
                                  ),
                                  SizedBox(height: 24.h),

                                  // Store Description
                                  // Text(
                                  //     storeDetailesController.des,
                                  //     style: appTheme.text16.copyWith(
                                  //         color: appTheme.secondaryText)),
                                  // SizedBox(height: 16.h),

                                  // Subcategories Section
                                  if (storeDetailesController.store!.subCategories.isNotEmpty) ...[
                                    _SubcategoriesSection(
                                      storeDetailesController: storeDetailesController,
                                    ),
                                    SizedBox(height: 24.h),
                                  ],

                                  // Contact Section
                                  _ContactSection(
                                    storeDetailesController:
                                        storeDetailesController,
                                    contactContainerRadius:
                                        _contactContainerRadius,
                                    contactBorderColor: _contactBorderColor,
                                    dividerColor: _dividerColor,
                                    onPhoneTap: _launchPhone,
                                    onWhatsAppTap: _launchWhatsApp,
                                    onTelegramTap: _launchTelegram,
                                    onURLTap: _launchURL,
                                  ),
                                  SizedBox(height: 24.h),

                                  // Offers Section Header
                                  _OffersSectionHeader(
                                    offerIconBgColor: _offerIconBgColor,
                                  ),
                                  SizedBox(height: 16.h),

                                  // Offers List
                                  const OffersList(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
      ),
    );
  }

  void _showReportStoreDialog(BuildContext context) {
    Get.dialog(
      _ReportDialog(
        dialogRadius: _dialogRadius,
        buttonRadius: _buttonRadius,
      ),
      barrierDismissible: true,
    );
  }

  void _showBlockStoreDialog(BuildContext context) {
    Get.dialog(
      _BlockDialog(
        dialogRadius: _dialogRadius,
        buttonRadius: _buttonRadius,
        storeDetailesController: storeDetailesController,
      ),
      barrierDismissible: true,
    );
  }

  void _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      Get.snackbar(
        'Error'.tr,
        'Could not launch phone dialer'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: appTheme.error,
        colorText: Colors.white,
      );
    }
  }

  void _launchWhatsApp(String phoneNumber) async {
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final Uri whatsappUri = Uri.parse('https://wa.me/$cleanNumber');

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'Error'.tr,
        'Could not launch WhatsApp'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: appTheme.error,
        colorText: Colors.white,
      );
    }
  }

  void _launchTelegram(String phoneNumber) async {
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final Uri telegramUri = Uri.parse('https://t.me/$cleanNumber');

    if (await canLaunchUrl(telegramUri)) {
      await launchUrl(telegramUri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'Error'.tr,
        'Could not launch Telegram'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: appTheme.error,
        colorText: Colors.white,
      );
    }
  }

  void _launchURL(String url) async {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }

    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'Error'.tr,
        'Could not launch URL'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: appTheme.error,
        colorText: Colors.white,
      );
    }
  }
}

// Extract store header image as separate widget
class _StoreHeaderImage extends StatelessWidget {
  final StoreDetailesController storeDetailesController;
  final Color gradientTopColor;
  final Color gradientBottomColor;
  final Color gradientOverlayColor;
  final Color borderWhiteColor;
  final BorderRadius favoriteButtonRadius;

  const _StoreHeaderImage({
    required this.storeDetailesController,
    required this.gradientTopColor,
    required this.gradientBottomColor,
    required this.gradientOverlayColor,
    required this.borderWhiteColor,
    required this.favoriteButtonRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Store Image
        Container(
          width: double.infinity,
          height: 360.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                gradientTopColor,
                gradientBottomColor,
              ],
            ),
          ),
          child: getImageNetwork(
            url: storeDetailesController.store!.image ?? '',
            width: double.infinity,
            height: 360.h,
            fit: BoxFit.cover,
          ),
        ),

        // Gradient Overlay
        Container(
          width: double.infinity,
          height: 360.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
        ),

        // Back Button and Menu
        SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back Button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: appTheme.primaryText),
                    onPressed: () => Get.back(),
                  ),
                ),

                // Menu Button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: appTheme.primaryText),
                    onSelected: (value) {
                      if (value == 'report') {
                        Get.dialog(_ReportDialog(
                          dialogRadius: BorderRadius.circular(16.r),
                          buttonRadius: BorderRadius.circular(8.r),
                        ));
                      } else if (value == 'block') {
                        Get.dialog(_BlockDialog(
                          dialogRadius: BorderRadius.circular(16.r),
                          buttonRadius: BorderRadius.circular(8.r),
                          storeDetailesController: storeDetailesController,
                        ));
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem<String>(
                        value: 'report',
                        child: Row(
                          children: [
                            Icon(Icons.report_outlined, color: appTheme.primaryText),
                            SizedBox(width: 12.w),
                            Text('Report Store'.tr, style: appTheme.text14),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'block',
                        child: Row(
                          children: [
                            Icon(Icons.block_outlined, color: appTheme.error),
                            SizedBox(width: 12.w),
                            Text('Block Store'.tr,
                                style: appTheme.text14.copyWith(color: appTheme.error)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Store Info at Bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,

          child: Container(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Store Name

                Row(children: [
                  Text(
                    storeDetailesController.store!.storeName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // City if available
                  if (storeDetailesController.store!.city != null)
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.white.withOpacity(0.9),
                          size: 18.sp,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          storeDetailesController.store!.city!,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 3,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),



                ],)



              ],
            ),
          ),
        ),


        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back Button
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: appTheme.primaryText),
                onPressed: () => Get.back(),
              ),
            ),

            // Favorite & Menu Buttons
            Row(
              children: [
                // Favorite Button
                GetBuilder<StoreDetailesController>(
                  builder: (controller) {
                    return GestureDetector(
                      onTap: () async {
                        if (controller.isFavoriteLoading.value) return;
                        if (token.isEmpty) {
                          showAuthRequiredDialog();
                          return;
                        }
                        await controller.toggleStoreFavorite();
                      },
                      child: Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: controller.isFavoriteLoading.value
                            ? SizedBox(
                          width: 24.sp,
                          height: 24.sp,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(appTheme.primary),
                          ),
                        )
                            : Icon(
                          controller.store!.isFavourite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: controller.store!.isFavourite
                              ? appTheme.error
                              : appTheme.primaryText,
                          size: 24.sp,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(width: 12.w),

                // Menu Button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: appTheme.primaryText),
                    onSelected: (value) {
                      if (value == 'report') {
                        Get.dialog(_ReportDialog(
                          dialogRadius: BorderRadius.circular(16.r),
                          buttonRadius: BorderRadius.circular(8.r),
                        ));
                      } else if (value == 'block') {
                        Get.dialog(_BlockDialog(
                          dialogRadius: BorderRadius.circular(16.r),
                          buttonRadius: BorderRadius.circular(8.r),
                          storeDetailesController: storeDetailesController,
                        ));
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem<String>(
                        value: 'report',
                        child: Row(
                          children: [
                            Icon(Icons.report_outlined, color: appTheme.primaryText),
                            SizedBox(width: 12.w),
                            Text('Report Store'.tr, style: appTheme.text14),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'block',
                        child: Row(
                          children: [
                            Icon(Icons.block_outlined, color: appTheme.error),
                            SizedBox(width: 12.w),
                            Text('Block Store'.tr,
                                style: appTheme.text14.copyWith(color: appTheme.error)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),














      ],
    );
  }
}

// Extract contact section as separate widget
class _ContactSection extends StatelessWidget {
  final StoreDetailesController storeDetailesController;
  final BorderRadius contactContainerRadius;
  final Color contactBorderColor;
  final Color dividerColor;
  final Function(String) onPhoneTap;
  final Function(String) onWhatsAppTap;
  final Function(String) onTelegramTap;
  final Function(String) onURLTap;

  const _ContactSection({
    required this.storeDetailesController,
    required this.contactContainerRadius,
    required this.contactBorderColor,
    required this.dividerColor,
    required this.onPhoneTap,
    required this.onWhatsAppTap,
    required this.onTelegramTap,
    required this.onURLTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: appTheme.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.contact_phone_outlined,
                color: appTheme.primary,
                size: 22.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              'Contact Information'.tr,
              style: TextStyle(
                color: appTheme.primaryText,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // Contact Items
        Container(
          decoration: BoxDecoration(
            color: appTheme.secondaryBackground,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: appTheme.primaryText.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Store Number
              _ContactItem(
                title: 'Phone'.tr,
                subtitle: storeDetailesController.store!.storeNumber,
                icon: Icons.phone_outlined,
                color: appTheme.primary,
                onTap: () => onPhoneTap(storeDetailesController.store!.storeNumber),
              ),

              Divider(height: 1, color: dividerColor),

              // WhatsApp
              _ContactItem(
                title: 'WhatsApp'.tr,
                subtitle: storeDetailesController.store!.storeNumber,
                icon: Icons.chat_bubble_outline,
                color: const Color(0xFF25D366),
                onTap: () => onWhatsAppTap(
                  storeDetailesController.store!.storeNumber,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Individual Contact Item Widget
class _ContactItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ContactItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              // Icon Container
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 14.w),

              // Text Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: appTheme.secondaryText,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: appTheme.primaryText,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Arrow Icon
              Icon(
                Icons.arrow_forward_ios,
                color: color,
                size: 16.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Extract offers section header as separate widget
class _OffersSectionHeader extends StatelessWidget {
  final Color offerIconBgColor;

  const _OffersSectionHeader({required this.offerIconBgColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFFB347),
                Color(0xFFFF8C00),
              ],
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Icons.local_offer_rounded,
            color: Colors.white,
            size: 22.sp,
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          'Store offers'.tr,
          style: TextStyle(
            color: appTheme.primaryText,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// Extract report dialog as separate widget
class _ReportDialog extends StatelessWidget {
  final BorderRadius dialogRadius;
  final BorderRadius buttonRadius;

  const _ReportDialog({
    required this.dialogRadius,
    required this.buttonRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: dialogRadius),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: appTheme.primaryBackground,
          borderRadius: dialogRadius,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.report_outlined,
              size: 48.sp,
              color: appTheme.error,
            ),
            SizedBox(height: 16.h),
            Text(
              'Report Store'.tr,
              style: appTheme.text18.copyWith(
                fontWeight: FontWeight.bold,
                color: appTheme.primaryText,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'Are you sure you want to report this store?'.tr,
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
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: appTheme.primaryText,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      side: BorderSide(color: appTheme.secondaryText, width: 1),
                      shape: RoundedRectangleBorder(borderRadius: buttonRadius),
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
                    onPressed: () {
                      Get.back();
                      Get.snackbar(
                        'Success'.tr,
                        'Store has been reported'.tr,
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: appTheme.primary,
                        colorText: Colors.white,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appTheme.error,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(borderRadius: buttonRadius),
                    ),
                    child: Text(
                      'Report'.tr,
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

// Extract block dialog as separate widget
class _BlockDialog extends StatelessWidget {
  final BorderRadius dialogRadius;
  final BorderRadius buttonRadius;
  final StoreDetailesController storeDetailesController;

  const _BlockDialog({
    required this.dialogRadius,
    required this.buttonRadius,
    required this.storeDetailesController,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: dialogRadius),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: appTheme.primaryBackground,
          borderRadius: dialogRadius,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.block_outlined,
              size: 48.sp,
              color: appTheme.error,
            ),
            SizedBox(height: 16.h),
            Text(
              'Block Store'.tr,
              style: appTheme.text18.copyWith(
                fontWeight: FontWeight.bold,
                color: appTheme.primaryText,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'Are you sure you want to block this store? You will not see their content anymore.'
                  .tr,
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
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: appTheme.primaryText,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      side: BorderSide(color: appTheme.secondaryText, width: 1),
                      shape: RoundedRectangleBorder(borderRadius: buttonRadius),
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

                      if (token.isEmpty) {
                        showAuthRequiredDialog();
                        return;
                      }

                      final result =
                          await storeDetailesController.blockStore();

                      if (result['success']) {
                        Get.snackbar(
                          'Success'.tr,
                          result['message'],
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: appTheme.primary,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 3),
                        );
                        Future.delayed(const Duration(seconds: 1), () {
                          Get.back();
                        });
                      } else {
                        Get.snackbar(
                          'Error'.tr,
                          result['message'],
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: appTheme.error,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 3),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appTheme.error,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(borderRadius: buttonRadius),
                    ),
                    child: Text(
                      'Block'.tr,
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

// Subcategories Section Widget
class _SubcategoriesSection extends StatelessWidget {
  final StoreDetailesController storeDetailesController;

  const _SubcategoriesSection({
    required this.storeDetailesController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    appTheme.primary.withOpacity(0.8),
                    appTheme.primary,
                  ],
                ),
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: appTheme.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.category_rounded,
                color: Colors.white,
                size: 22.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              'Categories'.tr,
              style: TextStyle(
                color: appTheme.primaryText,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // Subcategories Chips
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: storeDetailesController.store!.subCategories.map((subCategory) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    appTheme.primary.withOpacity(0.15),
                    appTheme.primary.withOpacity(0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: appTheme.primary.withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: appTheme.primary.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: appTheme.primary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.label,
                      color: appTheme.primary,
                      size: 16.sp,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    subCategory.name,
                    style: TextStyle(
                      color: appTheme.primaryText,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class ContactWidget extends StatelessWidget {
  const ContactWidget({
    super.key,
    required this.title,
    required this.subTitle,
    this.icon,
    this.onTap,
    this.color,
  });

  final String title;
  final String subTitle;
  final IconData? icon;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final displayColor = color ?? appTheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 20.sp,
              color: displayColor,
            ),
            SizedBox(width: 12.w),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: appTheme.text12.copyWith(
                    color: appTheme.secondaryText,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subTitle,
                  style: appTheme.text14.copyWith(
                    color: appTheme.primaryText,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          if (onTap != null)
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14.sp,
              color: displayColor,
            ),
        ],
      ),
    );
  }
}

import 'package:advertising_user/uses_app_sb/core/shared/widgets/image/network_image.dart';
import 'package:advertising_user/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../controlller/show_adertize_full_data_controller.dart';
import '../../model/advertise_model.dart';
import 'rate_advertise_dialog.dart';

class ShowAdvertiseFullDataScreen extends StatefulWidget {
  final Advertise advertise;
  final bool showStoreDisabled;
  ShowAdvertiseFullDataScreen(
      {super.key, required this.advertise, this.showStoreDisabled = false});

  @override
  State<ShowAdvertiseFullDataScreen> createState() =>
      _ShowAdvertiseFullDataScreenState();
}

class _ShowAdvertiseFullDataScreenState
    extends State<ShowAdvertiseFullDataScreen> {
  final ShowAdertizeFullDataController showAdertizeFullDataController =
      Get.put(ShowAdertizeFullDataController());

  final PageController _pageController = PageController();
  final RxInt _currentImageIndex = 0.obs;

  @override
  void initState() {
    showAdertizeFullDataController.getStoreForAdvertise(widget.advertise.id);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    Get.delete<ShowAdertizeFullDataController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 40.h),
      child: Container(
        constraints: BoxConstraints(maxHeight: 0.85.sh),
        decoration: BoxDecoration(
          color: appTheme.primaryBackground,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: appTheme.primaryText.withOpacity(0.15),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image Carousel Section
            _buildImageCarousel(),

            // Content Section (Scrollable)
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      widget.advertise.title,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: appTheme.primaryText,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Price Tag
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: appTheme.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.attach_money,
                            color: appTheme.primary,
                            size: 18.sp,
                          ),
                          Text(
                            '\$${widget.advertise.price}',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: appTheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Description
                    Text(
                      widget.advertise.description,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: appTheme.secondaryText,
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Info Card - Posted Date
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: appTheme.secondaryBackground,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: appTheme.primaryText.withOpacity(0.08),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              color: appTheme.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              Icons.calendar_today_rounded,
                              color: appTheme.primary,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: 14.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Posted Date'.tr,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: appTheme.secondaryText,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                _formatDate(widget.advertise.createdAt),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: appTheme.primaryText,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Notes Section (if available)
                    if (widget.advertise.notes != null && widget.advertise.notes!.isNotEmpty) ...[
                      SizedBox(height: 16.h),
                      _buildNotesSection(widget.advertise.notes!),
                    ],

                    // Store Section
                    if (!widget.showStoreDisabled) ...[
                      SizedBox(height: 24.h),
                      _buildStoreSectionHeader(),
                      SizedBox(height: 12.h),
                      Obx(() {
                        if (showAdertizeFullDataController.isLoading.value) {
                          return _buildShimmerStoreCard();
                        } else if (showAdertizeFullDataController.owner != null) {
                          return _buildStoreCard();
                        }
                        return const SizedBox.shrink();
                      }),
                    ],

                    SizedBox(height: 24.h),

                    // Action Buttons
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Image Carousel with dots indicator
  Widget _buildImageCarousel() {
    return Stack(
      children: [
        // Images
        Container(
          height: 320.h,
          decoration: BoxDecoration(
            color: appTheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          child: widget.advertise.images.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_outlined,
                        size: 80.sp,
                        color: appTheme.secondaryText,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'No Image Available'.tr,
                        style: TextStyle(
                          color: appTheme.secondaryText,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.r),
                    topRight: Radius.circular(24.r),
                  ),
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      _currentImageIndex.value = index;
                    },
                    itemCount: widget.advertise.images.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          _showImageFullscreen(context, widget.advertise.images[index].url);
                        },
                        child: getImageNetwork(
                          url: widget.advertise.images[index].url,
                          width: double.infinity,
                          height: 320.h,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
        ),

        // Close Button
        Positioned(
          top: 16.h,
          right: 16.w,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.close_rounded,
                color: appTheme.primaryText,
                size: 22.sp,
              ),
            ),
          ),
        ),

        // Dots Indicator
        if (widget.advertise.images.length > 1)
          Positioned(
            bottom: 16.h,
            left: 0,
            right: 0,
            child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.advertise.images.length,
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  width: _currentImageIndex.value == index ? 28.w : 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: _currentImageIndex.value == index
                        ? appTheme.primary
                        : Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(4.r),
                    boxShadow: _currentImageIndex.value == index
                        ? [
                            BoxShadow(
                              color: appTheme.primary.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                ),
              ),
            )),
          ),
      ],
    );
  }

  // Info Card Widget
  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Gradient gradient,
  }) {
    return Container(

      padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 6.h),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 18.sp,
                color: Colors.white,
              ),
              SizedBox(width: 6.w),
              Text(
                label,
                style: appTheme.text12.copyWith(
                  color: Colors.white.withOpacity(0.95),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: appTheme.text14.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Notes Section
  Widget _buildNotesSection(String notes) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: appTheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: appTheme.primary.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: appTheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.info_outline_rounded,
                  size: 18.sp,
                  color: appTheme.primary,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'Additional Notes'.tr,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: appTheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Text(
            notes,
            style: TextStyle(
              fontSize: 14.sp,
              color: appTheme.primaryText,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  // Store Section Header
  Widget _buildStoreSectionHeader() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: appTheme.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Icons.storefront_rounded,
            size: 20.sp,
            color: appTheme.primary,
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          'About the Store'.tr,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: appTheme.primaryText,
          ),
        ),
      ],
    );
  }

  // Store Card
  Widget _buildStoreCard() {
    if (showAdertizeFullDataController.owner == null) {
      return const SizedBox.shrink();
    }

    final store = showAdertizeFullDataController.owner!.store;

    return GestureDetector(
      onTap: () {
        Get.toNamed('/StoreDetailsPage', arguments: store.id);
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: appTheme.secondaryBackground,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: appTheme.primaryText.withOpacity(0.08),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: appTheme.primaryText.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Store Image
            Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                color: appTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: appTheme.primary.withOpacity(0.15),
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: store.image != null && store.image!.isNotEmpty
                    ? getImageNetwork(
                        url: store.image!,
                        width: 72.w,
                        height: 72.w,
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.store_rounded,
                        size: 36.sp,
                        color: appTheme.primary,
                      ),
              ),
            ),
            SizedBox(width: 16.w),

            // Store Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.storeName,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: appTheme.primaryText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        size: 14.sp,
                        color: appTheme.secondaryText,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        store.storeNumber,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: appTheme.secondaryText,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Arrow Icon
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: appTheme.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16.sp,
                color: appTheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Shimmer Store Card
  Widget _buildShimmerStoreCard() {
    return Shimmer.fromColors(
      baseColor: appTheme.secondaryText.withOpacity(0.3),
      highlightColor: appTheme.secondaryText.withOpacity(0.1),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: appTheme.secondaryBackground,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Container(
              width: 70.w,
              height: 70.w,
              decoration: BoxDecoration(
                color: appTheme.secondaryBackground,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 150.w,
                    height: 16.h,
                    color: appTheme.secondaryBackground,
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: 100.w,
                    height: 12.h,
                    color: appTheme.secondaryBackground,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Action Buttons
  Widget _buildActionButtons() {
    return Column(
      children: [
        // View Store Button (if store available)
        if (!widget.showStoreDisabled)
          Obx(() {
            final isLoading = showAdertizeFullDataController.isLoading.value;
            final hasOwner = showAdertizeFullDataController.owner != null;

            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: hasOwner && !isLoading
                    ? LinearGradient(
                        colors: [
                          appTheme.primary,
                          appTheme.primary.withOpacity(0.85),
                        ],
                      )
                    : LinearGradient(
                        colors: [
                          appTheme.secondaryText.withOpacity(0.3),
                          appTheme.secondaryText.withOpacity(0.2),
                        ],
                      ),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: hasOwner && !isLoading
                    ? [
                        BoxShadow(
                          color: appTheme.primary.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: ElevatedButton(
                onPressed: hasOwner && !isLoading
                    ? () {
                        Get.toNamed('/StoreDetailsPage',
                            arguments: showAdertizeFullDataController.owner!.store.id);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  disabledBackgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                ),
                child: isLoading
                    ? SizedBox(
                        height: 22.h,
                        width: 22.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.store_rounded,
                            color: Colors.white,
                            size: 22.sp,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            'Visit Store'.tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
              ),
            );
          }),

        if (!widget.showStoreDisabled) SizedBox(height: 14.h),

        // Rate Button
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: appTheme.secondaryBackground,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: appTheme.primary,
              width: 2,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Get.dialog(
                  RateAdvertiseDialog(advertiseId: widget.advertise.id),
                );
              },
              borderRadius: BorderRadius.circular(14.r),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star_rate_rounded,
                      color: appTheme.primary,
                      size: 24.sp,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'Rate this Offer'.tr,
                      style: TextStyle(
                        color: appTheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  void _showImageFullscreen(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImage(imageUrl: imageUrl),
      ),
    );
  }
}

// Full-screen image widget
class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              child: getImageNetworkforCahing(
                width: null,
                height: null,
                url: imageUrl,
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

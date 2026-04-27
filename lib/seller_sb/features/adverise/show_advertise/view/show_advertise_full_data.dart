import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // ScreenUtil for responsive layout
import 'package:get/get.dart';
 import 'package:advertising_user/seller_sb/features/adverise/show_advertise/controller/adverize_controller.dart';
import 'package:advertising_user/seller_sb/features/adverise/show_advertise/model/advertise_model.dart';
 import 'package:advertising_user/main.dart';

import '../../../../../uses_app_sb/core/shared/widgets/image/network_image.dart';

class ShowAdvertiseFullDataScreen extends StatefulWidget {
  final Advertise advertise;

  const ShowAdvertiseFullDataScreen({
    super.key,
    required this.advertise,
  });

  @override
  State<ShowAdvertiseFullDataScreen> createState() =>
      _ShowAdvertiseFullDataScreenState();
}

class _ShowAdvertiseFullDataScreenState
    extends State<ShowAdvertiseFullDataScreen> {
  // Cache BorderRadius values
  late final BorderRadius _dialogRadius;
  late final BorderRadius _imageRadius;

  // Cache dialog shape
  late final RoundedRectangleBorder _dialogShape;

  @override
  void initState() {
    super.initState();
    _dialogRadius = BorderRadius.circular(12.r);
    _imageRadius = BorderRadius.circular(8.r);
    _dialogShape = RoundedRectangleBorder(borderRadius: _dialogRadius);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: appTheme.primaryBackground,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      shape: _dialogShape,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight:
                0.9.sh), // Ensure content fits within 90% of the screen height
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Close button
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.close,
                        size: 24.w, color: appTheme.primaryText),
                  ),
                ),

                // Image layout with Wrap widget for dynamic images
                _buildWrapImageList(context),

                SizedBox(height: 16.h),

                // Title
                Text(
                  widget.advertise.title,
                  style: appTheme.text18.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),

                // Description
                Text(
                  widget.advertise.description,
                  style:
                      appTheme.text14.copyWith(color: appTheme.secondaryText),
                  maxLines: 5, // Limit to 5 lines
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 16.h),

                // Notes
                if (widget.advertise.notes != null)
                  _InfoRow(label: "Notes:", content: widget.advertise.notes!),
                SizedBox(height: 8.h),

                // Price
                _InfoRow(label: "Price:", content: "\$${widget.advertise.price}"),
                SizedBox(height: 16.h),

                // Created and Updated At
                _InfoRow(
                    label: "Created At:",
                    content: _formatDate(widget.advertise.createdAt)),
                SizedBox(height: 8.h),
                // Delete Button
                _DeleteButton(onPressed: () => _showDeleteConfirmationDialog(context)),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Show confirmation dialog for delete action
  void _showDeleteConfirmationDialog(BuildContext context) {
    Get.defaultDialog(
      title: "Delete Ad",
      middleText: "Are you sure you want to delete this advertisement?",
      textConfirm: "Delete",
      confirmTextColor: Colors.white,
      textCancel: "Cancel",
      onConfirm: () async {
        // Call delete method in the controller
        await Get.find<AdverizeController>().deleteAds(widget.advertise.id);
        Get.back();
      },
      onCancel: () {
        Navigator.of(context).pop(); // Just close the dialog
      },
    );
  }

  // Method to display images using Wrap
  Widget _buildWrapImageList(BuildContext context) {
    return Wrap(
      spacing: 5.w,
      runSpacing: 5.h,
      children: widget.advertise.images
          .map((image) => _ImageThumbnail(
                imageUrl: image.url,
                imageRadius: _imageRadius,
                onTap: () {
                  // _showImageFullscreen(context, image.url);
                },
              ))
          .toList(),
    );
  }

  // Helper method to format the date
  String _formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year}";
  }
}

// Extracted image thumbnail widget
class _ImageThumbnail extends StatelessWidget {
  final String imageUrl;
  final BorderRadius imageRadius;
  final VoidCallback onTap;

  const _ImageThumbnail({
    required this.imageUrl,
    required this.imageRadius,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: imageRadius,
        child: getImageNetwork(
          url: imageUrl,
          width: 100.w,
          height: 100.h,
        ),
      ),
    );
  }
}

// Extracted info row widget
class _InfoRow extends StatelessWidget {
  final String label;
  final String content;

  const _InfoRow({
    required this.label,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label ",
          style: appTheme.text14.copyWith(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(
            content,
            style: appTheme.text14,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// Extracted delete button widget
class _DeleteButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _DeleteButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: appTheme.error, // Red delete button
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
        ),
        onPressed: onPressed,
        child: Text(
          'Delete Ad',
          style: appTheme.text16.copyWith(color: Colors.white),
        ),
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
      backgroundColor: appTheme.primaryBackground,
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Center(
          child: Hero(
            tag: imageUrl,
            child: getImageNetworkforCahing(
              width: null,
              height: null,
              url: imageUrl,
            ),
          ),
        ),
      ),
    );
  }
}

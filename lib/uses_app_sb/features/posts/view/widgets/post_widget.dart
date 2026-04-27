import 'package:advertising_user/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/shared/functions/helper/date_formatter.dart';
import '../../../../core/shared/models/post_model.dart';
import '../../../../core/shared/widgets/image/full_screen_imge_viewer.dart';
import '../../../../core/shared/widgets/image/network_image.dart';
import '../../controller/posts_controller.dart';

class PostWidget extends StatefulWidget {
  final PostModel post;
  final int index;

  const PostWidget({super.key, required this.post, required this.index});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  late final PageController _pageController;
  late final PostsController controller;

  // Cache color values to avoid repeated withOpacity() calls
  late final Color _borderColor;
  late final Color _dotColor;

  // Cache BorderRadius values
  late final BorderRadius _containerRadius;
  late final BorderRadius _imageRadius;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    controller = Get.find<PostsController>();
    _borderColor = appTheme.primaryText.withOpacity(0.1);
    _dotColor = appTheme.secondaryText.withOpacity(0.3);
    _containerRadius = BorderRadius.circular(12.r);
    _imageRadius = BorderRadius.circular(8.r);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
            child: _PostHeader(post: widget.post),
          ),

          // Post Content/Description
          if (widget.post.content.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                widget.post.content,
                style: TextStyle(
                  color: appTheme.primaryText,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ),

          // Image Carousel
          if (widget.post.images.isNotEmpty) ...[
            SizedBox(height: 12.h),
            _ImageCarousel(
              post: widget.post,
              index: widget.index,
              pageController: _pageController,
              imageRadius: BorderRadius.circular(16.r),
            ),
            if (widget.post.images.length > 1) ...[
              SizedBox(height: 12.h),
              Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: widget.post.images.length,
                  effect: WormEffect(
                    dotHeight: 8.h,
                    dotWidth: 8.w,
                    spacing: 6.w,
                    activeDotColor: appTheme.primary,
                    dotColor: _dotColor,
                  ),
                ),
              ),
            ],
          ],

          // Divider
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Divider(
              height: 1,
              color: appTheme.primaryText.withOpacity(0.08),
            ),
          ),

          // Action Buttons (Like/Dislike)
          Padding(
            padding: EdgeInsets.fromLTRB(8.w, 0, 8.w, 12.h),
            child: _ActionButtons(
              post: widget.post,
              index: widget.index,
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }
}

// Extract post header as separate widget for better performance
class _PostHeader extends StatelessWidget {
  final PostModel post;

  const _PostHeader({required this.post});

  @override
  Widget build(BuildContext context) {
    // Only show header if trader and store info exists
    if (post.trader?.store == null) {
      return const SizedBox.shrink();
    }

    final store = post.trader!.store!;

    return GestureDetector(
      onTap: () {
        if (post.trader?.id != null) {
          Get.toNamed('/StoreDetailsPage', arguments: post.trader!.id);
        }
      },
      child: Row(
        children: [
          // Store Avatar with border
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: appTheme.primary.withOpacity(0.15),
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 22.r,
              backgroundColor: appTheme.primary.withOpacity(0.1),
              backgroundImage: store.image != null
                  ? getImageNetworkImageProvider(
                      url: store.image!,
                      width: null,
                      height: null,
                    )
                  : null,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  store.storeName,
                  style: TextStyle(
                    color: appTheme.primaryText,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 12.sp,
                      color: appTheme.secondaryText,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      DateFormatter.formatPostTimeAgo(post.createdAt),
                      style: TextStyle(
                        color: appTheme.secondaryText,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Store icon button
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: appTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.store_outlined,
              size: 18.sp,
              color: appTheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// Extract image carousel as separate widget
class _ImageCarousel extends StatelessWidget {
  final PostModel post;
  final int index;
  final PageController pageController;
  final BorderRadius imageRadius;

  const _ImageCarousel({
    required this.post,
    required this.index,
    required this.pageController,
    required this.imageRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      height: 280.h,
      child: PageView.builder(
        controller: pageController,
        itemCount: post.images.length,
        itemBuilder: (context, imageIndex) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FullScreenImageViewer(
                    imageUrls: post.images,
                    initialIndex: imageIndex,
                  ),
                ),
              );
            },
            child: Hero(
              tag: 'image_${index}_$imageIndex',
              child: ClipRRect(
                borderRadius: imageRadius,
                child: getImageNetwork(
                  url: post.images[imageIndex],
                  height: 280.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Extract action buttons as separate widget with Obx for granular updates
class _ActionButtons extends StatelessWidget {
  final PostModel post;
  final int index;
  final PostsController controller;

  const _ActionButtons({
    required this.post,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Access the post from the controller's observable list
      final PostModel currentPost = controller.posts.length > index
          ? controller.posts[index]
          : post;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Like Button
          Expanded(
            child: _ActionButton(
              icon: currentPost.isLiked
                  ? Icons.thumb_up_alt
                  : Icons.thumb_up_alt_outlined,
              label: '${currentPost.likesCount}',
              isActive: currentPost.isLiked,
              activeColor: appTheme.primary,
              onTap: () {
                controller.likePost(currentPost.id);
              },
            ),
          ),

          SizedBox(width: 8.w),

          // View Store Button
          Expanded(
            child: _ActionButton(
              icon: Icons.store_outlined,
              label: 'Store'.tr,
              isActive: false,
              activeColor: appTheme.primary,
              onTap: () {
                if (currentPost.trader?.id != null) {
                  Get.toNamed('/StoreDetailsPage', arguments: currentPost.trader!.id);
                }
              },
            ),
          ),

          SizedBox(width: 8.w),

          // Dislike Button
          Expanded(
            child: _ActionButton(
              icon: currentPost.isDisliked
                  ? Icons.thumb_down_alt
                  : Icons.thumb_down_alt_outlined,
              label: '${currentPost.dislikesCount}',
              isActive: currentPost.isDisliked,
              activeColor: appTheme.error,
              onTap: () {
                controller.dislikePost(currentPost.id);
              },
            ),
          ),
        ],
      );
    });
  }
}

// Individual action button widget with animation
class _ActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() async {
    // Play animation
    await _animationController.forward();
    await _animationController.reverse();

    // Execute the callback
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
          decoration: BoxDecoration(
            color: widget.isActive
                ? widget.activeColor.withOpacity(0.12)
                : appTheme.primaryText.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: Icon(
                  widget.icon,
                  key: ValueKey(widget.icon),
                  size: 20.sp,
                  color: widget.isActive
                      ? widget.activeColor
                      : appTheme.secondaryText,
                ),
              ),
              SizedBox(width: 6.w),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight:
                      widget.isActive ? FontWeight.w600 : FontWeight.w500,
                  color: widget.isActive
                      ? widget.activeColor
                      : appTheme.secondaryText,
                ),
                child: Text(widget.label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

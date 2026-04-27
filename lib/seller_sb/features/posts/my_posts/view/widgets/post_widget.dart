import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
  import 'package:advertising_user/seller_sb/main.dart';
import 'package:advertising_user/seller_sb/features/posts/my_posts/model/post_model.dart';
import 'package:advertising_user/seller_sb/features/posts/my_posts/controller/posts_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:advertising_user/main.dart';

import '../../../../../../uses_app_sb/core/shared/functions/helper/date_formatter.dart';
import '../../../../../../uses_app_sb/core/shared/widgets/image/full_screen_imge_viewer.dart';
import '../../../../../../uses_app_sb/core/shared/widgets/image/network_image.dart';
class PostWidget extends StatelessWidget {
  final Post post;
  final int index;
  final PostsController controller = Get.find();
  final PageController _pageController = PageController();

  PostWidget({super.key, required this.post, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: appTheme.secondaryBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: appTheme.primaryText.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Get.toNamed('/StoreDetailsPage');
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20.r,
                    backgroundImage: getImageNetworkImageProvider(
                      url: controller.getOwner().store.image ?? "",
                      width: null,
                      height: null,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(controller.getOwner().store.storeName,
                            style: appTheme.text14
                                .copyWith(fontWeight: FontWeight.bold)),
                        Text(DateFormatter.formatPostTimeAgo(post.updatedAt),
                            style:
                                appTheme.text12.copyWith(color: appTheme.secondaryText)),
                        SizedBox(height: 4.h),
                        Text(post.title, style: appTheme.text14),
                      ],
                    ),
                  ),
                  // Add PopupMenuButton for options (Edit, Delete)
                  PopupMenuButton<String>(
                    color: appTheme.primaryBackground,
                    onSelected: (String value) {
                      if (value == 'Delete') {
                        // Trigger delete logic here
                        controller.deletePost(post.id);
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                          value: 'Delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: appTheme.error),
                              const SizedBox(width: 8),
                              Text('Delete Post'.tr),
                            ],
                          ),
                        ),
                      ];
                    },
                    icon: const Icon(Icons.more_horiz_outlined),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            if (post.imageUrls.isNotEmpty) ...[
              SizedBox(
                height: 250.h,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: post.imageUrls.length,
                  itemBuilder: (context, imageIndex) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FullScreenImageViewer(
                              imageUrls:
                                  post.imageUrls.map((e) => e.url).toList(),
                              initialIndex: imageIndex,
                            ),
                          ),
                        );
                      },
                      child: Hero(
                        tag: 'image_${index}_$imageIndex',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0.r),
                          child: getImageNetwork(
                            url: post.imageUrls[imageIndex].url,
                            height: 250.h,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (post.imageUrls.length > 1) ...[
                SizedBox(height: 8.h),
                Center(
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: post.imageUrls.length,
                    effect: WormEffect(
                      dotHeight: 8.h,
                      dotWidth: 8.w,
                      activeDotColor: appTheme.primary,
                      dotColor: appTheme.secondaryText.withOpacity(0.3),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
              ],
            ],
            GetBuilder<PostsController>(builder: (context) {
              return Row(
                children: [
                  IconButton(
                    icon: Icon(
                      post.isLiked
                          ? Icons.thumb_up_alt
                          : Icons.thumb_up_alt_outlined,
                      color: post.isLiked ? appTheme.primary : appTheme.secondaryText,
                    ),
                    iconSize: 24.r,
                    onPressed: () {
                      controller.likeOrDislikePost(post.id, index, true);
                    },
                  ),
                  Text(
                    '${post.likesCount}',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      post.isDisliked
                          ? Icons.thumb_down_alt
                          : Icons.thumb_down_alt_outlined,
                      color: post.isDisliked ? appTheme.error : appTheme.secondaryText,
                    ),
                    iconSize: 24.r,
                    onPressed: () {
                      controller.likeOrDislikePost(post.id, index, false);
                    },
                  ),
                  Text(
                    '${post.disLikesCount}',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

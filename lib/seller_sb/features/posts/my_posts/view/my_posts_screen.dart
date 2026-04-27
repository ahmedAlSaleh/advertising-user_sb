import 'package:advertising_user/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
  import 'package:advertising_user/seller_sb/features/posts/my_posts/view/widgets/post_widget.dart';
import 'package:advertising_user/seller_sb/main.dart';
import 'package:advertising_user/seller_sb/features/posts/my_posts/controller/posts_controller.dart';

import '../../../../../uses_app_sb/core/shared/widgets/app_bar/general_app_bar.dart';
import '../../../../../uses_app_sb/core/shared/widgets/empty_data/empty_data_widget.dart';
import '../../../../../uses_app_sb/core/shared/widgets/loaders/combined_loaders.dart';

class MyPostsScreen extends StatelessWidget {
  const MyPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PostsController controller = Get.put(PostsController());

    return Scaffold(
        backgroundColor: appTheme.primaryBackground,
        appBar: generalAppBar(
            context: context,
            title: Text("My post".tr,
                style: appTheme.text18.copyWith(fontWeight: FontWeight.bold)),
            actions: [
              IconButton(
                  onPressed: () {
                    Get.toNamed('/AddPostScreen');
                  },
                  icon: Icon(
                    Icons.library_add_outlined,
                    color: appTheme.primaryText,
                    size: 24.sp,
                  ))
            ]),
        body: Obx(() {
          return controller.isLoading.value
              ? Center(
                  child: GlowingBoxLoader(message: 'Loading'.tr),
                )
              : controller.isError.value
                  ? EmptyData(
                      icon: Icons.error_outline_outlined,
                      message: "SomeThing Wrong!!",
                    )
                  : controller.itemList.isEmpty
                      ? EmptyData(
                          onTap: () {
                            controller.refreshData();
                          },
                          icon: Icons.error_outline_outlined,
                          message: "No Posts Aviable".tr,
                        )
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            return ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight,
                                ),
                                child: RefreshIndicator(
                                  onRefresh: () async {
                                    await controller.refreshData();
                                  },
                                  child: ListView.builder(
                                    controller: controller.scrollController,
                                    itemBuilder: (context, index) {
                                      return index < controller.itemList.length
                                          ? PostWidget(
                                              post: controller.itemList[index],
                                              index: index,
                                            )
                                          : const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child:GlowingBoxLoader(message: 'Loading'),);
                                    },
                                    itemCount: controller.hasMoreData.value
                                        ? controller.itemList.length + 1
                                        : controller.itemList.length,
                                  ),
                                ));
                          },
                        );
        }));
  }
}

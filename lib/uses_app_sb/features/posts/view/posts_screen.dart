import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/posts_controller.dart';
import 'widgets/post_card.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PostsController controller = Get.put(PostsController());

    return Scaffold(
      appBar: AppBar(
        title: Text('المنشورات'.tr),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refreshPosts(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoadingPosts.value && controller.posts.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.posts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.article_outlined, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text('لا توجد منشورات', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.refreshPosts(),
          child: ListView.builder(
            itemCount: controller.posts.length + (controller.isLoadingMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.posts.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final post = controller.posts[index];
              
              // Load more when reaching 80% of list
              if (index == (controller.posts.length * 0.8).floor() && controller.hasMorePages) {
                controller.loadMorePosts();
              }

              return PostCard(
                post: post,
                onLike: () => controller.likePost(post.id),
                onDislike: () => controller.dislikePost(post.id),
              );
            },
          ),
        );
      }),
    );
  }
}

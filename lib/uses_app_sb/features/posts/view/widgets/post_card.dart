import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../main.dart';
import '../../../../core/shared/models/post_model.dart';
import '../../../reports/view/widgets/report_dialog.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback? onLike;
  final VoidCallback? onDislike;
  final VoidCallback? onDelete;
  final bool showDeleteButton;

  const PostCard({
    super.key,
    required this.post,
    this.onLike,
    this.onDislike,
    this.onDelete,
    this.showDeleteButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with store info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: appTheme.primary.withValues(alpha: 0.1),
                  child: Icon(Icons.store, color: appTheme.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.storeName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(_formatDate(post.createdAt), style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                ),
                // Report button (if not showing delete button)
                if (!showDeleteButton)
                  IconButton(
                    icon: Icon(Icons.flag_outlined, color: Colors.grey[600]),
                    onPressed: () => _showReportDialog(context),
                  ),
                // Delete button (if showing delete button)
                if (showDeleteButton && onDelete != null)
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: appTheme.error),
                    onPressed: onDelete,
                  ),
              ],
            ),
          ),

          // Content
          Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text(post.content)),

          // Images (if any)
          if (post.images.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: post.images.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(post.images[index], width: 120, height: 120, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
            ),

          // Like/Dislike buttons
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                if (onLike != null)
                  InkWell(
                    onTap: onLike,
                    child: Row(
                      children: [
                        Icon(post.isLiked ? Icons.thumb_up : Icons.thumb_up_outlined, size: 20, color: post.isLiked ? appTheme.primary : Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(post.likesCount.toString()),
                      ],
                    ),
                  ),
                const SizedBox(width: 16),
                if (onDislike != null)
                  InkWell(
                    onTap: onDislike,
                    child: Row(
                      children: [
                        Icon(post.isDisliked ? Icons.thumb_down : Icons.thumb_down_outlined, size: 20, color: post.isDisliked ? appTheme.error : Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(post.dislikesCount.toString()),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays == 0) return 'اليوم';
    if (diff.inDays == 1) return 'أمس';
    if (diff.inDays < 7) return 'منذ ${diff.inDays} أيام';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  void _showReportDialog(BuildContext context) {
    Get.dialog(
      ReportDialog(
        reportableType: 'post',
        reportableId: post.id,
        itemTitle: post.content.length > 50
            ? '${post.content.substring(0, 50)}...'
            : post.content,
      ),
    );
  }
}

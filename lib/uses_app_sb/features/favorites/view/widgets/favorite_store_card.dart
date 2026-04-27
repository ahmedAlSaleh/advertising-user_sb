import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../main.dart';
import '../../../../core/shared/models/store_model.dart';

class FavoriteStoreCard extends StatelessWidget {
  final StoreModel store;
  final VoidCallback onRemove;

  const FavoriteStoreCard({
    super.key,
    required this.store,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigate to store details
          // Get.to(() => StoreDetailsScreen(storeId: store.id));
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Store Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: store.image != null
                    ? Image.network(
                        store.image!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholder();
                        },
                      )
                    : _buildPlaceholder(),
              ),
              const SizedBox(width: 12),

              // Store Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Store Name
                    Text(
                      store.storeName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Owner Name
                    Text(
                      store.storeOwnerName,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Stats Row
                    Row(
                      children: [
                        // Rating
                        Icon(
                          Icons.star,
                          size: 16,
                          color: appTheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          store.averageRating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Ads Count
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${store.advertisementsCount}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Posts Count
                        Icon(
                          Icons.article_outlined,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${store.postsCount}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Remove Button
              IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: appTheme.error,
                ),
                onPressed: onRemove,
                tooltip: 'إزالة من المفضلة'.tr,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.store,
        size: 40,
        color: Colors.grey[400],
      ),
    );
  }
}

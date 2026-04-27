import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../main.dart';
import '../../../../../uses_app_sb/core/shared/models/advertisement_model.dart';

class TraderAdCard extends StatelessWidget {
  final AdvertisementModel advertisement;
  final VoidCallback? onToggleStatus;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onRenew;
  final VoidCallback? onPromote;
  final bool showScheduleInfo;
  final bool showExpiredInfo;

  const TraderAdCard({
    super.key,
    required this.advertisement,
    this.onToggleStatus,
    this.onDelete,
    this.onEdit,
    this.onRenew,
    this.onPromote,
    this.showScheduleInfo = false,
    this.showExpiredInfo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Main content
          InkWell(
            onTap: onEdit,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  _buildImage(),
                  const SizedBox(width: 12),

                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title with badges
                        _buildTitleRow(),
                        const SizedBox(height: 8),

                        // Price
                        Text(
                          '${_formatPrice(advertisement.price)} د.ع',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: appTheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Stats row
                        _buildStatsRow(),

                        // Schedule info (if applicable)
                        if (showScheduleInfo && advertisement.scheduledFor != null)
                          _buildScheduleInfo(),

                        // Expired info (if applicable)
                        if (showExpiredInfo && advertisement.expiresAt != null)
                          _buildExpiredInfo(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Divider(height: 1),

          // Action buttons
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 80,
        height: 80,
        child: advertisement.images.isNotEmpty
            ? Image.network(
                advertisement.images.first,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholder();
                },
              )
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Icon(
        Icons.image_not_supported,
        color: Colors.grey[400],
        size: 32,
      ),
    );
  }

  Widget _buildTitleRow() {
    return Row(
      children: [
        Expanded(
          child: Text(
            advertisement.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        // Promoted badge
        if (advertisement.isPromoted)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            margin: const EdgeInsets.only(left: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple[400]!, Colors.purple[700]!],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.campaign,
                  size: 12,
                  color: Colors.white,
                ),
                const SizedBox(width: 4),
                Text(
                  'مروّج',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        // Status badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: advertisement.isActive
                ? Colors.green.withValues(alpha: 0.1)
                : Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: advertisement.isActive ? Colors.green : Colors.grey,
              width: 1,
            ),
          ),
          child: Text(
            advertisement.isActive ? 'نشط' : 'غير نشط',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: advertisement.isActive ? Colors.green : Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Wrap(
      spacing: 16,
      runSpacing: 4,
      children: [
        // Views count
        _buildStatItem(
          Icons.visibility_outlined,
          '${advertisement.viewsCount} مشاهدة',
          Colors.blue,
        ),

        // Type
        _buildStatItem(
          Icons.label_outline,
          advertisement.type == 'special' ? 'مميز' : 'عادي',
          Colors.orange,
        ),

        // Feature type
        if (advertisement.isFeatured)
          _buildStatItem(
            Icons.star,
            advertisement.isPremium ? 'بريميوم' : 'مميز',
            Colors.amber[700]!,
          ),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.schedule, size: 16, color: Colors.blue[700]),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'مجدول لـ ${_formatDate(advertisement.scheduledFor!)}',
              style: TextStyle(
                fontSize: 11,
                color: Colors.blue[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpiredInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.event_busy, size: 16, color: Colors.red[700]),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'انتهى في ${_formatDate(advertisement.expiresAt!)}',
              style: TextStyle(
                fontSize: 11,
                color: Colors.red[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Promote button (if active and not expired)
          if (onPromote != null && !showExpiredInfo && advertisement.isActive)
            Expanded(
              child: TextButton.icon(
                onPressed: onPromote,
                icon: const Icon(Icons.campaign, size: 18),
                label: const Text(
                  'ترويج',
                  style: TextStyle(fontSize: 13),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.purple[700],
                ),
              ),
            ),

          // Toggle status button (if not expired)
          if (onToggleStatus != null && !showExpiredInfo)
            Expanded(
              child: TextButton.icon(
                onPressed: onToggleStatus,
                icon: Icon(
                  advertisement.isActive
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 18,
                ),
                label: Text(
                  advertisement.isActive ? 'تعطيل' : 'تفعيل',
                  style: const TextStyle(fontSize: 13),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: advertisement.isActive
                      ? Colors.orange[700]
                      : Colors.green[700],
                ),
              ),
            ),

          // Renew button (for expired ads)
          if (onRenew != null && showExpiredInfo)
            Expanded(
              child: TextButton.icon(
                onPressed: onRenew,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text(
                  'تجديد',
                  style: TextStyle(fontSize: 13),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.green[700],
                ),
              ),
            ),

          // Edit button
          if (onEdit != null && !showExpiredInfo)
            Expanded(
              child: TextButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text(
                  'تعديل',
                  style: TextStyle(fontSize: 13),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: appTheme.primary,
                ),
              ),
            ),

          // Delete button
          if (onDelete != null)
            Expanded(
              child: TextButton.icon(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, size: 18),
                label: const Text(
                  'حذف',
                  style: TextStyle(fontSize: 13),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: appTheme.error,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (e) {
      return dateString;
    }
  }
}

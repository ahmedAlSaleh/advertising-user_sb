import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:advertising_user/seller_sb/features/points/my_points/model/ads_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:advertising_user/main.dart';

import '../../../../../../uses_app_sb/core/shared/widgets/image/network_image.dart';

class AdsSection extends StatelessWidget {
  final List<AdModel> adsList;

  const AdsSection({super.key, required this.adsList});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Downloaded Ads".tr,
          style: appTheme.text18.copyWith(
            color: appTheme.primaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: adsList.length,
          itemBuilder: (context, index) {
            return RepaintBoundary(
              child: AdsItem(
                adModel: adsList[index],
                key: ValueKey(adsList[index].title),
              ),
            );
          },
        ),
      ],
    );
  }
}

class AdsItem extends StatefulWidget {
  final AdModel adModel;

  const AdsItem({super.key, required this.adModel});

  @override
  State<AdsItem> createState() => _AdsItemState();
}

class _AdsItemState extends State<AdsItem> {
  // Cache BorderRadius value
  late final BorderRadius _imageRadius;

  @override
  void initState() {
    super.initState();
    _imageRadius = BorderRadius.circular(8.sp);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          widget.adModel.title.tr,
          style: appTheme.text14.copyWith(
            color: appTheme.primaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          widget.adModel.points,
          style: appTheme.text12.copyWith(
            color: appTheme.secondaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: ClipRRect(
          borderRadius: _imageRadius,
          child: getImageNetwork(
            url: widget.adModel.imageUrl,
            width: 50.w,
            height: 50.w,
            fit: BoxFit.cover,
          ),
        ),
        trailing: ActiveStateIndicator(isActive: widget.adModel.isActive),
      ),
    );
  }
}

class ActiveStateIndicator extends StatelessWidget {
  final bool isActive;

  const ActiveStateIndicator({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16.w,
      height: 16.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? appTheme.success : appTheme.error,
      ),
    );
  }
}

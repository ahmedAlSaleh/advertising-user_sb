import 'package:advertising_user/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../uses_app_sb/core/shared/widgets/image/network_image.dart';

class OffersSection extends StatelessWidget {
  const OffersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Offers".tr,
          style: appTheme.text18.copyWith(
              color: appTheme.primaryText, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.h),
        SizedBox(
          height: 250.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return const RepaintBoundary(
                child: OfferItem(offerTilte: "Free Coffee"),
              );
            },
          ),
        ),
      ],
    );
  }
}

class OfferItem extends StatefulWidget {
  const OfferItem({super.key, required this.offerTilte});

  final String offerTilte;

  @override
  State<OfferItem> createState() => _OfferItemState();
}

class _OfferItemState extends State<OfferItem> {
  // Cache BorderRadius value
  late final BorderRadius _imageRadius;

  @override
  void initState() {
    super.initState();
    _imageRadius = BorderRadius.all(Radius.circular(20.sp));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10.w),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: _imageRadius,
            child: getImageNetwork(
                url: 'assets/images/download.png',
                width: 150.w,
                height: 200.h,
                fit: BoxFit.cover),
          ),
          SizedBox(height: 10.h),
          Text(
            widget.offerTilte,
            style: appTheme.text18,
          ),
        ],
      ),
    );
  }
}

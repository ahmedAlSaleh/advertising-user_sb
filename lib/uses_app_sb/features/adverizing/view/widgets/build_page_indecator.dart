import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;

import '../../../../../main.dart';

class BuildPageIndecator extends StatelessWidget {
  const BuildPageIndecator(
      {super.key, required this.pageController, required this.pageCount});
  final PageController pageController;
  final int pageCount;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0.00, 0.60),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
        child: smooth_page_indicator.SmoothPageIndicator(
          controller: pageController,
          count: pageCount, // Use the passed page count

          axisDirection: Axis.horizontal,
          onDotClicked: (i) async {
            await pageController.animateToPage(
              i,
              duration: const Duration(milliseconds: 100),
              curve: Curves.ease,
            );
          },
          effect: smooth_page_indicator.ExpandingDotsEffect(
            expansionFactor: 3,
            spacing: 8.w,
            radius: 16.r,
            dotWidth: 10.w,
            dotHeight: 8.h,
            dotColor: appTheme.primary.withOpacity(0.3),
            activeDotColor: appTheme.primary,
            paintStyle: PaintingStyle.fill,
          ),
        ),
      ),
    );
  }
}

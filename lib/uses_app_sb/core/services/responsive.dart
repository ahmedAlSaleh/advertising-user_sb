import 'dart:math';

import 'package:flutter/widgets.dart';

enum ScreenSize { small, medium, large }

double screenWidth = 0;
late double screenHeight;
late ScreenSize screenSize;

// Base design dimensions, adjust as needed
const double baseScreenWidth =
    412.0; // Base design screen width (e.g., iPhone X)
const double baseScreenHeight =
    915.0; // Base design screen height (e.g., iPhone X)

initSizes(context) {
  double ww = MediaQuery.of(context).size.width;
  // double www = Get.size.width;
  screenWidth = ww > 1000 ? 500 : ww;
  screenHeight = MediaQuery.of(context).size.height;
  if (screenWidth < 400) {
    // Small screens (small phones)
    screenSize = ScreenSize.small;
  } else if (screenWidth < 768) {
    // Medium screens (large phones/phablets)
    screenSize = ScreenSize.medium;
  } else {
    // Large screens (tablets)
    screenSize = ScreenSize.large;
  }
}

// Scale size based on screen width
double scaleWidth(double size) {
  return (size * screenWidth) / baseScreenWidth;
}

// Scale size based on screen height
double scaleHeight(double size) {
  return (size * screenHeight) / baseScreenHeight;
}

// Get responsive text size
double textSize(double fontSize) {
  double scaledSize = (fontSize * screenWidth) / baseScreenWidth;
  double minSize = 12.0; // Set a minimum text size for readability
  return max(scaledSize, minSize);
}

// Get responsive padding
EdgeInsets padding(double top, double right, double bottom, double left) {
  return EdgeInsets.fromLTRB(
    scaleWidth(left),
    scaleHeight(top),
    scaleWidth(right),
    scaleHeight(bottom),
  );
}


  // ... You can add more utility methods as needed


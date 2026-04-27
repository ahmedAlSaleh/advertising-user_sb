import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../server/server_config.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

getImageNetwork(
    {required String url,
    required double? width,
    required double? height,
    Color? imgColor,
    BoxFit? fit,
    AlignmentGeometry? alignmentGeometry}) {
  // Return fallback image immediately if URL is null or empty
  if (url.isEmpty || url == 'null') {
    return Image.asset(
      'assets/images/logo_app.jpg',
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      alignment: alignmentGeometry ?? Alignment.center,
    );
  }

  // Clean and normalize the URL
  String cleanUrl = url.trim();

  // Ensure URL starts with '/' for proper concatenation
  if (!cleanUrl.startsWith('/') && !cleanUrl.startsWith('http')) {
    cleanUrl = '/$cleanUrl';
  }

  // If already a full URL, use it directly
  String fullUrl = cleanUrl.startsWith('http')
      ? cleanUrl
      : ServerConstApis.baseAPI + cleanUrl;

  return Image.network(
    fullUrl,
    width: width,
    alignment: alignmentGeometry ?? Alignment.center,
    height: height,
    fit: fit ?? BoxFit.cover,
    color: imgColor,
    loadingBuilder:
        (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
      if (loadingProgress == null) {
        return child; // Image has finished loading
      }
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!, // Replace with your base color
        highlightColor: Colors.grey[100]!, // Replace with your highlight color
        child: Container(
          width: width,
          height: height ?? 200,
          color: Colors.white,
        ),
      );
    },
    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
      log(stackTrace.toString());
      log(error.toString());
      return Image.asset(
        'assets/images/logo_app.jpg',
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        alignment: alignmentGeometry ?? Alignment.center,
      );
    },
  );
}

getImageNetworkforCahing({
  required String url,
  required double? width,
  required double? height,
  Color? imgColor,
  Alignment? alignmentGeometry,
}) {
  // Return fallback image immediately if URL is null or empty
  if (url.isEmpty || url == 'null') {
    return Image.asset(
      'assets/images/logo_app.jpg',
      width: width,
      height: height,
      fit: BoxFit.cover,
      alignment: alignmentGeometry ?? Alignment.center,
    );
  }

  // Clean and normalize the URL
  String cleanUrl = url.trim();

  // Handle storage path logic
  if (!cleanUrl.startsWith('/') && !cleanUrl.startsWith('http')) {
    cleanUrl = cleanUrl.contains("storage") ? '/$cleanUrl' : "/storage/$cleanUrl";
  } else if (cleanUrl.startsWith('/') && !cleanUrl.contains("storage")) {
    cleanUrl = "/storage$cleanUrl";
  }

  // Build full URL
  final fullUrl = cleanUrl.startsWith('http')
      ? cleanUrl
      : ServerConstApis.baseAPI + cleanUrl;

  return CachedNetworkImage(
    imageUrl: fullUrl,
    width: width,
    height: height,
    fit: BoxFit.cover,
    alignment: alignmentGeometry ?? Alignment.center,
    color: imgColor,
    placeholder: (context, url) => Shimmer.fromColors(
      // baseColor: Color(0xff666666), // Replace with your base color
      baseColor: Colors.grey[500]!, // Replace with your base color
      highlightColor: Colors.grey[400]!, // Replace with your highlight color
      // highlightColor: Color(0xff95a1ac), // Replace with your highlight color
      child: Container(
        width: width,
        height: height,
        color: Colors.white,
      ),
    ),
    errorWidget: (context, url, error) {
      return Image.asset(
        'assets/images/logo_app.jpg',
        width: width,
        height: height,
        fit: BoxFit.cover,
        alignment: alignmentGeometry ?? Alignment.center,
      );
    },
  );
}

getImageNetworkImageProvider({
  required String url,
  required int? width,
  required int? height,
  Color? imgColor,
  Alignment? alignmentGeometry,
}) {
  // Return default asset image if URL is empty or invalid
  if (url.isEmpty || url == 'null') {
    return const AssetImage('assets/images/logo_app.jpg');
  }

  try {
    // Clean and normalize the URL
    String cleanUrl = url.trim();

    // Ensure URL starts with '/' for proper concatenation
    if (!cleanUrl.startsWith('/') && !cleanUrl.startsWith('http')) {
      cleanUrl = '/$cleanUrl';
    }

    // Build full URL
    final fullUrl = cleanUrl.startsWith('http')
        ? cleanUrl
        : ServerConstApis.baseAPI + cleanUrl;

    return CachedNetworkImageProvider(
      fullUrl,
      maxWidth: width,
      maxHeight: height,
      errorListener: (error) {
        log('Image loading error: $error');
      },
    );
  } catch (e) {
    log('Error creating image provider: $e');
    return const AssetImage('assets/images/logo_app.jpg');
  }
}

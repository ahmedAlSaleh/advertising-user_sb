// import 'package:advertising_user/uses_app_sb/main.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart'; // ScreenUtil for responsive layout

// import 'package:get/get.dart';

// class OfferScreen extends StatelessWidget {
//   // Sample dynamic data, you can pass real data here
//   final List<String> images;
//   final String offerTitle;
//   final String offerDescription;
//   final String storeName;
//   final String storeTagline;

//   const OfferScreen({
//     super.key,
//     required this.images,
//     required this.offerTitle,
//     required this.offerDescription,
//     required this.storeName,
//     required this.storeTagline,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: appTheme.primaryBackground,
//       insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12.r),
//       ),
//       child: ConstrainedBox(
//         constraints: BoxConstraints(
//             maxHeight:
//                 0.9.sh), // Ensure content fits within 90% of the screen height
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.all(16.w),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Close button
//                 Align(
//                   alignment: Alignment.topRight,
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: Icon(Icons.close,
//                         size: 24.w, color: appTheme.primaryText),
//                   ),
//                 ),

//                 // Handle image layout with Wrap widget for dynamic images
//                 _buildWrapImageList(context),

//                 SizedBox(height: 16.h),

//                 // Offer Title
//                 Text(
//                   offerTitle,
//                   style: appTheme.text18.copyWith(fontWeight: FontWeight.bold),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 SizedBox(height: 8.h),

//                 // Offer Description
//                 Text(
//                   offerDescription,
//                   style:
//                       appTheme.text14.copyWith(color: appTheme.secondaryText),
//                   maxLines: 5, // Limit to 5 lines
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 SizedBox(height: 24.h),

//                 // About Store Title
//                 Text(
//                   'About the store'.tr,
//                   style: appTheme.text16.copyWith(fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 8.h),

//                 // Store Info (name, tagline)
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(8.r),
//                       child: Image.network(
//                         'https://via.placeholder.com/150', // Replace with store image URL
//                         width: 60.w,
//                         height: 60.h,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     SizedBox(width: 16.w),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             storeName,
//                             style: appTheme.text16
//                                 .copyWith(fontWeight: FontWeight.bold),
//                             maxLines: 1,
//                             overflow: TextOverflow
//                                 .ellipsis, // Handle long store names
//                           ),
//                           Text(
//                             storeTagline,
//                             style: appTheme.text14
//                                 .copyWith(color: appTheme.secondaryText),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 24.h),

//                 // View Store Button
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Get.toNamed('/StoreDetailsPage');
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: appTheme.primary,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30.r),
//                       ),
//                       padding: EdgeInsets.symmetric(vertical: 16.h),
//                     ),
//                     child: Text(
//                       'View Store'.tr,
//                       style: appTheme.text16.copyWith(color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Method to display images using Wrap (instead of GridView)
//   Widget _buildWrapImageList(BuildContext context) {
//     return Wrap(
//       spacing: 5.w,
//       runSpacing: 5.h,
//       children: images.map((imageUrl) {
//         return GestureDetector(
//           onTap: () {
//             _showImageFullscreen(context, imageUrl);
//           },
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(8.r),
//             child: Image.asset(
//               'assets/images/download.png',
//               width: 100.w,
//               height: 100.h,
//               fit: BoxFit.cover,
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }

//   // Show the image in full screen when tapped
//   void _showImageFullscreen(BuildContext context, String imageUrl) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => FullScreenImage(imageUrl: imageUrl),
//       ),
//     );
//   }
// }

// // Full-screen image widget
// class FullScreenImage extends StatelessWidget {
//   final String imageUrl;

//   const FullScreenImage({Key? key, required this.imageUrl}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: GestureDetector(
//         onTap: () {
//           Navigator.of(context).pop();
//         },
//         child: Center(
//           child: Hero(
//             tag: imageUrl,
//             child:
//                 Image.asset('assets/images/download.png', fit: BoxFit.contain),
//           ),
//         ),
//       ),
//     );
//   }
// }

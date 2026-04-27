// import 'package:advertising_user/core/shared/widgets/image/network_image.dart';
// import 'package:advertising_user/main.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:advertising_user/features/store_by_category/model/advertizing_by_category_model.dart';

// class AdvertizingByCategoryCard extends StatelessWidget {
//   final AdvertizingByCategoryModel model;

//   const AdvertizingByCategoryCard({super.key, required this.model});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: appTheme.primaryBackground,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(8.0),
//               child: getImageNetwork(
//                 url: model.imageUrl,
//                 width: double.infinity,
//                 height: 150,
//               ),
//             ),
//             const SizedBox(height: 8.0),
//             Text(
//               model.title,
//               style: appTheme.text16.copyWith(
//                 fontWeight: FontWeight.bold,
//               ),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//             const SizedBox(width: 8.0),
//             Text(
//               model.description,
//               style: appTheme.text14.copyWith(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey,
//               ),
//               maxLines: 3,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

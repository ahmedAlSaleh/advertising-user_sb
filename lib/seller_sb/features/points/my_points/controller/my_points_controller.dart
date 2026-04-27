import 'package:get/get.dart';
import 'package:advertising_user/seller_sb/features/points/my_points/model/ads_model.dart';
import 'package:advertising_user/seller_sb/features/points/my_points/model/point_model.dart';

class MyPointsController extends GetxController {
  // Points data
  final pointsModel = PointsModel(totalPoints: "3,549", growthRate: "+20%").obs;

  // Ads data
  final adsList = <AdModel>[
    AdModel(
        title: "Ad: New Year's Sale",
        points: "100 points",
        imageUrl: 'assets/images/download.png'),
    AdModel(
        title: "Ad: Black Friday Special",
        points: "200 points",
        imageUrl: 'assets/images/download.png'),
    AdModel(
        title: "Ad: Holiday Discounts",
        points: "150 points",
        imageUrl: 'assets/images/download.png')
  ].obs;

  // You can add methods to manipulate the data if needed
  void updatePoints(String newTotalPoints, String newGrowthRate) {
    pointsModel.update((model) {
      model?.totalPoints = newTotalPoints;
      model?.growthRate = newGrowthRate;
    });
  }
}

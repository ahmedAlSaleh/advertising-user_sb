import 'package:get/get.dart';
import 'package:advertising_user/seller_sb/features/points/recharge_points/model/point_package_model.dart';

class RechargePointsController extends GetxController {
  // List of points packages
  final pointsPackages = <PointsPackageModel>[
    PointsPackageModel(
        points: '100', pricePerPoint: '0.20', totalPrice: '1.99 Sp'),
    PointsPackageModel(
        points: '200', pricePerPoint: '0.18', totalPrice: '3.49 Sp'),
    PointsPackageModel(
        points: '500', pricePerPoint: '0.15', totalPrice: '7.50 Sp'),
    PointsPackageModel(
        points: '1000', pricePerPoint: '0.12', totalPrice: '11.99 Sp'),
  ].obs;

  // Handle the purchase logic here
  void buyPoints(String points) {
    Get.snackbar("Purchase", "You bought $points points!");
  }

  // Recharge points logic
  void rechargePoints() {
    Get.snackbar("Recharge", "Recharging points...");
  }
}

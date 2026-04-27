import 'package:get/get.dart';

class City {
  final String nameAr;
  final String nameEn;

  City({required this.nameAr, required this.nameEn});

  factory City.fromjson(Map<String, dynamic> json) => City(
        nameAr: json['name_ar'],
        nameEn: json['name_en'],
      );

  // Get name based on current locale
  String get name {
    String currentLanguage = Get.locale?.languageCode ?? 'ar';
    return currentLanguage == 'ar' ? nameAr : nameEn;
  }
}

/// Promotion Package Model
class PromotionPackageModel {
  final int id;
  final String name;
  final String nameEn;
  final int durationDays;
  final int price;
  final String features;
  final String featuresEn;

  PromotionPackageModel({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.durationDays,
    required this.price,
    required this.features,
    required this.featuresEn,
  });

  factory PromotionPackageModel.fromJson(Map<String, dynamic> json) {
    return PromotionPackageModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      nameEn: json['name_en'] ?? '',
      durationDays: json['duration_days'] ?? 0,
      price: json['price'] ?? 0,
      features: json['features'] ?? '',
      featuresEn: json['features_en'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_en': nameEn,
      'duration_days': durationDays,
      'price': price,
      'features': features,
      'features_en': featuresEn,
    };
  }

  // Helper: Get localized name
  String getLocalizedName({bool isArabic = true}) {
    return isArabic ? name : nameEn;
  }

  // Helper: Get localized features
  String getLocalizedFeatures({bool isArabic = true}) {
    return isArabic ? features : featuresEn;
  }

  // Helper: Format price
  String get formattedPrice {
    return '$price نقطة';
  }

  // Helper: Format duration
  String get formattedDuration {
    if (durationDays == 7) return 'أسبوع واحد';
    if (durationDays == 15) return 'أسبوعين';
    if (durationDays == 30) return 'شهر واحد';
    return '$durationDays يوم';
  }
}

/// Package Info for Promotion Result
class PromotionPackageInfo {
  final int id;
  final String name;
  final int durationDays;

  PromotionPackageInfo({
    required this.id,
    required this.name,
    required this.durationDays,
  });

  factory PromotionPackageInfo.fromJson(Map<String, dynamic> json) {
    return PromotionPackageInfo(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      durationDays: json['duration_days'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'duration_days': durationDays,
    };
  }
}

/// Promotion Result Model
class PromotionResultModel {
  final int advertisementId;
  final PromotionPackageInfo package;
  final DateTime promotedUntil;
  final int pointsDeducted;

  PromotionResultModel({
    required this.advertisementId,
    required this.package,
    required this.promotedUntil,
    required this.pointsDeducted,
  });

  factory PromotionResultModel.fromJson(Map<String, dynamic> json) {
    return PromotionResultModel(
      advertisementId: json['advertisement_id'] ?? 0,
      package: PromotionPackageInfo.fromJson(json['package'] ?? {}),
      promotedUntil: json['promoted_until'] != null
          ? DateTime.parse(json['promoted_until'])
          : DateTime.now(),
      pointsDeducted: json['points_deducted'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'advertisement_id': advertisementId,
      'package': package.toJson(),
      'promoted_until': promotedUntil.toIso8601String(),
      'points_deducted': pointsDeducted,
    };
  }

  // Helper: Format promoted until date
  String get formattedPromotedUntil {
    return '${promotedUntil.day}/${promotedUntil.month}/${promotedUntil.year}';
  }

  // Helper: Get success message
  String get successMessage {
    return 'تم ترويج الإعلان بنجاح حتى $formattedPromotedUntil';
  }
}

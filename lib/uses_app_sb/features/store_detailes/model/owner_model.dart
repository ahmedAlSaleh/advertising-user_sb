
class OwnerStoreDetailes {
  String whatsappNumber;
  String telegramNumber;
  String socialMediaLink;

  OwnerStoreDetailes({
    required this.whatsappNumber,
    required this.telegramNumber,
    required this.socialMediaLink,
  });

  factory OwnerStoreDetailes.fromJson(Map<String, dynamic> json) {
    return OwnerStoreDetailes(
      whatsappNumber: json['whatsapp_number'] ?? '',
      telegramNumber: json['telegram_number'] ?? '',
      socialMediaLink: json['social_media_link'] ?? '',
    );
  }

  factory OwnerStoreDetailes.createDefault({String storeNumber = ''}) {
    return OwnerStoreDetailes(
      whatsappNumber: storeNumber,
      telegramNumber: 'غير متوفر',
      socialMediaLink: 'غير متوفر',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'whatsapp_number': whatsappNumber,
      'telegram_number': telegramNumber,
      'social_media_link': socialMediaLink,
    };
  }
}

/// Support Information Model
class SupportModel {
  final String phone;
  final String email;
  final String whatsapp;
  final String telegram;
  final String workingHours;

  SupportModel({
    required this.phone,
    required this.email,
    required this.whatsapp,
    required this.telegram,
    required this.workingHours,
  });

  factory SupportModel.fromJson(Map<String, dynamic> json) {
    return SupportModel(
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      whatsapp: json['whatsapp'] ?? '',
      telegram: json['telegram'] ?? '',
      workingHours: json['working_hours'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'email': email,
      'whatsapp': whatsapp,
      'telegram': telegram,
      'working_hours': workingHours,
    };
  }

  // Helper: Get WhatsApp URL
  String get whatsappUrl => 'https://wa.me/$whatsapp';

  // Helper: Get Telegram URL
  String get telegramUrl => 'https://t.me/$telegram';

  // Helper: Get phone call URL
  String get phoneCallUrl => 'tel:$phone';

  // Helper: Get email URL
  String get emailUrl => 'mailto:$email';
}

/// App Version Model
class AppVersionModel {
  final String version;
  final int buildNumber;
  final bool forceUpdate;
  final String updateUrl;

  AppVersionModel({
    required this.version,
    required this.buildNumber,
    required this.forceUpdate,
    required this.updateUrl,
  });

  factory AppVersionModel.fromJson(Map<String, dynamic> json) {
    return AppVersionModel(
      version: json['version'] ?? '1.0.0',
      buildNumber: json['build_number'] ?? 1,
      forceUpdate: json['force_update'] ?? false,
      updateUrl: json['update_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'build_number': buildNumber,
      'force_update': forceUpdate,
      'update_url': updateUrl,
    };
  }

  // Helper: Compare versions
  bool isNewerThan(String currentVersion) {
    try {
      final serverParts = version.split('.').map(int.parse).toList();
      final currentParts = currentVersion.split('.').map(int.parse).toList();

      for (int i = 0; i < 3; i++) {
        if (serverParts[i] > currentParts[i]) return true;
        if (serverParts[i] < currentParts[i]) return false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}

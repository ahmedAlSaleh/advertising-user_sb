/// Report Reason Model
class ReportReasonModel {
  final String value;
  final String label;
  final String labelEn;

  ReportReasonModel({
    required this.value,
    required this.label,
    required this.labelEn,
  });

  factory ReportReasonModel.fromJson(Map<String, dynamic> json) {
    return ReportReasonModel(
      value: json['value'] ?? '',
      label: json['label'] ?? '',
      labelEn: json['label_en'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'label': label,
      'label_en': labelEn,
    };
  }

  // Helper: Get localized label
  String getLocalizedLabel({bool isArabic = true}) {
    return isArabic ? label : labelEn;
  }
}

/// Report Model
class ReportModel {
  final int id;
  final String reportableType;
  final int reportableId;
  final String reason;
  final String? description;
  final String status; // pending, reviewed, resolved
  final DateTime createdAt;

  ReportModel({
    required this.id,
    required this.reportableType,
    required this.reportableId,
    required this.reason,
    this.description,
    required this.status,
    required this.createdAt,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] ?? 0,
      reportableType: json['reportable_type'] ?? '',
      reportableId: json['reportable_id'] ?? 0,
      reason: json['reason'] ?? '',
      description: json['description'],
      status: json['status'] ?? 'pending',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reportable_type': reportableType,
      'reportable_id': reportableId,
      'reason': reason,
      if (description != null) 'description': description,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Helper: Get localized reportable type
  String get localizedReportableType {
    switch (reportableType) {
      case 'advertisement':
        return 'إعلان';
      case 'post':
        return 'منشور';
      case 'store':
        return 'متجر';
      case 'trader':
        return 'تاجر';
      default:
        return reportableType;
    }
  }

  // Helper: Get localized status
  String get localizedStatus {
    switch (status) {
      case 'pending':
        return 'قيد المراجعة';
      case 'reviewed':
        return 'تمت المراجعة';
      case 'resolved':
        return 'تم الحل';
      default:
        return status;
    }
  }

  // Helper: Get status color
  String get statusColor {
    switch (status) {
      case 'pending':
        return 'orange';
      case 'reviewed':
        return 'blue';
      case 'resolved':
        return 'green';
      default:
        return 'grey';
    }
  }

  // Helper: Format created at
  String get formattedCreatedAt {
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }
}

/// Report Request Model
class ReportRequest {
  final String reportableType;
  final int reportableId;
  final String reason;
  final String? description;

  ReportRequest({
    required this.reportableType,
    required this.reportableId,
    required this.reason,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'reportable_type': reportableType,
      'reportable_id': reportableId,
      'reason': reason,
      if (description != null && description!.isNotEmpty) 'description': description,
    };
  }
}

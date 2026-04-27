/// Model للـ Response الموحد من الـ Backend
///
/// كل الـ APIs ترجع بهذا الشكل:
/// {
///   "status": true/false,
///   "message": "رسالة النجاح أو الخطأ",
///   "data": {...}
/// }
class ApiResponse<T> {
  /// حالة العملية (نجاح أو فشل)
  final bool status;

  /// رسالة من السيرفر (للنجاح أو الخطأ)
  final String? message;

  /// البيانات المرجعة (إن وجدت)
  final T? data;

  ApiResponse({
    required this.status,
    this.message,
    this.data,
  });

  /// Factory constructor لإنشاء ApiResponse من JSON
  ///
  /// [json] - البيانات المرجعة من الـ API
  /// [fromJsonT] - دالة لتحويل data إلى النوع المطلوب T
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      status: json['status'] ?? false,
      message: json['message'],
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'] as T?,
    );
  }

  /// تحويل الـ ApiResponse إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data,
    };
  }

  /// التحقق من نجاح العملية
  bool get isSuccess => status == true;

  /// التحقق من فشل العملية
  bool get isFailure => status == false;

  @override
  String toString() {
    return 'ApiResponse(status: $status, message: $message, data: $data)';
  }
}

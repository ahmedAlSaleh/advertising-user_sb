/// Exception موحد للأخطاء من الـ API
///
/// يتعامل مع جميع أنواع الأخطاء:
/// - 401: Unauthenticated (انتهت الجلسة)
/// - 403: Forbidden (غير مصرح)
/// - 404: Not Found (غير موجود)
/// - 422: Validation Error (خطأ في البيانات)
/// - 500: Server Error (خطأ في السيرفر)
class ApiException implements Exception {
  /// رسالة الخطأ الرئيسية
  final String message;

  /// HTTP Status Code
  final int? statusCode;

  /// أخطاء التحقق من الصحة (Validation Errors)
  /// مثال: {"email": ["البريد الإلكتروني مطلوب"], "phone": ["رقم الهاتف غير صحيح"]}
  final Map<String, dynamic>? errors;

  ApiException({
    required this.message,
    this.statusCode,
    this.errors,
  });

  /// Factory constructor لإنشاء ApiException من JSON
  factory ApiException.fromJson(int statusCode, Map<String, dynamic> json) {
    return ApiException(
      statusCode: statusCode,
      message: json['message'] ?? _getDefaultMessage(statusCode),
      errors: json['errors'],
    );
  }

  /// الحصول على رسالة افتراضية بناءً على الـ status code
  static String _getDefaultMessage(int statusCode) {
    switch (statusCode) {
      case 401:
        return 'انتهت الجلسة، يرجى تسجيل الدخول مرة أخرى';
      case 403:
        return 'غير مصرح لك بالوصول';
      case 404:
        return 'المورد المطلوب غير موجود';
      case 422:
        return 'خطأ في البيانات المدخلة';
      case 500:
        return 'خطأ في السيرفر، يرجى المحاولة لاحقاً';
      default:
        return 'حدث خطأ غير متوقع';
    }
  }

  /// التحقق من نوع الخطأ
  bool get isAuthError => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isValidationError => statusCode == 422;
  bool get isServerError => statusCode == 500;

  /// الحصول على جميع رسائل الأخطاء (الرسالة الرئيسية + أخطاء التحقق)
  List<String> getAllMessages() {
    List<String> messages = [message];

    if (errors != null) {
      errors!.forEach((key, value) {
        if (value is List) {
          messages.addAll(value.map((e) => e.toString()));
        } else if (value is String) {
          messages.add(value);
        }
      });
    }

    return messages;
  }

  /// الحصول على رسالة واحدة مجمعة
  String get fullMessage {
    return getAllMessages().join('\n');
  }

  @override
  String toString() {
    return 'ApiException($statusCode): $message${errors != null ? '\nErrors: $errors' : ''}';
  }
}

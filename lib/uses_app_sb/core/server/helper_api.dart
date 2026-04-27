import 'dart:convert';
import 'dart:io';
import 'package:advertising_user/uses_app_sb/core/server/api_response.dart';
import 'package:advertising_user/uses_app_sb/core/server/api_exception.dart';
import 'package:dartz/dartz.dart'; // Functional programming in Dart

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiHelper {
  /// Static method to make HTTP requests with new unified response format.
  ///
  /// الشكل الجديد للـ Response:
  /// {
  ///   "status": true/false,
  ///   "message": "رسالة النجاح أو الخطأ",
  ///   "data": {...}
  /// }
  static Future<Either<ApiException, ApiResponse<T>>> makeRequest<T>({
    required String targetRout,
    Map<String, dynamic>? data,
    required String method,
    String? token,
    Map<String, File>? files,
    T Function(dynamic)? fromJsonT,
  }) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
      };

      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      http.Response response;

      if (files != null && files.isNotEmpty) {
        Uri url = Uri.parse(targetRout);
        var request = http.MultipartRequest(method, url);
        request.headers.addAll(headers);
        data?.forEach((key, value) {
          request.fields[key] = value.toString();
        });

        // ✅ FIX: Properly await all files to be added before sending
        for (var entry in files.entries) {
          var multipartFile = await http.MultipartFile.fromPath(
            entry.key,
            entry.value.path,
            contentType: MediaType('application', 'octet-stream')
          );
          request.files.add(multipartFile);
        }

        var streamedResponse = await request.send();
        response = await http.Response.fromStream(streamedResponse);
      } else {
        Uri url = Uri.parse(targetRout);
        switch (method.toUpperCase()) {
          case 'POST':
            response =
                await http.post(url, body: jsonEncode(data), headers: headers);
            break;
          case 'PUT':
            response =
                await http.put(url, body: jsonEncode(data), headers: headers);
            break;
          case 'GET':
            response = await http.get(url, headers: headers);
            break;
          case 'DELETE':
            response = await http.delete(url, headers: headers);
            break;
          case 'PATCH':
            response =
                await http.patch(url, body: jsonEncode(data), headers: headers);
            break;
          default:
            throw UnimplementedError('HTTP method $method not supported');
        }
      }

      print('📡 API Request: $method $targetRout');
      print('📊 Status Code: ${response.statusCode}');
      print('📦 Response Body: ${response.body}');

      // معالجة النجاح (200-299)
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseBody = jsonDecode(response.body);

        // تحويل الـ response إلى ApiResponse
        final apiResponse = ApiResponse<T>.fromJson(responseBody, fromJsonT);

        return Right(apiResponse);
      }
      // معالجة الأخطاء
      else {
        final responseBody = jsonDecode(response.body);
        final apiException = ApiException.fromJson(response.statusCode, responseBody);

        // طباعة تفاصيل الخطأ للمساعدة في التطوير
        if (response.statusCode == 401) {
          print("⚠️ 401 Unauthenticated - Endpoint: $targetRout");
          print("⚠️ Token present: ${token != null && token.isNotEmpty}");
        }

        return Left(apiException);
      }
    } catch (e) {
      print('❌ API Error: $e');
      return Left(ApiException(
        message: 'حدث خطأ في الاتصال بالسيرفر',
        statusCode: 500,
      ));
    }
  }
}

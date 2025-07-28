import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skinsight/core/api/api_config.dart';
import 'package:skinsight/core/common/app-navigator.dart';
import 'package:skinsight/core/common/app_route.dart';


import '../error/exceptions.dart';

class ApiClient {
  static const Duration timeoutDuration = Duration(seconds: 20);

  /// Core request handler
  static Future<T> request<T>({
    required Future<http.Response> Function() request,
    required T Function(dynamic json) parser,
  }) async {
    try {
      final response = await request().timeout(timeoutDuration);

      final contentType = response.headers['content-type'];
      final isJson = contentType?.contains('application/json') ?? false;

      final body =
          isJson && response.body.isNotEmpty ? jsonDecode(response.body) : null;

      final message = body?['message'] ??
          body?['error'] ?? response.reasonPhrase ??
          'Terjadi kesalahan.';
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // if (body == null) {
        //   throw FormatException('Response body kosong.');
        // }
        // return parser(body);
        return parser(body ?? {});
      } else if (response.statusCode == 401) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        // WidgetsBinding.instance.addPostFrameCallback((_) {
        //   AppNavigator.pushAndRemoveUntil('/sign-in');
        // });
        throw UnauthorizedException(message);
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        throw ClientException(message);
      } else if (response.statusCode >= 500) {
        throw ServerException(message);
      } else {
        throw UnexpectedException(
            'Status tidak diketahui: ${response.statusCode}');
      }
    } on TimeoutException {
      throw TimeoutException('Permintaan melebihi waktu tunggu.');
    } on SocketException {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppNavigator.push(AppRoute.noConnectionPage);
      });
      throw SocketException('No Internet Connection');
    } on FormatException {
      throw FormatException('Format respons tidak valid.');
    } on ClientException {
      rethrow;
    } on UnauthorizedException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw UnexpectedException('Status tidak diketahui: ${e.toString()}');
    }
  }

  static Future<Map<String, String>> getHeaders({
    Map<String, String>? extra,
    bool requireAuth = true,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
    };

    if (requireAuth) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    if (extra != null) {
      headers.addAll(extra);
    }

    return headers;
  }

  /// GET
  static Future<T> get<T>({
    required String endpoint,
    Map<String, String>? headers,
    required T Function(dynamic json) parser,
  }) {

    return request(
      request: () => http.get(Uri.parse('${ApiConfig.baseUrl}$endpoint'),
          headers: headers),
      parser: parser,
      
    );
  }

  /// POST
  static Future<T> post<T>({
    required String endpoint,
    Map<String, String>? headers,
    Object? body,
    required T Function(dynamic json) parser,
  }) {
     
    return request(
      request: () => http.post(
        Uri.parse('${ApiConfig.baseUrl}$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      ),
      parser: parser,
    );
  }

  static Future<T> postMultipart<T>({
    required String endpoint,
    required Map<String, String> fields,
    required File file,
    required String fileFieldName,
    required T Function(dynamic json) parser,
  }) {
    return request(
      request: () async {
        final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');

        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');

        final request = http.MultipartRequest('POST', uri);

        // Headers
        request.headers['Authorization'] = 'Bearer $token';
        request.headers['Accept'] = 'application/json';

        // Fields (form data)
        request.fields.addAll(fields);

        // File (e.g., image)
        request.files.add(await http.MultipartFile.fromPath(
          fileFieldName,
          file.path,
        ));

        // Send the request
        final streamedResponse = await request.send();
        return await http.Response.fromStream(streamedResponse);
      },
      parser: parser,
    );
  }

  /// PUT
  static Future<T> put<T>({
    required String endpoint,
    Map<String, String>? headers,
    Object? body,
    required T Function(dynamic json) parser,
  }) {
    return request(
      request: () => http.put(
        Uri.parse('${ApiConfig.baseUrl}$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      ),
      parser: parser,
    );
  }

  static Future<T> putMultipart<T>({
  required String endpoint,
  required Map<String, String> fields,
  required File file,
  required String fileFieldName,
  required T Function(dynamic json) parser,
}) {
  return request(
    request: () async {
      final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final request = http.MultipartRequest('PUT', uri);

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      request.fields.addAll(fields);

      request.files.add(await http.MultipartFile.fromPath(
        fileFieldName,
        file.path,
      ));

      final streamedResponse = await request.send();
      return await http.Response.fromStream(streamedResponse);
    },
    parser: parser,
  );
}


  /// DELETE
  static Future<T> delete<T>({
    required String url,
    Map<String, String>? headers,
    Object? body,
    required T Function(dynamic json) parser,
  }) {
    return request(
      request: () => http.delete(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      ),
      parser: parser,
    );
  }
}

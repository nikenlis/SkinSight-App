import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skinsight/features/assesment/data/models/assesment_model.dart';

import '../../../../core/api/api_config.dart';
import '../../../../core/error/exceptions.dart';

abstract class AssesmentRemoteDatasource {
  Future<AssesmentModel> getAssesment({
    required String? gender,
    required int? age,
    String? skinType,
    File? scanImage,
  });
}

class AssesmentRemoteDatasourceImpl implements AssesmentRemoteDatasource {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  @override
  Future<AssesmentModel> getAssesment({
    required String? gender,
    required int? age,
    String? skinType,
    File? scanImage,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final formData = FormData();

    formData.fields
      ..add(MapEntry('gender', gender ?? ''))
      ..add(MapEntry('age', age?.toString() ?? ''))
      ..add(MapEntry('skinType', skinType ?? ''));

    if (scanImage != null) {
      formData.files.add(MapEntry(
        'scanImage',
        await MultipartFile.fromFile(
          scanImage.path,
          filename: scanImage.path.split('/').last,
          contentType: getMediaType(scanImage.path),
        ),
      ));
    }

    try {
      final response = await dio.post(
        '${ApiConfig.baseUrl}/assessment',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      return AssesmentModel.fromJson(response.data);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode ?? 0;
      final body = e.response?.data;
      final message = body?['message'] ??
          body?['error'] ??
          e.message ??
          'Terjadi kesalahan.';
      
              if (e.type == DioExceptionType.receiveTimeout || e.type == DioExceptionType.sendTimeout || e.type == DioExceptionType.connectionTimeout) {
    throw TimeoutException('Permintaan melebihi waktu tunggu.');
  }
          
      if (statusCode == 413) {
        throw ClientException(
          'Ukuran gambar terlalu besar. Coba gunakan gambar dengan resolusi lebih kecil.',
        );
      }
      if (statusCode == 401) {
        throw UnauthorizedException(message);
      } else if (statusCode >= 400 && statusCode < 500) {
        throw ClientException(message);
      } else if (statusCode >= 500) {
        throw ServerException(message);
      } else {
        throw UnexpectedException('Status tidak diketahui: $statusCode');
      }
    } on TimeoutException {
      throw TimeoutException('Permintaan melebihi waktu tunggu.');
    } on SocketException {
      throw SocketException('No Internet Connection');
    } on FormatException {
      throw FormatException('Format respons tidak valid.');
    } catch (e) {
      throw UnexpectedException('Status tidak diketahui: ${e.toString()}');
    }
  }
}

MediaType getMediaType(String path) {
  final ext = path.split('.').last.toLowerCase();
  switch (ext) {
    case 'jpg':
    case 'jpeg':
      return MediaType('image', 'jpeg');
    case 'png':
      return MediaType('image', 'png');
    case 'gif':
      return MediaType('image', 'gif');
    case 'heic':
    case 'heif':
      return MediaType('image', 'heic');
    case 'webp':
      return MediaType('image', 'webp');
    default:
      return MediaType('application', 'octet-stream');
  }
}

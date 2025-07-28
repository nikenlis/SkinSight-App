import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skinsight/features/scan_ingredients/data/models/history_scan_ingredients_model.dart';
import 'package:skinsight/features/scan_ingredients/data/models/scan_ingredients_model.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_config.dart';
import '../../../../core/error/exceptions.dart';


abstract class ScanIngredientsRemoteDatasource {
  Future<ScanIngredientsModel> getScanIngredients(
      {required File image, required String name});

  Future< List<HistoryScanIngredientsModel>> getHistoryScanIngredients();
  Future<ScanIngredientsModel> getDetailHistoryScanIngredients({required String id});
}

class ScanIngredientsRemoteDatasourceImpl
    implements ScanIngredientsRemoteDatasource {

  // final dio = Dio(
  //   BaseOptions(
  //     connectTimeout: const Duration(seconds: 10),
  //     receiveTimeout: const Duration(seconds: 50),
  //   ),
  // );

    final Dio dio;

    final dioLoggerInterceptor = PrettyDioLogger(
  requestHeader: true,
  requestBody: true,
  responseBody: true,
  responseHeader: false,
  error: true,
  compact: true,
  maxWidth: 90,
);

  ScanIngredientsRemoteDatasourceImpl()
      : dio = Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 60),
        )) {
    dio.interceptors.add(dioLoggerInterceptor);
  }

  @override
  Future<ScanIngredientsModel> getScanIngredients(
      {required File image, required String name}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final formData = FormData();

    formData.files.add(MapEntry(
      'scanImage',
      await MultipartFile.fromFile(
        image.path,
        filename: image.path.split('/').last,
        contentType: getMediaType(image.path),
      ),
    ));

    formData.fields.add(MapEntry('productName', name));

    try {
      final response = await dio.post(
        '${ApiConfig.baseUrl}/scan/ingredients',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      return ScanIngredientsModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode ?? 0;
      final body = e.response?.data;
      final message = body?['message'] ??
          body?['error'] ??
          e.message ??
          'Terjadi kesalahan.';
      if (e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionTimeout) {
        throw TimeoutException('Permintaan melebihi waktu tunggu.');
      }

      if (statusCode == 413) {
        throw ClientException(
          'Ukuran gambar terlalu besar. Coba gunakan gambar dengan resolusi lebih kecil.',
        );
      } else if (statusCode == 401) {
        throw UnauthorizedException(message);
      } else if (statusCode >= 400 && statusCode < 500) {
        throw ClientException(message);
      } else if (statusCode >= 500) {
        throw ServerException(message);
      } else {
        throw UnexpectedException('Status tidak diketahui: $statusCode');
      }
    } on SocketException {
      throw SocketException('No Internet Connection');
    } on FormatException {
      throw FormatException('Format respons tidak valid.');
    } catch (e) {
      throw UnexpectedException('Status tidak diketahui: ${e.toString()}');
    }
  }
  
  @override
  Future<List<HistoryScanIngredientsModel>> getHistoryScanIngredients() async {
   return await ApiClient.get<List<HistoryScanIngredientsModel>>(
      endpoint: "/scan/ingredients/history",
       headers: await ApiClient.getHeaders(),
      parser: (json) {
        final list = (json['data'] as List);
        print('🔥🔥🙌🏻🙌🏻 Data  => ${list}');
        return list.map((item) => HistoryScanIngredientsModel.fromJson(item)).toList();
      },
    );
  }
  
  @override
  Future<ScanIngredientsModel> getDetailHistoryScanIngredients({required String id}) async {
    return await ApiClient.get<ScanIngredientsModel>(
      endpoint: "/scan/ingredients/history/$id",
       headers: await ApiClient.getHeaders(),
     parser: (json) {
      return  ScanIngredientsModel.fromJson(json['data']);
     }
     
    );
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

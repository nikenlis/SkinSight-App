import 'package:skinsight/features/explore/data/models/detail_education_model.dart';
import 'package:skinsight/features/explore/data/models/detail_news_model.dart';
import 'package:skinsight/features/explore/data/models/news_model.dart';
import '../../../../core/api/api_client.dart';
import '../models/education_model.dart';

abstract class ExploreRemoteDatasource {
  Future<List<NewsModel>> getAllNews(int? page);
  Future<PagignationEducationModel> getAllEducation(int? page,
      {required String? nextPage, required String? prevPage});
  Future<DetailNewsModel> getDetailNews({required String articleLink});
   Future<DetailEducationModel> getDetailEducation({required String articleLink});
}

class ExploreRemoteDatasourceImpl implements ExploreRemoteDatasource {
  @override
  Future<List<NewsModel>> getAllNews(int? page) async {
    return await ApiClient.get<List<NewsModel>>(
      endpoint: "/news?page=$page",
      headers: await ApiClient.getHeaders(),
      parser: (json) {
        final list = (json['data']['news'] as List);
        return list.map((item) => NewsModel.fromJson(item)).toList();
      },
    );
  }

  @override
  Future<PagignationEducationModel> getAllEducation(int? page,
      {required String? nextPage, required String? prevPage}) async {
    final response = await ApiClient.post<PagignationEducationModel>(
      endpoint: '/educations',
      headers: await ApiClient.getHeaders(requireAuth: true),
      body: {
        "page": page, "prevLink": prevPage, "nextLink": nextPage
      },
      parser: (json) => PagignationEducationModel.fromJson(json['data']),
    );

    return response;
  }

  @override
  Future<DetailNewsModel> getDetailNews({required String articleLink}) async {
    final response = await ApiClient.post<DetailNewsModel>(
      endpoint: '/news/detail',
      headers: await ApiClient.getHeaders(requireAuth: true),
      body: {'articleLink': articleLink},
      parser: (json) => DetailNewsModel.fromJson(json['data']),
    );
    return response;
  }
  
  @override
  Future<DetailEducationModel> getDetailEducation({required String articleLink}) async{
       final response = await ApiClient.post<DetailEducationModel>(
      endpoint: '/educations/detail',
      headers: await ApiClient.getHeaders(requireAuth: true),
      body: {'articleLink': articleLink},
      parser: (json) => DetailEducationModel.fromJson(json['data']),
    );
    return response;
  }
  



}

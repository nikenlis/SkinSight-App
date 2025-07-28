
import '../../../../core/api/api_client.dart';
import '../../../product/data/models/product_model.dart';

abstract class RecomendationProductRemoteDatasource {
  Future<List<ProductModel>> getRecomendationProduct();
}

class RecomendationProductRemoteDatasourceImpl implements RecomendationProductRemoteDatasource {
  @override
  Future<List<ProductModel>> getRecomendationProduct() async {
    return await ApiClient.get<List<ProductModel>>(
      endpoint: "/product/recommendations",
       headers: await ApiClient.getHeaders(),
      parser: (json) {
       final list = (json['data'] as List);
      return list.map((item) => ProductModel.fromJson(item)).toList();
      },
    );
  }

}
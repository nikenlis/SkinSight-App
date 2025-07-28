import 'package:skinsight/features/product/data/models/category_brand_entity.dart';
import 'package:skinsight/features/product/data/models/product_filter_model.dart';
import 'package:skinsight/features/product/data/models/product_model.dart';

import '../../../../core/api/api_client.dart';


abstract class ProductRemoteDatasource {
  Future<PaginatedProductResultModel> getProduct({
    int? page,
    String? sort,
    String? type,
    String? brand,
    String? search
  });

  Future<ProductFilterModel> getProductFilter ();

  Future<List<CategoryBrandModel>> getCategoryBrand ({required String brand});
  Future<List<ProductModel>> getProductByCategoryBrand({required String brand, required String category});
}

class ProductRemoteDatasourceImpl implements ProductRemoteDatasource {
  @override
  Future<PaginatedProductResultModel> getProduct(
      {int? page, String? sort, String? type, String? brand, String? search}) async {
        final param = buildProductQueryString(page: page, sort: sort, type: type, brand: brand);
    return await ApiClient.get<PaginatedProductResultModel>(
      endpoint: '/product/all?$param',
      headers: await ApiClient.getHeaders(),
      parser: (json) => PaginatedProductResultModel.fromJson(json['data']),
    );
  }

  String buildProductQueryString({
  String? sort,
  String? type,
  String? brand,
  int? page,
  String? search
}) {
  final queryParameters = <String, String>{
    if (page != null) 'page': page.toString(),
    if (sort != null && sort.isNotEmpty) 'sort': sort,
    if (type != null && type.isNotEmpty) 'type': type,
    if (brand != null && brand.isNotEmpty) 'brand': brand,
    if (search != null && search.isNotEmpty) 'search': search,
  };
   print("🧯 Stacktrace: ${Uri(queryParameters: queryParameters).query}");
  return Uri(queryParameters: queryParameters).query;
}

  @override
  Future<ProductFilterModel> getProductFilter()async {
        return await ApiClient.get<ProductFilterModel>(
      endpoint: "/product/types-and-brands",
       headers: await ApiClient.getHeaders(),
      parser: (json) {
        return ProductFilterModel.fromJson(json);
      },
    );
  }
  
  @override
  Future<List<CategoryBrandModel>> getCategoryBrand({required String brand}) async {
   return await ApiClient.get<List<CategoryBrandModel>>(
      endpoint: "/product/brand/$brand",
       headers: await ApiClient.getHeaders(),
      parser: (json) {
        final list = (json['data'] as List);
        return list.map((item) => CategoryBrandModel.fromJson(item)).toList();
      },
    );
  }
  
  @override
  Future<List<ProductModel>> getProductByCategoryBrand({required String brand, required String category}) async {
    return await ApiClient.get<List<ProductModel>>(
      endpoint: "/product/brand/$brand/$category",
       headers: await ApiClient.getHeaders(),
      parser: (json) {
        final list = (json['data'] as List);
        return list.map((item) => ProductModel.fromJson(item)).toList();
      },
    );
  }
}

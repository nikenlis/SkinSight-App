import 'package:skinsight/features/product/domain/entities/product_entity.dart';

class PaginatedProductResultModel extends PaginatedProductResultEntity {
  PaginatedProductResultModel({
    required List<ProductModel> super.products,
    required super.currentPage,
    required super.lastPage,
  });

  factory PaginatedProductResultModel.fromJson(Map<String, dynamic> json) {
    return PaginatedProductResultModel(
      products: (json['data'] as List)
          .map((e) => ProductModel.fromJson(e))
          .toList(),
      currentPage: json['meta']['currentPage'],
      lastPage: json['meta']['lastPage'],
    );
  }

  PaginatedProductResultEntity toEntity() {
    return PaginatedProductResultEntity(
      products: products.map((e) => (e as ProductModel).toEntity()).toList(),
      currentPage: currentPage,
      lastPage: lastPage,
    );
  }
}


class ProductModel extends ProductEntity {
  const ProductModel(
      {required super.id,
      required super.title,
      required super.price,
      required super.description,
      required super.imageUrl,
      required super.link,
      required super.type,
      required super.brand,
      required super.ingredients, 
      required super.brandImageUrl});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      price: json['price'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      link: json['link'] ?? '',
      type: json['type'] ?? '',
      brand: json['brand'] ?? '',
      ingredients: json['ingredients'] ?? '',
      brandImageUrl: json['brandImageUrl'] ?? ''
    );
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      title: title,
      price: price,
      description: description,
      imageUrl: imageUrl,
      link: link,
      type: type,
      brand: brand,
      ingredients: ingredients,
      brandImageUrl: brandImageUrl
    );
  }
}

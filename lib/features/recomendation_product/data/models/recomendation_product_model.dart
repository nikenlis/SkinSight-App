import 'package:skinsight/features/recomendation_product/domain/entities/recommendation_product_entity.dart';

class RecomendationProductModel extends RecommendationProductEntity {
  const RecomendationProductModel(
      {required super.id,
      required super.title,
      required super.price,
      required super.description,
      required super.imageUrl,
      required super.link,
      required super.type,
      required super.brand,
      required super.ingredients});

  factory RecomendationProductModel.fromJson(Map<String, dynamic> json) {
    return RecomendationProductModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      price: json['price'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      link: json['link'] ?? '',
      type: json['type'] ?? '',
      brand: json['brand'] ?? '',
      ingredients: json['ingredients'] ?? '',
    );
  }

  RecommendationProductEntity toEntity() {
    return RecommendationProductEntity(
      id: id,
      title: title,
      price: price,
      description: description,
      imageUrl: imageUrl,
      link: link,
      type: type,
      brand: brand,
      ingredients: ingredients,
    );
  }

  static List<RecomendationProductModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => RecomendationProductModel.fromJson(json))
        .toList();
  }

}

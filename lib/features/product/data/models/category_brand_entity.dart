import '../../domain/entities/category_brand_entity.dart';

class CategoryBrandModel extends CategoryBrandEntity {
  const CategoryBrandModel({required super.type, required super.productCount});

    factory CategoryBrandModel.fromJson(Map<String, dynamic> json) {
    return CategoryBrandModel(
      type: json['type'] as String,
      productCount: json['productCount'] as int,
    );
  }

   CategoryBrandEntity toEntity() => CategoryBrandEntity(
        type: type,
        productCount: productCount,
      );
  
}
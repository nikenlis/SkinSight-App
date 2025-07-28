import '../../domain/entities/product_filter_entity.dart';

class ProductFilterModel extends ProductFilterEntity {
  const ProductFilterModel({
    required super.types,
    required List<BrandModel> super.brands,
  });

  factory ProductFilterModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return ProductFilterModel(
      types: List<String>.from(data['types']),
      brands: (data['brands'] as List)
          .map((e) => BrandModel.fromJson(e))
          .toList(),
    );
  }

  ProductFilterEntity toEntity() {
    return ProductFilterEntity(
      types: types,
      brands: (brands as List<BrandModel>).map((e) => e.toEntity()).toList(),
    );
  }
}

class BrandModel extends BrandEntity {
  const BrandModel({
    required super.name,
    required super.image,
    required super.total,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      name: json['name'],
      image: json['image'],
      total: json['total'],
    );
  }

  BrandEntity toEntity() {
    return BrandEntity(
      name: name,
      image: image,
      total: total,
    );
  }
}

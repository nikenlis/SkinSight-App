import 'package:equatable/equatable.dart';
class ProductFilterEntity extends Equatable {
  final List<String> types;
  final List<BrandEntity> brands;

  const ProductFilterEntity({
    required this.types,
    required this.brands,
  });

  @override
  List<Object> get props => [types, brands];
}

class BrandEntity extends Equatable {
  final String name;
  final String image;
  final int total;

  const BrandEntity({
    required this.name,
    required this.image,
    required this.total,
  });

  @override
  List<Object> get props => [name, image, total];
}
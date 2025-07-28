
import 'package:equatable/equatable.dart';

class CategoryBrandEntity extends Equatable {
  final String type;
  final int productCount;

  const CategoryBrandEntity({required this.type, required this.productCount});

  @override
  List<Object> get props => [type, productCount];
}

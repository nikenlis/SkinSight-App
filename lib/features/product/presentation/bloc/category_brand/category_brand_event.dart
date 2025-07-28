// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'category_brand_bloc.dart';

sealed class CategoryBrandEvent extends Equatable {
  const CategoryBrandEvent();

  @override
  List<Object> get props => [];
}
class GetCategoryBrand extends CategoryBrandEvent {
  final String brand;

  const GetCategoryBrand({required this.brand});
}

class GetAllProductByCategoryBrand extends CategoryBrandEvent {
  final String brand;
  final String category;

  const GetAllProductByCategoryBrand({
    required this.brand,
    required this.category,
  });
}

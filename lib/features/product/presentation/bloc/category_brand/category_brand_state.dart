part of 'category_brand_bloc.dart';

sealed class CategoryBrandState extends Equatable {
  const CategoryBrandState();
  
  @override
  List<Object> get props => [];
}

final class CategoryBrandInitial extends CategoryBrandState {}
final class CategoryBrandLoading extends CategoryBrandState {}
final class CategoryBrandFailed extends CategoryBrandState {
  final String message;

  const CategoryBrandFailed({required this.message});
}

final class CategoryBrandLoaded extends CategoryBrandState {
  final List<CategoryBrandEntity> data;

  const CategoryBrandLoaded({required this.data});

  @override
  List<Object> get props => [data];
}

final class AllProductByCategoryBrandLoaded extends CategoryBrandState {
  final List<ProductEntity> data;

  const AllProductByCategoryBrandLoaded({required this.data});

  @override
  List<Object> get props => [data];
}
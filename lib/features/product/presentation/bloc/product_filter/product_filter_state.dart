part of 'product_filter_bloc.dart';

sealed class ProductFilterState extends Equatable {
  const ProductFilterState();
  
  @override
  List<Object> get props => [];
}

final class ProductFilterInitial extends ProductFilterState {}
final class ProductFilterLoading extends ProductFilterState {

}
final class ProductFilterFailed extends ProductFilterState {
  final String message;

  const ProductFilterFailed({required this.message});
}
final class ProductFilterLoaded extends ProductFilterState {
  final List<String> types;
  final List<BrandEntity> brands;

  ProductFilterLoaded({required this.types, required this.brands});

 
}
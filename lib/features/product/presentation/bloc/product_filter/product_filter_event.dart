part of 'product_filter_bloc.dart';

sealed class ProductFilterEvent extends Equatable {
  const ProductFilterEvent();

  @override
  List<Object> get props => [];
}

class GetProductFilterEvent extends ProductFilterEvent {}

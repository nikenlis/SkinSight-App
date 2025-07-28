
part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class GetProductEvent extends ProductEvent {
  String? sort;
  String? type;
  String? brand;
  int? page;
  String? search;
  final bool isRefresh;

  @override
  List<Object?> get props => [type, sort, brand, page, search, isRefresh];
  GetProductEvent( {
    this.sort,
    this.type,
    this.brand,
    this.page,
    this.search,
    this.isRefresh= false,
  });



}

class ProductRefreshEvent extends ProductEvent {}

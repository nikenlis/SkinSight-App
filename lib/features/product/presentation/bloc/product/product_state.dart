

import 'package:equatable/equatable.dart';

import '../../../domain/entities/product_entity.dart';
enum ProductFetchStatus { initial, loading, success, failure }

class ProductState extends Equatable {
  final Map<String, ProductTabState> productMap;

  const ProductState({this.productMap = const {}});

  ProductTabState getTabState(String type) {
    return productMap[type] ??
        const ProductTabState(products: [], page: 0, status: ProductFetchStatus.initial);
  }

  ProductState copyWith({
    Map<String, ProductTabState>? productMap,
  }) {
    return ProductState(
      productMap: productMap ?? this.productMap,
    );
  }

  @override
  List<Object> get props => [productMap];
}

class ProductTabState extends Equatable {
  final List<ProductEntity> products;
  final int page;
  final bool hasReachedMax;
  final ProductFetchStatus status;
  final String? errorMessage;
  final String? sort;

  const ProductTabState({
    required this.products,
    required this.page,
    this.hasReachedMax = false,
    this.status = ProductFetchStatus.initial,
    this.errorMessage,
    this.sort,
  });

  ProductTabState copyWith({
    List<ProductEntity>? products,
    int? page,
    bool? hasReachedMax,
    ProductFetchStatus? status,
    String? errorMessage,
    String? sort,
  }) {
    return ProductTabState(
      products: products ?? this.products,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      sort: sort ?? this.sort,
    );
  }

  @override
  List<Object?> get props => [products, page, hasReachedMax, status, errorMessage, sort];
}

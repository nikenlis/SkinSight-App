part of 'brand_bloc.dart';

sealed class BrandEvent extends Equatable {
  const BrandEvent();

  @override
  List<Object> get props => [];
}

class GetProductbyBrand extends BrandEvent {
  final String brand;
  final bool isRefresh;

  const GetProductbyBrand({required this.brand, this.isRefresh = false});
}




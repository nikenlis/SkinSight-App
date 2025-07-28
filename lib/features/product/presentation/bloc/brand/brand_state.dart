part of 'brand_bloc.dart';

sealed class BrandState extends Equatable {
  const BrandState();

  @override
  List<Object> get props => [];
}

final class BrandInitial extends BrandState {}

final class BrandLoading extends BrandState {}

final class BrandFailed extends BrandState {
  final String message;

  const BrandFailed({required this.message});
}

final class BrandLoaded extends BrandState {
  final List<ProductEntity> data;
  final bool hasReachedMax;

  const BrandLoaded({required this.data, this.hasReachedMax = false});
  @override
  List<Object> get props => [data, hasReachedMax];
}


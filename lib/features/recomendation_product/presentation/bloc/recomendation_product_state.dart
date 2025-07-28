part of 'recomendation_product_bloc.dart';

abstract class RecomendationProductState extends Equatable {
  const RecomendationProductState();  

  @override
  List<Object> get props => [];
}
class RecomendationProductInitial extends RecomendationProductState {}
class RecomendationProductLoading extends RecomendationProductState {}
class RecomendationProductFailed extends RecomendationProductState {
  final String message;

  const RecomendationProductFailed({required this.message});
}
class RecomendationProductLoaded extends RecomendationProductState {
  final List<ProductEntity> data;

  const RecomendationProductLoaded({required this.data});
}
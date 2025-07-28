part of 'recomendation_product_bloc.dart';

abstract class RecomendationProductEvent extends Equatable {
  const RecomendationProductEvent();

  @override
  List<Object> get props => [];
}

class GetRecomendationProductEvent extends RecomendationProductEvent {
  
}

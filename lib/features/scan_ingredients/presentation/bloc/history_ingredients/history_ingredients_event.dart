part of 'history_ingredients_bloc.dart';

sealed class HistoryIngredientsEvent extends Equatable {
  const HistoryIngredientsEvent();

  @override
  List<Object> get props => [];
}

 class GetHistoryIngredients extends HistoryIngredientsEvent {

 }

 class GetDetailHistoryIngredients extends HistoryIngredientsEvent {
  final String id;

  GetDetailHistoryIngredients({required this.id});
 }
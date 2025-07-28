part of 'history_ingredients_bloc.dart';

sealed class HistoryIngredientsState extends Equatable {
  const HistoryIngredientsState();
  
  @override
  List<Object> get props => [];
}

final class HistoryIngredientsInitial extends HistoryIngredientsState {}
final class HistoryIngredientsFailed extends HistoryIngredientsState {
  final String message;

  const HistoryIngredientsFailed({required this.message});
}
final class HistoryIngredientsLoading extends HistoryIngredientsState {}
final class HistoryIngredientsLoaded extends HistoryIngredientsState {
  final List<HistoryScanIngredientEntity> data;

  const HistoryIngredientsLoaded({required this.data});
}

final class DetailHistoryIngredientsLoaded extends HistoryIngredientsState {
  final ScanIngredientsEntity data;

  const DetailHistoryIngredientsLoaded({required this.data});
}
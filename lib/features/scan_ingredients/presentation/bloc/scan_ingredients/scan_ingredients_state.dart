part of 'scan_ingredients_bloc.dart';

abstract class ScanIngredientsState extends Equatable {
  const ScanIngredientsState();  

  @override
  List<Object> get props => [];
}
class ScanIngredientsInitial extends ScanIngredientsState {}
class ScanIngredientsLoading extends ScanIngredientsState {}
class ScanIngredientsFailed extends ScanIngredientsState {
  final String message;

  const ScanIngredientsFailed({required this.message});
}
class ScanIngredientsLoaded extends ScanIngredientsState {
  final ScanIngredientsEntity data;

  const ScanIngredientsLoaded({required this.data});
}
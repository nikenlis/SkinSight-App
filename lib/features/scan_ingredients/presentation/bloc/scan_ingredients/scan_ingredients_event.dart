part of 'scan_ingredients_bloc.dart';

abstract class ScanIngredientsEvent extends Equatable {
  const ScanIngredientsEvent();

  @override
  List<Object> get props => [];
}

class GetScanIngredientsEvent extends ScanIngredientsEvent {
  final File image;
  final String name;

  const GetScanIngredientsEvent({required this.image, required this.name});
}

class ResetScanIngredientsEvent extends ScanIngredientsEvent {}

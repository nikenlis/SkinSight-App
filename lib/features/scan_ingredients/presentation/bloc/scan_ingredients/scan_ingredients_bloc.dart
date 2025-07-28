import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skinsight/features/scan_ingredients/domain/usecases/scan_ingredients_usecase.dart';

import '../../../domain/entities/scan_ingredients_entity.dart';

part 'scan_ingredients_event.dart';
part 'scan_ingredients_state.dart';

class ScanIngredientsBloc extends Bloc<ScanIngredientsEvent, ScanIngredientsState> {
  final ScanIngredientsUsecase _usecase;
  ScanIngredientsBloc(this._usecase) : super(ScanIngredientsInitial()) {
    on<GetScanIngredientsEvent>((event, emit) async {
      emit(ScanIngredientsLoading());
      final result = await _usecase.execute(image: event.image, name: event.name);
      result.fold(
        (failure) =>
            emit(ScanIngredientsFailed(message: failure.message)),
        (data) => emit(ScanIngredientsLoaded(data: data)),
      );
    });

    on<ResetScanIngredientsEvent>((event, emit) {
  emit(ScanIngredientsInitial());
});

  }
}

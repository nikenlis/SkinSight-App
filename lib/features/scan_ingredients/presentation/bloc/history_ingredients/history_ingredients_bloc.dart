import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skinsight/features/scan_ingredients/domain/usecases/get_history_scan_ingredients_usecase.dart';

import '../../../domain/entities/history_scan_ingredient_entity.dart';
import '../../../domain/entities/scan_ingredients_entity.dart';
import '../../../domain/usecases/get_detail_history_scan_ingredients_usecase.dart';

part 'history_ingredients_event.dart';
part 'history_ingredients_state.dart';

class HistoryIngredientsBloc
    extends Bloc<HistoryIngredientsEvent, HistoryIngredientsState> {
  final GetHistoryScanIngredientsUsecase _getHistoryScanIngredientsUsecase;
  final GetDetailHistoryScanIngredientsUsecase
      _getDetailHistoryScanIngredientsUsecase;
  HistoryIngredientsBloc(this._getHistoryScanIngredientsUsecase,
      this._getDetailHistoryScanIngredientsUsecase)
      : super(HistoryIngredientsInitial()) {
    on<GetHistoryIngredients>((event, emit) async {
      emit(HistoryIngredientsLoading());
      final result = await _getHistoryScanIngredientsUsecase.execute();
      result.fold(
        (failure) => emit(HistoryIngredientsFailed(message: failure.message)),
        (data) => emit(HistoryIngredientsLoaded(data: data)),
      );
    });

    on<GetDetailHistoryIngredients>((event, emit) async {
      emit(HistoryIngredientsLoading());
      final result =
          await _getDetailHistoryScanIngredientsUsecase.execute(id: event.id);
      result.fold(
         
        (failure) => emit(HistoryIngredientsFailed(message: failure.message)),
        (data) => emit(DetailHistoryIngredientsLoaded(data: data)),
      );
    });
  }
}

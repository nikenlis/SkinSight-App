import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skinsight/features/recomendation_product/domain/usecases/recomendation_product_usecase.dart';

import '../../../product/domain/entities/product_entity.dart';

part 'recomendation_product_event.dart';
part 'recomendation_product_state.dart';

class RecomendationProductBloc
    extends Bloc<RecomendationProductEvent, RecomendationProductState> {
  final RecomendationProductUsecase _usecase;
  RecomendationProductBloc(this._usecase)
      : super(RecomendationProductInitial()) {
    on<GetRecomendationProductEvent>((event, emit) async {
      emit(RecomendationProductLoading());
      final result = await _usecase.execute();

      result.fold(
          (failure) => emit(RecomendationProductFailed(message: failure.message)),
          (data) => emit(RecomendationProductLoaded(data: data)));
    });
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skinsight/features/uv_index/domain/entities/uv_entity.dart';
import 'package:skinsight/features/uv_index/domain/usecases/get_data_uv_usecase.dart';

part 'uv_index_event.dart';
part 'uv_index_state.dart';

class UvIndexBloc extends Bloc<UvIndexEvent, UvIndexState> {
  final GetDataUvUsecase _getDataUvUsecase;
  UvIndexBloc(this._getDataUvUsecase) : super(UvIndexInitial()) {
    on<GetUvIndexEvent>((event, emit) async {
      emit(UvIndexLoading());
      final result = await _getDataUvUsecase.execute(
          latitude: event.latitude, longitude: event.longitude);
      result.fold(
        (failure) {
          emit(UvIndexFailed(message: failure.message));
        },
        (data) {
          print('ADAAA 😈😈😈');
          emit(UvIndexLoaded(data: data));
        },
      );
    });
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skinsight/features/assesment/domain/entities/assesment_entity.dart';
import 'package:skinsight/features/assesment/domain/usecases/get_assesment_usecase.dart';

import '../../domain/entities/assesment_form_entity.dart';

part 'assesment_event.dart';
part 'assesment_state.dart';

class AssesmentBloc extends Bloc<AssesmentEvent, AssesmentState> {
  final GetAssesmentUsecase _getAssesmentUsecase;
  AssesmentFormEntity _currentForm = const AssesmentFormEntity();
  AssesmentBloc(this._getAssesmentUsecase) : super(AssesmentInitial()) {
    on<UpdateFormEvent>((event, emit) {
      _currentForm = _currentForm.copyWith(
        gender: event.form.gender,
        age: event.form.age,
        skinType: event.form.skinType,
        scanImage: event.form.scanImage,
        resetScanImage: event.resetScanImage
      );
      emit(AssesmentUpdated(form: _currentForm));
    });
    on<SubmitFormEvent>((event, emit) async {
      emit(AssesmentLoading());
      final result = await _getAssesmentUsecase.execute(_currentForm);
      result.fold(
        (failure) => emit(AssesmentFailed(message: failure.message)),
        (data) => emit(AssesmentLoaded(data: data)),
      );
    });
    on<SubmitFormWithScanImageEvent>((event, emit) async {
      emit(AssesmentWithScanImageLoading());
      final result = await _getAssesmentUsecase.execute(_currentForm);
      result.fold(
        (failure) =>
            emit(AssesmentWithScanImageFailed(message: failure.message)),
        (data) => emit(AssesmentWithScanImageLoaded(data: data)),
      );
    });
    on<ResetScanImageEvent>((event, emit) {
      _currentForm = _currentForm.copyWith(scanImage: null);
      emit(AssesmentUpdated(form: _currentForm));
    });
  }
}

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skinsight/features/scan_type_skin/domain/entities/scan_image_entity.dart';
import 'package:skinsight/features/scan_type_skin/domain/usecases/get_scan_image_usecase.dart';

part 'scan_image_event.dart';
part 'scan_image_state.dart';

class ScanImageBloc extends Bloc<ScanImageEvent, ScanImageState> {
  final GetScanImageUsecase _usecase;
  ScanImageBloc(this._usecase) : super(ScanImageInitial()) {
    on<GetScanImageEvent>((event, emit) async {
      emit(ScanImageLoading());
      final result = await _usecase.execute(image: event.image);
      result.fold(
        (failure) =>
            emit(ScanImageFailed(message: failure.message)),
        (data) => emit(ScanImageLoaded(data: data)),
      );
    });
  }
}

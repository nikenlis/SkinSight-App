import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skinsight/features/explore/domain/usecases/get_all_education_usecase.dart';
import 'package:skinsight/features/explore/domain/usecases/get_detail_education_usecase.dart';
import '../../../domain/entities/detail_education_entity.dart';
import '../../../domain/entities/education_entity.dart';
part 'education_event.dart';
part 'education_state.dart';

class EducationBloc extends Bloc<EducationEvent, EducationState> {
  final GetAllEducationUsecase _educationUsecase;
  final GetDetailEducationUsecase _detailEducationUsecase;
  int _page = 1;
  String? _prevLink;
  String? _nextLink;
  bool _hasReachedMax = false;
  final List _data = [];
  EducationBloc(this._educationUsecase, this._detailEducationUsecase)
      : super(EducationInitial()) {
    on<GetAllEducation>((event, emit) async {
      if (event.isRefresh) {
        _page = 1;
        _prevLink = null;
        _nextLink = null;
        _hasReachedMax = false;
        _data.clear();
        emit(EducationLoading());
      } else {
        if (_hasReachedMax) return;
        if (state is EducationLoading) return;
      }

      final result = await _educationUsecase.execute(_page,
          prevPage: _prevLink, nextPage: _nextLink);

      result.fold(
        (failure) {
          emit(EducationFailed(message: failure.message));
        },
        (data) {
          if (data.data.isEmpty) {
            _hasReachedMax = true;
          } else {
            _data.addAll(data.data);
            _prevLink = data.prevLink;
            _nextLink = data.nextLink;
            _page++;
          }

          emit(EducationLoaded(
              data: List<EducationEntity>.from(_data),
              hasReachedMax: _hasReachedMax));
        },
      );
    });

    on<GetDetailEducation>((event, emit) async {
      emit(EducationLoading());

      final result =
          await _detailEducationUsecase.execute(articleLink: event.articleLink);

      result.fold(
        (failure) {
          emit(EducationFailed(message: failure.message));
        },
        (data) {
          emit(DetailEducationLoaded(data: data));
        },
      );
    });
  }
}

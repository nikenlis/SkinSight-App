import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:skinsight/features/explore/domain/entities/detail_news_entity.dart';
import 'package:skinsight/features/explore/domain/entities/news_entity.dart';
import 'package:skinsight/features/explore/domain/usecases/get_all_news_usecase.dart';
import 'package:skinsight/features/explore/domain/usecases/get_detail_news_usecase.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetAllNewsUsecase _allNewsUsecase;
  final GetDetailNewsUsecase _detailNewsUsecase;
  int _page = 1;
  bool _hasReachedMax = false;
  final List _data = [];
  NewsBloc(
    this._allNewsUsecase,
    this._detailNewsUsecase,
  ) : super(NewsInitial()) {
    on<GetAllNews>((event, emit) async {
      if (event.isRefresh) {
        _page = 1;
        _hasReachedMax = false;
        _data.clear();
        emit(NewsLoading());
      } else {
        if (_hasReachedMax) return;
        if (state is NewsLoading) return;
      }

      final result = await _allNewsUsecase.execute(_page);

      result.fold(
        (failure) {
          emit(NewsFailed(message: failure.message));
        },
        (data) {
          if (data.isEmpty) {
            _hasReachedMax = true;
          } else {
            _data.addAll(data);
            _page++;
          }
          emit(NewsLoaded(
              data: List<NewsEntity>.from(_data),
              hasReachedMax: _hasReachedMax));
        },
      );
    });

    on<GetDetailNews>((event, emit) async {
      emit(NewsLoading());

      final result =
          await _detailNewsUsecase.execute(articleLink: event.articleLink);

      result.fold(
        (failure) {
          emit(NewsFailed(message: failure.message));
        },
        (data) {
          emit(DetailNewsLoaded(
            data: data,
          ));
        },
      );
    });
  }
}

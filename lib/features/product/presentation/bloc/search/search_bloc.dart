import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:skinsight/features/product/domain/usecases/product_usecase.dart';
import 'package:skinsight/features/product/presentation/bloc/brand/brand_bloc.dart';

import '../../../domain/entities/product_entity.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ProductUsecase _usecase;

  int currentPage = 1;
  bool hasMoreData = true;
  bool isLoadingMore = false;
  String lastQuery = '';
  ScrollController scrollController = ScrollController();

  SearchBloc(
    this._usecase,
  ) : super(SearchInitial()) {
    scrollController.addListener(() {
      if (scrollController.position.extentAfter < 300 && hasMoreData) {
        add(LoadMoreDataEvent(query: lastQuery));
      }
    });

    bool needsMoreData() {
      return scrollController.hasClients &&
          scrollController.position.maxScrollExtent < 500 &&
          hasMoreData;
    }

    void resetPagination() {
      currentPage = 1;
      hasMoreData = true;
      isLoadingMore = false;
    }

    on<GetProductbySearch>((event, emit) async {
      emit(SearchLoading());

      resetPagination();
      lastQuery = event.query;

      final result =
          await _usecase.execute(page: currentPage, search: event.query);
      result.fold(
        (failure) {
          emit(SearchFailed(message: failure.message));
        },
        (data) {
          emit(SearchLoaded(data: data.products));

          if (data.products.isEmpty) {
            hasMoreData = false;
          } else {
            Future.delayed(Duration(milliseconds: 300), () {
              if (needsMoreData()) {
                add(LoadMoreDataEvent(query: lastQuery));
              }
            });
          }
        },
      );
    });

    on<LoadMoreDataEvent>((event, emit) async {
      if (isLoadingMore || !hasMoreData) return;

      isLoadingMore = true;
      currentPage++;

      final result =
          await _usecase.execute(page: currentPage, search: event.query);
      result.fold(
        (failure) {
          emit(SearchFailed(message: failure.message));
        },
        (data) {
          if (data.products.isNotEmpty) {
            final currentState = state as SearchLoaded;
            emit(SearchLoaded(data: [...currentState.data, ...data.products]));

            Future.delayed(Duration(milliseconds: 300), () {
              if (needsMoreData()) {
                add(LoadMoreDataEvent(query: lastQuery));
              }
            });
          } else {
            hasMoreData = false;
          }
        },
      );

      isLoadingMore = false;
    });

    on<GetProductBrandBySearch>((event, emit) async {
      emit(SearchLoading());

      resetPagination();
      lastQuery = event.query;

      final result = await _usecase.execute(
          page: currentPage, brand: event.brand, search: event.query);
      result.fold(
        (failure) {
          emit(SearchFailed(message: failure.message));
        },
        (data) {
          emit(SearchLoaded(data: data.products));

          if (data.products.isEmpty) {
            hasMoreData = false;
          } else {
            Future.delayed(Duration(milliseconds: 300), () {
              if (needsMoreData()) {
                add(LoadMoreDataEvent(query: lastQuery));
              }
            });
          }
        },
      );
    });

    on<LoadMoreDataProductBrandBySearch>((event, emit) async {
      if (isLoadingMore || !hasMoreData) return;

      isLoadingMore = true;
      currentPage++;

      final result = await _usecase.execute(
          page: currentPage, brand: event.brand, search: event.query);
      result.fold(
        (failure) {
          emit(SearchFailed(message: failure.message));
        },
        (data) {
          if (data.products.isNotEmpty) {
            final currentState = state as SearchLoaded;
            emit(SearchLoaded(data: [...currentState.data, ...data.products]));

            Future.delayed(Duration(milliseconds: 300), () {
              if (needsMoreData()) {
                add(LoadMoreDataEvent(query: lastQuery));
              }
            });
          } else {
            hasMoreData = false;
          }
        },
      );

      isLoadingMore = false;
    });
  }
}

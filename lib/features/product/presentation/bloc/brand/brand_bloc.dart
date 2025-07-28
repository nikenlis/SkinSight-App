import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skinsight/features/product/domain/entities/product_entity.dart';

import '../../../domain/entities/category_brand_entity.dart';
import '../../../domain/usecases/product_usecase.dart';

part 'brand_event.dart';
part 'brand_state.dart';

class BrandBloc extends Bloc<BrandEvent, BrandState> {
  final ProductUsecase _usecase;
  int _page = 1;
  bool _hasReachedMax = false;
  final List _products = [];

  BrandBloc(this._usecase) : super(BrandInitial()) {
    on<GetProductbyBrand>((event, emit) async {
      if (event.isRefresh) {
        _page = 1;
        _hasReachedMax = false;
        _products.clear();
        emit(BrandLoading());
      } else {
        if (_hasReachedMax) return;
        if (state is BrandLoading) return;
      }

      final result = await _usecase.execute(brand: event.brand, page: _page);

      result.fold(
        (failure) {

          emit(BrandFailed(message: failure.message));
        },
        (data) {
          if (data.products.isEmpty) {
            _hasReachedMax = true;
          } else {
            _products.addAll(data.products);
            _page++;
          }
          emit(BrandLoaded(
              data: List<ProductEntity>.from(_products),
              hasReachedMax: _hasReachedMax));
        },
      );
    });

  }
}

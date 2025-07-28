import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skinsight/features/product/domain/usecases/product_usecase.dart';

import 'product_state.dart';

part 'product_event.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductUsecase _usecase;

  ProductBloc(this._usecase) : super(const ProductState()) {
    on<GetProductEvent>(_onGetProduct);
  }

  Future<void> _onGetProduct(GetProductEvent event, Emitter<ProductState> emit) async {
  final key = event.type ?? 'All'; // ⬅️ untuk key map
  final currentState = state.getTabState(key);

  if (currentState.hasReachedMax && !event.isRefresh) return;

  emit(state.copyWith(productMap: {
    ...state.productMap,
    key: currentState.copyWith(
      status: ProductFetchStatus.loading,
      page: event.isRefresh ? 1 : currentState.page + 1,
      hasReachedMax: false,
    ),
  }));

  final result = await _usecase.execute(
    type: event.type == 'All' ? null : event.type,
    sort: event.sort,
    page: event.isRefresh ? 1 : currentState.page + 1,
  );

  result.fold(
    (failure) {
      emit(state.copyWith(productMap: {
        ...state.productMap,
        key: currentState.copyWith(
          status: ProductFetchStatus.failure,
          errorMessage: failure.message,
        ),
      }));
    },
    (data) {
      final isNewSort = event.sort != currentState.sort;
      final updatedProducts = event.isRefresh || isNewSort
          ? data.products
          : currentState.products + data.products;

      emit(state.copyWith(productMap: {
        ...state.productMap,
        key: ProductTabState(
          products: updatedProducts,
          page: data.currentPage,
          hasReachedMax: data.currentPage >= data.lastPage || data.products.isEmpty,
          status: ProductFetchStatus.success,
          sort: event.sort ?? currentState.sort,
        ),
      }));
    },
  );
}

}

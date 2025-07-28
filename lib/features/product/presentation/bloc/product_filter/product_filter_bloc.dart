// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:skinsight/features/product/domain/usecases/product_filter_usecase.dart';

import '../../../domain/entities/product_filter_entity.dart';

part 'product_filter_event.dart';
part 'product_filter_state.dart';

class ProductFilterBloc extends Bloc<ProductFilterEvent, ProductFilterState> {
  final ProductFilterUsecase _usecase;
  ProductFilterBloc(
    this._usecase,
  ) : super(ProductFilterInitial()) {
    on<GetProductFilterEvent>((event, emit) async {
      emit(ProductFilterLoading());
      final result = await _usecase.execute();

      result.fold(
          (failure) => emit(ProductFilterFailed(message: failure.message)),
          (data) => emit(ProductFilterLoaded(types: ['All', ...data.types], brands: data.brands)));
    });
  }
}

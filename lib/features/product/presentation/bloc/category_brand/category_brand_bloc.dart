import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/category_brand_entity.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/usecases/category_brand_usecase.dart';
import '../../../domain/usecases/product_by_category_brand_usecase.dart';

part 'category_brand_event.dart';
part 'category_brand_state.dart';

class CategoryBrandBloc extends Bloc<CategoryBrandEvent, CategoryBrandState> {
  final CategoryBrandUsecase _usecaseCategoryBrandUsecase;
  final ProductByCategoryBrandUsecase _productByCategoryBrandUsecase;
  CategoryBrandBloc(
      this._usecaseCategoryBrandUsecase, this._productByCategoryBrandUsecase)
      : super(CategoryBrandInitial()) {
    on<GetCategoryBrand>((event, emit) async {
      emit(CategoryBrandLoading());
      final result =
          await _usecaseCategoryBrandUsecase.execute(brand: event.brand.replaceAll(' ', '-'));
      result.fold(
        (failure) {
          emit(CategoryBrandFailed(message: failure.message));
        },
        (data) {
          emit(CategoryBrandLoaded(data: data));
        },
      );
    });

    on<GetAllProductByCategoryBrand>((event, emit) async {
      emit(CategoryBrandLoading());
      final result = await _productByCategoryBrandUsecase.execute(
          brand: event.brand.replaceAll(' ', '-'), category: event.category.replaceAll(' ', '-'));
      result.fold(
        (failure) {
          emit(CategoryBrandFailed(message: failure.message));
        },
        (data) {
          emit(AllProductByCategoryBrandLoaded(data: data));
        },
      );
    });
  }
}

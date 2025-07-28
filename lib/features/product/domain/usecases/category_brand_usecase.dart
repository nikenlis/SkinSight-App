import 'package:dartz/dartz.dart';
import 'package:skinsight/features/product/domain/repositories/product_repository.dart';

import '../../../../core/error/failures.dart';
import '../entities/category_brand_entity.dart';

class CategoryBrandUsecase {
  final ProductRepository repository;

  CategoryBrandUsecase({required this.repository});

  Future<Either<Failures, List<CategoryBrandEntity>>> execute({required String brand}){
    return repository.getCategoryBrand(brand: brand);
  }
}
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class ProductByCategoryBrandUsecase {
  final ProductRepository repository;

  ProductByCategoryBrandUsecase({required this.repository});

  Future<Either<Failures, List<ProductEntity>>> execute({required String brand, required String category}) {
    return repository.getProductByCategoryBrand(brand: brand, category: category);
  }
}
import 'package:dartz/dartz.dart';
import 'package:skinsight/features/product/domain/repositories/product_repository.dart';

import '../../../../core/error/failures.dart';
import '../entities/product_filter_entity.dart';

class ProductFilterUsecase {
  final ProductRepository repository;

  ProductFilterUsecase({required this.repository});

  Future<Either<Failures, ProductFilterEntity>> execute() {
    return repository.getProductFilter();
  }
}

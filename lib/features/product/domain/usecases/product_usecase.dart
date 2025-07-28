import 'package:dartz/dartz.dart';
import 'package:skinsight/features/product/domain/entities/product_entity.dart';
import 'package:skinsight/features/product/domain/repositories/product_repository.dart';

import '../../../../core/error/failures.dart';

class ProductUsecase {
  final ProductRepository repository;

  ProductUsecase({required this.repository});

  Future<Either<Failures, PaginatedProductResultEntity>> execute({
    int? page,
    String? sort,
    String? type,
    String? brand,
    String? search
  }) {
    return repository.getAllData(
        page: page, sort: sort, type: type, brand: brand, search: search);
  }
}

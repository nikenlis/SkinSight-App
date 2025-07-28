import 'package:dartz/dartz.dart';
import 'package:skinsight/core/error/failures.dart';
import 'package:skinsight/features/product/domain/entities/category_brand_entity.dart';
import 'package:skinsight/features/product/domain/entities/product_entity.dart';

import '../entities/product_filter_entity.dart';

abstract class ProductRepository {
  Future<Either<Failures, PaginatedProductResultEntity>> getAllData({
    int? page,
    String? sort,
    String? type,
    String? brand,
    String? search,
  });

  Future<Either<Failures, ProductFilterEntity>> getProductFilter();

  Future<Either<Failures, List<CategoryBrandEntity>>> getCategoryBrand({required String brand});

  Future<Either<Failures, List<ProductEntity>>> getProductByCategoryBrand({required String brand, required String category});
}

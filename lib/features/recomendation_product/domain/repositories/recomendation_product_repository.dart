import 'package:dartz/dartz.dart';
import 'package:skinsight/features/product/domain/entities/product_entity.dart';

import '../../../../core/error/failures.dart';

abstract class RecomendationProductRepository {
  Future<Either<Failures, List<ProductEntity>>> getRecomendationProduct(); 
}
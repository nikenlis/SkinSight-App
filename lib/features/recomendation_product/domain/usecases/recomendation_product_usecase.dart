import 'package:dartz/dartz.dart';
import 'package:skinsight/features/product/domain/entities/product_entity.dart';
import 'package:skinsight/features/recomendation_product/domain/repositories/recomendation_product_repository.dart';

import '../../../../core/error/failures.dart';

class RecomendationProductUsecase {
  final RecomendationProductRepository repository;

  RecomendationProductUsecase({required this.repository});

  Future<Either<Failures, List<ProductEntity>>> execute (){
    return repository.getRecomendationProduct();
  }

}
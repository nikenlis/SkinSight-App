import 'package:dartz/dartz.dart';
import 'package:skinsight/features/scan_ingredients/domain/entities/scan_ingredients_entity.dart';

import '../../../../core/error/failures.dart';
import '../repositories/scan_ingredients_repository.dart';

class GetDetailHistoryScanIngredientsUsecase {
  final ScanIngredientsRepository repository;

  GetDetailHistoryScanIngredientsUsecase({required this.repository});
  Future<Either<Failures, ScanIngredientsEntity>> execute({required String id}) {
    return repository.getDetailHistoryScanIngredients(id: id);
  }
}

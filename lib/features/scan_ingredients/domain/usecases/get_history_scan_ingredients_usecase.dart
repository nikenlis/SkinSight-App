import 'package:dartz/dartz.dart';
import 'package:skinsight/features/scan_ingredients/domain/entities/history_scan_ingredient_entity.dart';

import '../../../../core/error/failures.dart';
import '../repositories/scan_ingredients_repository.dart';

class GetHistoryScanIngredientsUsecase {
  final ScanIngredientsRepository repository;

  GetHistoryScanIngredientsUsecase({required this.repository});
  Future<Either<Failures, List<HistoryScanIngredientEntity>>> execute() {
    return repository.getHistoryScanIngredients();
  }
}

import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:skinsight/core/error/failures.dart';
import 'package:skinsight/features/scan_ingredients/domain/entities/history_scan_ingredient_entity.dart';
import 'package:skinsight/features/scan_ingredients/domain/entities/scan_ingredients_entity.dart';

abstract class ScanIngredientsRepository {
  Future<Either<Failures, ScanIngredientsEntity>> getScanIngredients({required File image, required String name});
  Future<Either<Failures, List<HistoryScanIngredientEntity>>> getHistoryScanIngredients();
  Future<Either<Failures, ScanIngredientsEntity>> getDetailHistoryScanIngredients({required String id});
}

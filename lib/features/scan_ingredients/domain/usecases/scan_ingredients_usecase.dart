import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:skinsight/core/error/failures.dart';
import 'package:skinsight/features/scan_ingredients/domain/entities/scan_ingredients_entity.dart';
import 'package:skinsight/features/scan_ingredients/domain/repositories/scan_ingredients_repository.dart';

class ScanIngredientsUsecase {
  final ScanIngredientsRepository repository;

  ScanIngredientsUsecase({required this.repository});
  Future<Either<Failures, ScanIngredientsEntity>> execute({required File image, required String name}){
    return repository.getScanIngredients(image: image, name: name);
  }
}
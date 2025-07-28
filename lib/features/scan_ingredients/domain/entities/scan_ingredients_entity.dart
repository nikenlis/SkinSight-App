import 'package:equatable/equatable.dart';

class ScanIngredientsEntity extends Equatable {
  final List<String> extractedIngredients;
  final List<HarmfulIngredientEntity> harmfulIngredientsFound;
  final bool isSafe;
  final int totalHarmfulIngredients;
  final String scanImage;
  final String id;
  final String productName;

  const ScanIngredientsEntity(
      {required this.extractedIngredients,
      required this.harmfulIngredientsFound,
      required this.isSafe,
      required this.totalHarmfulIngredients,
      required this.scanImage,
      required this.id,
      required this.productName
      });

  @override
  List<Object?> get props => [
        extractedIngredients,
        harmfulIngredientsFound,
        isSafe,
        totalHarmfulIngredients,
        scanImage,
        id,
        productName,
      ];
}

class HarmfulIngredientEntity extends Equatable {
  final String name;
  final String reason;

  const HarmfulIngredientEntity({
    required this.name,
    required this.reason,
  });

  @override
  List<Object?> get props => [name, reason];
}

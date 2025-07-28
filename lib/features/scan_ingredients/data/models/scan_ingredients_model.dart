import 'package:skinsight/features/scan_ingredients/domain/entities/scan_ingredients_entity.dart';


class ScanIngredientsModel extends ScanIngredientsEntity {
  const ScanIngredientsModel({
    required super.extractedIngredients,
    required super.harmfulIngredientsFound,
    required super.isSafe,
    required super.totalHarmfulIngredients,
    required super.scanImage,
    required super.id, 
    required super.productName,
  });

  factory ScanIngredientsModel.fromJson(Map<String, dynamic> json) {
    return ScanIngredientsModel(
      extractedIngredients: List<String>.from(json['extractedIngredients'] ?? []),
      harmfulIngredientsFound: (json['harmfulIngredientsFound'] as List<dynamic>?)
              ?.map((e) => HarmfulIngredientModel.fromJson(e))
              .toList() ??
          [],
      isSafe: json['isSafe'] ?? false,
      totalHarmfulIngredients: json['totalHarmfulIngredients'] ?? 0,
      scanImage: json['scanImage'] ?? '',
      id: json['id'] ?? '', 
      productName: json['productName'],
    );
  }


  ScanIngredientsEntity toEntity() {
    return ScanIngredientsEntity(
      extractedIngredients: extractedIngredients,
      harmfulIngredientsFound: harmfulIngredientsFound,
      isSafe: isSafe,
      totalHarmfulIngredients: totalHarmfulIngredients,
      scanImage: scanImage,
      id: id, productName: productName,
    );
  }
}

class HarmfulIngredientModel extends HarmfulIngredientEntity {
  const HarmfulIngredientModel({
    required super.name,
    required super.reason,
  });

  factory HarmfulIngredientModel.fromJson(Map<String, dynamic> json) {
    return HarmfulIngredientModel(
      name: json['name'] as String,
      reason: json['reason'] as String,
    );
  }

  HarmfulIngredientEntity toEntity() {
    return HarmfulIngredientEntity(name: name, reason: reason);
  }
}

import 'package:skinsight/features/scan_ingredients/domain/entities/history_scan_ingredient_entity.dart';

class HistoryScanIngredientsModel extends HistoryScanIngredientEntity {
  const HistoryScanIngredientsModel(
      {required super.id,
      required super.productName,
      required super.scanImage,
      required super.isSafe,
      required super.totalHarmfulIngredients,
      required super.createdAt}
      
      
      
      );

      factory HistoryScanIngredientsModel.fromJson(Map<String, dynamic> json) {
    return HistoryScanIngredientsModel(
      id: json['id'],
      productName: json['productName'],
      scanImage: json['scanImage'],
      isSafe: json['isSafe'] == 1,
      totalHarmfulIngredients: json['totalHarmfulIngredients'],
      createdAt: DateTime.parse(json['createdAt']),
    );


  }


  HistoryScanIngredientsModel toEntity() {
    return HistoryScanIngredientsModel(
      id: id,
      productName: productName,
      scanImage: scanImage,
      isSafe: isSafe,
      totalHarmfulIngredients: totalHarmfulIngredients,
      createdAt: createdAt,
    );
  }
}

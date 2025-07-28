import 'package:equatable/equatable.dart';

class HistoryScanIngredientEntity extends Equatable {
  final String id;
  final String productName;
  final String scanImage;
  final bool isSafe;
  final int totalHarmfulIngredients;
  final DateTime createdAt;

  const HistoryScanIngredientEntity({
    required this.id,
    required this.productName,
    required this.scanImage,
    required this.isSafe,
    required this.totalHarmfulIngredients,
    required this.createdAt,
  });

  @override
  List<Object> get props => [
        id,
        productName,
        scanImage,
        isSafe,
        totalHarmfulIngredients,
        createdAt,
      ];
}

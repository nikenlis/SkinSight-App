import 'package:equatable/equatable.dart';

class RecommendationProductEntity extends Equatable {
  final String id;
  final String title;
  final String price;
  final String description;
  final String imageUrl;
  final String link;
  final String type;
  final String brand;
  final String ingredients;

  const RecommendationProductEntity(
      {required this.id,
      required this.title,
      required this.price,
      required this.description,
      required this.imageUrl,
      required this.link,
      required this.type,
      required this.brand,
      required this.ingredients});

  @override
  List<Object?> get props => [
        id,
        title,
        price,
        description,
        imageUrl,
        link,
        type,
        brand,
        ingredients,
      ];
}

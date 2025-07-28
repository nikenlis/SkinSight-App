import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String title;
  final String price;
  final String description;
  final String imageUrl;
  final String link;
  final String type;
  final String brand;
  final String ingredients;
  final String brandImageUrl;


  const ProductEntity( {
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.link,
    required this.type,
    required this.brand,
    required this.ingredients,
    required this.brandImageUrl
  });

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
        brandImageUrl
      ];
}

class PaginatedProductResultEntity extends Equatable{
  final List<ProductEntity> products;
  final int currentPage;
  final int lastPage;

  const PaginatedProductResultEntity({
    required this.products,
    required this.currentPage,
    required this.lastPage,
  });
  
  @override
  List<Object?> get props => [products, currentPage, lastPage];

}

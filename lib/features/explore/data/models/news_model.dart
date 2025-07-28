import '../../domain/entities/news_entity.dart';

class NewsModel extends NewsEntity {
  const NewsModel({
    required super.title,
    required super.link,
    required super.image,
    required super.date,
    required super.category,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'] as String,
      link: json['link'] as String,
      image: json['image'] as String,
      date: json['date'] as String,
      category: json['category'] as String,
    );
  }


  NewsEntity toEntity() {
    return NewsEntity(
      title: title,
      link: link,
      image: image,
      date: date,
      category: category,
    );
  }
}

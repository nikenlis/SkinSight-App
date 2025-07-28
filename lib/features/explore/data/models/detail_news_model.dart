
import '../../domain/entities/detail_news_entity.dart';

class DetailNewsModel extends DetailNewsEntity {
  const DetailNewsModel({
    required super.title,
    required super.imageUrl,
    required super.date,
    required super.source,
    required super.author,
    required super.content,
  });

  factory DetailNewsModel.fromJson(Map<String, dynamic> json) {
    return DetailNewsModel(
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      date: json['date'] ?? '',
      source: json['source'] ?? '',
      author: json['author'] ?? '',
      content: json['content'] ?? '',
    );
  }

  DetailNewsEntity toEntity() {
    return DetailNewsEntity(
      title: title,
      imageUrl: imageUrl,
      date: date,
      source: source,
      author: author,
      content: content,
    );
  }

}

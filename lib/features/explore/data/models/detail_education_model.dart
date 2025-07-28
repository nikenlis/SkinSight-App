import 'package:skinsight/features/explore/domain/entities/detail_education_entity.dart';

class DetailEducationModel extends DetailEducationEntity{
  const DetailEducationModel({required super.title, required super.author, required super.date, required super.coverImage, required super.content});
  factory DetailEducationModel.fromJson(Map<String, dynamic> json) {
    return DetailEducationModel(
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      date: json['date'] ?? '',
      coverImage: json['coverImage'] ?? '',
      content: json['content'] ?? '',
    );
  }

   DetailEducationEntity toEntity() {
    return DetailEducationEntity(
      title: title,
      author: author,
      date: date,
      coverImage: coverImage,
      content: content,
    );
  }
}
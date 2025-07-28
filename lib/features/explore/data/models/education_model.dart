import 'package:skinsight/features/explore/domain/entities/education_entity.dart';

class PagignationEducationModel extends PagignationEducationEntity {
  const PagignationEducationModel(
      {required super.data, required super.prevLink, required super.nextLink});

  factory PagignationEducationModel.fromJson(Map<String, dynamic> json) {
    final List<EducationModel> educationList = (json['educations'] as List)
        .map((e) => EducationModel.fromJson(e))
        .toList();
    return PagignationEducationModel(
      data: educationList,
      prevLink: json['prevLink'],
      nextLink: json['nextLink'],
    );
  }

  PagignationEducationEntity toEntity() {
    return PagignationEducationEntity(data: data, prevLink: prevLink, nextLink: nextLink);
  }
}

class EducationModel extends EducationEntity {
  const EducationModel({
    required super.title,
    required super.link,
    required super.image,
    required super.snippet,
    required super.date,
    required super.category,
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      title: json['title'] ?? '',
      link: json['link'] ?? '',
      image: json['image'] ?? '',
      snippet: json['snippet'] ?? '',
      date: json['date'] ?? '',
      category: json['category'] ?? '',
    );
  }

  EducationEntity toEntity() {
    return EducationEntity(
      title: title,
      link: link,
      image: image,
      snippet: snippet,
      date: date,
      category: category,
    );
  }
}

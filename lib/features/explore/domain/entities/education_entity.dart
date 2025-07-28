import 'package:equatable/equatable.dart';


class PagignationEducationEntity extends Equatable {
  final List<EducationEntity> data;
  final String prevLink;
  final String nextLink;

  const PagignationEducationEntity({required this.data, required this.prevLink, required this.nextLink});

  @override
  List<Object?> get props => [data, prevLink, nextLink];
}

class EducationEntity extends Equatable {
  final String title;
  final String link;
  final String image;
  final String snippet;
  final String date;
  final String category;

  const EducationEntity({
    required this.title,
    required this.link,
    required this.image,
    required this.snippet,
    required this.date,
    required this.category,
  });

  @override
  List<Object?> get props => [title, link, image, snippet, date, category];
}

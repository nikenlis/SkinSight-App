
import 'package:equatable/equatable.dart';

class DetailEducationEntity extends Equatable {
  final String title;
  final String author;
  final String date;
  final String coverImage;
  final String content;

  const DetailEducationEntity({
    required this.title,
    required this.author,
    required this.date,
    required this.coverImage,
    required this.content,
  });

  @override
  List<Object> get props {
    return [
      title,
      author,
      date,
      coverImage,
      content,
    ];
  }
}

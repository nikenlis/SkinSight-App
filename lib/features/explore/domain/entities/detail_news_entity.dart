import 'package:equatable/equatable.dart';

class DetailNewsEntity extends Equatable{
  final String title;
  final String imageUrl;
  final String date;
  final String source;
  final String author;
  final String content;

  const DetailNewsEntity({
    required this.title,
    required this.imageUrl,
    required this.date,
    required this.source,
    required this.author,
    required this.content,
  });

  @override
  List<Object?> get props => [title, imageUrl, date, source, author, content];
}

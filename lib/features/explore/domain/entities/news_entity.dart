import 'package:equatable/equatable.dart';


class NewsEntity extends Equatable {
  final String title;
  final String link;
  final String image;
  final String date;
  final String category;

  const NewsEntity({
    required this.title,
    required this.link,
    required this.image,
    required this.date,
    required this.category,
  });

  @override
  List<Object> get props => [title, link, image, date, category];
}

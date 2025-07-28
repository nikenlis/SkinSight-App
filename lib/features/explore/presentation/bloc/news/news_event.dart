part of 'news_bloc.dart';

sealed class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object> get props => [];
}


class GetAllNews extends NewsEvent {
  final bool isRefresh;

  const GetAllNews({this.isRefresh = false});
}

class GetDetailNews extends NewsEvent {
  final String articleLink;

  const GetDetailNews({required this.articleLink});
}
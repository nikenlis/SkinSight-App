part of 'news_bloc.dart';

sealed class NewsState extends Equatable {
  const NewsState();
  
  @override
  List<Object> get props => [];
}

final class NewsInitial extends NewsState {}
final class NewsLoading extends NewsState {}
final class NewsFailed extends NewsState {
  final String message;

  const NewsFailed({required this.message});
}
final class NewsLoaded extends NewsState {
  final List<NewsEntity> data;
  final bool hasReachedMax;

  const NewsLoaded({required this.data, this.hasReachedMax = false});

   @override
  List<Object> get props => [data, hasReachedMax];
}

final class DetailNewsLoaded extends NewsState {
  final DetailNewsEntity data;

  const DetailNewsLoaded({required this.data});

   @override
  List<Object> get props => [data];
}

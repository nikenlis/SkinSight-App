part of 'search_bloc.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

final class SearchInitial extends SearchState {}

final class SearchLoading extends SearchState {}

final class SearchFailed extends SearchState {
  final String message;

  const SearchFailed({required this.message});
}


final class SearchLoaded extends SearchState {
   final List<ProductEntity> data;
  
  const SearchLoaded({required this.data});
  @override
  List<Object> get props => [data];
}


final class SearchByBrandLoaded extends SearchState {
   final List<ProductEntity> data;
  
  const SearchByBrandLoaded({required this.data});
  @override
  List<Object> get props => [data];
}

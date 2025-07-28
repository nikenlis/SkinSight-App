part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class GetProductbySearch extends SearchEvent {
  final String query;
  final bool isRefresh;

  const GetProductbySearch({required this.query, this.isRefresh = false});
}


class LoadMoreDataEvent extends SearchEvent {
    final String query;

  LoadMoreDataEvent({required this.query});
}


class GetProductBrandBySearch extends SearchEvent {
  final String query;
  final String brand;
  final bool isRefresh;

  const GetProductBrandBySearch({required this.query, required this.brand, this.isRefresh = false});
}


class LoadMoreDataProductBrandBySearch extends SearchEvent {
    final String query;
    final String brand;

  const LoadMoreDataProductBrandBySearch({required this.query, required this.brand});
}

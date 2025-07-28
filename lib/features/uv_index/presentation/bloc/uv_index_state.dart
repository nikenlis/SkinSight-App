part of 'uv_index_bloc.dart';

abstract class UvIndexState extends Equatable {
  const UvIndexState();  

  @override
  List<Object> get props => [];
}
class UvIndexInitial extends UvIndexState {}
class UvIndexLoading extends UvIndexState {}
class UvIndexFailed extends UvIndexState {
  final String message;

  const UvIndexFailed({required this.message});
}
class UvIndexLoaded extends UvIndexState {
  final UviDataEntity data;

  const UvIndexLoaded({required this.data});
  @override
  List<Object> get props => [data];
}
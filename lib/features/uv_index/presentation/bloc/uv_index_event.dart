part of 'uv_index_bloc.dart';

abstract class UvIndexEvent extends Equatable {
  const UvIndexEvent();

  @override
  List<Object> get props => [];
}

class GetUvIndexEvent extends UvIndexEvent {
  final double latitude;
  final double longitude;

  const GetUvIndexEvent({required this.latitude, required this.longitude});
}

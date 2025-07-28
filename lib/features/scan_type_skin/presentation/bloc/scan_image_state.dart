part of 'scan_image_bloc.dart';

sealed class ScanImageState extends Equatable {
  const ScanImageState();
  
  @override
  List<Object> get props => [];
}

final class ScanImageInitial extends ScanImageState {}
final class ScanImageLoading extends ScanImageState {}
final class ScanImageFailed extends ScanImageState {
  final String message;

  const ScanImageFailed({required this.message});
}
final class ScanImageLoaded extends ScanImageState {
  final ScanImageEntity data;

  const ScanImageLoaded({required this.data});
}
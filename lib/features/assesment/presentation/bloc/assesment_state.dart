part of 'assesment_bloc.dart';

sealed class AssesmentState extends Equatable {
  const AssesmentState();
  
  @override
  List<Object> get props => [];
}

final class AssesmentInitial extends AssesmentState {}
final class AssesmentLoading extends AssesmentState {}
final class AssesmentFailed extends AssesmentState {
  final String message;

  const AssesmentFailed({required this.message});
}
final class AssesmentLoaded extends AssesmentState {
  final AssesmentEntity data;

  const AssesmentLoaded({required this.data});
}
final class AssesmentWithScanImageLoaded extends AssesmentState {
  final AssesmentEntity data;

  const AssesmentWithScanImageLoaded({required this.data});
}
final class AssesmentWithScanImageLoading extends AssesmentState {}
final class AssesmentWithScanImageFailed extends AssesmentState {
  final String message;

  const AssesmentWithScanImageFailed({required this.message});
}
final class AssesmentUpdated extends AssesmentState {
  final AssesmentFormEntity form;

  const AssesmentUpdated({required this.form});
}
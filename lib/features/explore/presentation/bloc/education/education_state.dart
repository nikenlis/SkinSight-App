part of 'education_bloc.dart';

sealed class EducationState extends Equatable {
  const EducationState();

  @override
  List<Object> get props => [];
}

final class EducationInitial extends EducationState {}

final class EducationLoading extends EducationState {}

final class EducationFailed extends EducationState {
  final String message;

  const EducationFailed({required this.message});
}

final class EducationLoaded extends EducationState {
  final List<EducationEntity> data;
  final bool hasReachedMax;

  const EducationLoaded({required this.data, required this.hasReachedMax});

  @override
  List<Object> get props => [data, hasReachedMax];
}


final class DetailEducationLoaded extends EducationState {
  final DetailEducationEntity data;

  const DetailEducationLoaded({required this.data});

  @override
  List<Object> get props => [data];
}

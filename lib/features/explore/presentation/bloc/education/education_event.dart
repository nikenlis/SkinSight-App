part of 'education_bloc.dart';

sealed class EducationEvent extends Equatable {
  const EducationEvent();

  @override
  List<Object> get props => [];
}

class GetAllEducation extends EducationEvent {
  final bool isRefresh;

  const GetAllEducation({this.isRefresh = false});
}

class GetDetailEducation extends EducationEvent {
  final String articleLink;

  const GetDetailEducation({required this.articleLink});
}

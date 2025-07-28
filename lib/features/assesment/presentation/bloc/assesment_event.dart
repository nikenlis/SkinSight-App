part of 'assesment_bloc.dart';

sealed class AssesmentEvent extends Equatable {
  const AssesmentEvent();

  @override
  List<Object> get props => [];
}

class UpdateFormEvent extends AssesmentEvent {
  final AssesmentFormEntity form;
  final bool resetScanImage;
  const UpdateFormEvent(this.form, {this.resetScanImage = false});
}

class SubmitFormEvent extends AssesmentEvent {}
class SubmitFormWithScanImageEvent extends AssesmentEvent {}
class ResetScanImageEvent extends AssesmentEvent {}
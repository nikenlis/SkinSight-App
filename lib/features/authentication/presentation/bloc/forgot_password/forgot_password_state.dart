part of 'forgot_password_bloc.dart';

sealed class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object> get props => [];
}

final class ForgotPasswordInitial extends ForgotPasswordState {}

final class ForgotPasswordLoading extends ForgotPasswordState {}

final class ForgotPasswordFailed extends ForgotPasswordState {
  final String message;

  const ForgotPasswordFailed({required this.message});
}

final class GenerateOtpForgotPasswordLoaded extends ForgotPasswordState {
  final String data;

  const GenerateOtpForgotPasswordLoaded({required this.data});
}

class VerifyOtpForgotPasswordLoading extends ForgotPasswordState {}
final class VerifyOtpForgotPasswordLoaded extends ForgotPasswordState {
  final VerifyOtpForgotPasswordEntity data;

  const VerifyOtpForgotPasswordLoaded({required this.data});
  @override
  List<Object> get props => [data];
}


class RequestNewOtpForgotPasswordLoaded extends ForgotPasswordState {
  final String data;

  const RequestNewOtpForgotPasswordLoaded({required this.data});

 

  @override
  List<Object> get props => [data];

}

final class ResetPasswordForgotPasswordLoaded extends ForgotPasswordState {
  final String data;

  const ResetPasswordForgotPasswordLoaded({required this.data});
  @override
  List<Object> get props => [data];
}




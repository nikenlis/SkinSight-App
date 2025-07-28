part of 'forgot_password_bloc.dart';

sealed class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object> get props => [];
}

class GenerateOtpForgotPassword extends ForgotPasswordEvent {
  final String email;

  const GenerateOtpForgotPassword({required this.email});
}

class VerifyOtpForgotPassword extends ForgotPasswordEvent {
  final String email;
  final String otp;

  const VerifyOtpForgotPassword({required this.email, required this.otp});
}

class RequestNewOtpForgotPassword extends ForgotPasswordEvent {
  final String email;

  const RequestNewOtpForgotPassword({required this.email});
}

class ResetPasswordForgotPassword extends ForgotPasswordEvent {
  final String token;
  final String newPassword;
  final String confirmPassword;

  const ResetPasswordForgotPassword(
      {required this.token,
      required this.newPassword,
      required this.confirmPassword});
}

class ForgotPasswordResetEvent extends ForgotPasswordEvent {}

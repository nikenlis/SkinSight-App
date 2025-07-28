part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class GetSignupEvent extends AuthenticationEvent {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  const GetSignupEvent(
      {required this.name,
      required this.email,
      required this.password,
      required this.confirmPassword});
}

class GetSigninEvent extends AuthenticationEvent {
  final String email;
  final String password;

  const GetSigninEvent({required this.email, required this.password});
}

class AuthCheckCredential extends AuthenticationEvent {}

class AuthVerifyOtp extends AuthenticationEvent {
  final String otp;

  const AuthVerifyOtp({required this.otp});
}

class AuthRequestNewOtp extends AuthenticationEvent {}
class AuthLogoutEvent extends AuthenticationEvent {}

class AuthReset extends AuthenticationEvent {}

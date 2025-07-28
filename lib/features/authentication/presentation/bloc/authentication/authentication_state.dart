part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();  

  @override
  List<Object> get props => [];
}
class AuthenticationInitial extends AuthenticationState {}
class AuthenticationLoading extends AuthenticationState {}
class AuthenticationFailed extends AuthenticationState {
  final String message;

  const AuthenticationFailed({required this.message});

}
class AuthenticationLoaded extends AuthenticationState {
  final AuthEntity data;

  const AuthenticationLoaded({required this.data});
}


class AuthenticationCheckCredentialLoaded extends AuthenticationState {}

class AuthenticationVerifyOtpLoaded extends AuthenticationState {
  final AuthVerifyOtpEntity data;

  const AuthenticationVerifyOtpLoaded({required this.data});

  @override
  List<Object> get props => [data];

}

class AuthenticationVerifyOtpLoading extends AuthenticationState {}


class AuthenticationRequestNewOtpLoaded extends AuthenticationState {
  final String data;

  const AuthenticationRequestNewOtpLoaded({required this.data});

  @override
  List<Object> get props => [data];

}



class AuthenticationLogoutLoading extends AuthenticationState {}

class AuthenticationLogoutLoaded extends AuthenticationState {
  final Unit data;

  const AuthenticationLogoutLoaded({required this.data});
}
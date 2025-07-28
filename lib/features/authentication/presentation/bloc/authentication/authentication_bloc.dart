import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:skinsight/features/authentication/domain/entities/auth_verify_otp_entity.dart';
import 'package:skinsight/features/authentication/domain/usecases/check_credential_usecase.dart';
import 'package:skinsight/features/authentication/domain/usecases/get_signup_usecase.dart';
import 'package:skinsight/features/authentication/domain/usecases/get_verify_otp_usecase.dart';
import 'package:skinsight/features/authentication/domain/usecases/logout_usecase.dart';

import '../../../domain/entities/auth_entity.dart';
import '../../../domain/usecases/get_signin_usecase.dart';
import '../../../domain/usecases/request_new_otp_usecase.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final GetSigninUsecase _getSigninUsecase;
  final GetSignupUsecase _getSignupUsecase;
  final CheckCredentialUsecase _checkCredentialUsecase;
  final GetVerifyOtpUsecase _getVerifyOtpUsecase;
  final RequestNewOtpUsecase _requestNewOtpUsecase;
  final LogoutUsecase _logoutUsecase;
  String email = '';
  AuthenticationBloc(
      this._getSigninUsecase,
      this._getSignupUsecase,
      this._checkCredentialUsecase,
      this._logoutUsecase,
      this._getVerifyOtpUsecase,
      this._requestNewOtpUsecase)
      : super(AuthenticationInitial()) {
    on<GetSignupEvent>((event, emit) async {
      emit(AuthenticationLoading());
      final result = await _getSignupUsecase.execute(
          name: event.name,
          email: event.email,
          password: event.password,
          confirmPassword: event.confirmPassword);

      result.fold(
          (failure) => emit(AuthenticationFailed(message: failure.message)),
          (data) {
        return emit(AuthenticationLoaded(data: data));
      });
    });

    on<GetSigninEvent>((event, emit) async {
      emit(AuthenticationLoading());
      final result = await _getSigninUsecase.execute(
          email: event.email, password: event.password);

      result.fold(
          (failure) => emit(AuthenticationFailed(message: failure.message)),
          (data) => emit(AuthenticationLoaded(data: data)));
    });

    on<AuthCheckCredential>((event, emit) async {
      emit(AuthenticationLoading());
      final result = await _checkCredentialUsecase.execute();

      result.fold(
          (failure) => emit(AuthenticationFailed(message: failure.message)),
          (data) => emit(AuthenticationCheckCredentialLoaded()));
    });

    on<AuthVerifyOtp>((event, emit) async {
      emit(AuthenticationLoading());
      final result = await _getVerifyOtpUsecase.execute(otp: event.otp);

      result.fold(
          (failure) => emit(AuthenticationFailed(message: failure.message)),
          (data) => emit(AuthenticationVerifyOtpLoaded(data: data)));
    });

    on<AuthRequestNewOtp>((event, emit) async {
      emit(AuthenticationVerifyOtpLoading());
      final result = await _requestNewOtpUsecase.execute();

      result.fold(
          (failure) => emit(AuthenticationFailed(message: failure.message)),
          (data) => emit(AuthenticationRequestNewOtpLoaded(data: data)));
    });

    on<AuthLogoutEvent>((event, emit) async {
      emit(AuthenticationLogoutLoading());
      final result = await _logoutUsecase.execute();
      result.fold(
          (failure) => emit(AuthenticationFailed(message: failure.message)),
          (data) => emit(AuthenticationLogoutLoaded(data: data)));
    });

    on<AuthReset>((event, emit) async {
      emit(AuthenticationInitial());
    });
  }
}

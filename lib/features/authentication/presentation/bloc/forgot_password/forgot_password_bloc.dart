import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skinsight/features/authentication/domain/entities/verify_otp_forgot_password_entity.dart';
import 'package:skinsight/features/authentication/domain/usecases/fogot_password/request_new_otp_forgot_password_usecase.dart';
import 'package:skinsight/features/authentication/domain/usecases/fogot_password/reset_password_forgot_password_usecase.dart';
import 'package:skinsight/features/authentication/domain/usecases/fogot_password/verify_otp_forgot_password_usecase.dart';

import '../../../domain/usecases/fogot_password/generate_otp_forgot_password_usecase.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final GenerateOtpForgotPasswordUsecase _generateOtpForgotPasswordUsecase;
  final VerifyOtpForgotPasswordUsecase _verifyOtpForgotPasswordUsecase;
  final RequestNewOtpForgotPasswordUsecase _requestNewOtpForgotPasswordUsecase;
  final ResetPasswordForgotPasswordUsecase _resetPasswordForgotPasswordUsecase;
  ForgotPasswordBloc(
      this._generateOtpForgotPasswordUsecase,
      this._verifyOtpForgotPasswordUsecase,
      this._resetPasswordForgotPasswordUsecase, this._requestNewOtpForgotPasswordUsecase)
      : super(ForgotPasswordInitial()) {
    on<GenerateOtpForgotPassword>((event, emit) async {
      emit(ForgotPasswordLoading());
      final result =
          await _generateOtpForgotPasswordUsecase.execute(email: event.email);

      result.fold(
          (failure) => emit(ForgotPasswordFailed(message: failure.message)),
          (data) => emit(GenerateOtpForgotPasswordLoaded(data: data)));
    });

    on<VerifyOtpForgotPassword>((event, emit) async {
      emit(ForgotPasswordLoading());
      final result = await _verifyOtpForgotPasswordUsecase.execute(
          email: event.email, otp: event.otp);

      result.fold(
          (failure) => emit(ForgotPasswordFailed(message: failure.message)),
          (data) => emit(VerifyOtpForgotPasswordLoaded(data: data)));
    });

    on<RequestNewOtpForgotPassword>((event, emit) async {
      emit(VerifyOtpForgotPasswordLoading());
      final result = await _requestNewOtpForgotPasswordUsecase.execute(email: event.email);

      result.fold(
          (failure) => emit(ForgotPasswordFailed(message: failure.message)),
          (data) => emit(RequestNewOtpForgotPasswordLoaded(data: data)));
    });

    on<ResetPasswordForgotPassword>((event, emit) async {
      emit(ForgotPasswordLoading());
      final result = await _resetPasswordForgotPasswordUsecase.execute(
          token: event.token,
          newPassword: event.newPassword,
          confirmPassword: event.confirmPassword);

      result.fold(
          (failure) => emit(ForgotPasswordFailed(message: failure.message)),
          (data) => emit(ResetPasswordForgotPasswordLoaded(data: data)));
    });


    on<ForgotPasswordResetEvent>((event, emit) async {
      emit(ForgotPasswordInitial());
    });
  }
}

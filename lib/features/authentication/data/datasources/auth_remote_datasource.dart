import 'package:dartz/dartz.dart';
import 'package:skinsight/features/authentication/data/models/auth_model.dart';
import 'package:skinsight/features/authentication/data/models/verify_otp_forgot_password_model.dart';

import '../../../../core/api/api_client.dart';
import '../models/auth_verify_otp_model.dart';

abstract class AuthRemoteDatasource {
  Future<AuthModel> signUp({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  });
  Future<AuthModel> signIn({
    required String email,
    required String password,
  });
  Future<AuthVerifyOtpModel> verifyOtp({required String otp});
  Future<String> requestNewOtp();

  Future<String> generateOtpForgotPassword({required String email});
  Future<VerifyOtpForgotPasswordModel> verifyOtpForgotPassword(
      {required String email, required String otp});
  Future<String> requestNewOtpForgotPassword({required String email});
  Future<String> resetPasswordForgotPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  });
  Future<Unit> logout();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final ApiClient apiClient;

  AuthRemoteDatasourceImpl({required this.apiClient});

  @override
  Future<AuthModel> signIn(
      {required String email, required String password}) async {
    final response = await ApiClient.post<AuthModel>(
        endpoint: '/auth/login',
        headers: await ApiClient.getHeaders(requireAuth: false),
        body: {
          'email': email,
          'password': password,
        },
        parser: (json) => AuthModel.fromJson(json['data']));
    return response;
  }

  @override
  Future<AuthModel> signUp(
      {required String name,
      required String email,
      required String password,
      required String confirmPassword}) async {
    final response = await ApiClient.post<AuthModel>(
      endpoint: '/auth/register',
      headers: await ApiClient.getHeaders(requireAuth: false),
      body: {
        'fullName': name,
        'email': email,
        'password': password,
        "confirmPassword": confirmPassword
      },
      parser: (json) => AuthModel.fromJson(json['data']),
    );

    return response;
  }

  @override
  Future<AuthVerifyOtpModel> verifyOtp({required String otp}) async {
    final response = await ApiClient.post<AuthVerifyOtpModel>(
      endpoint: '/otp/verify',
      headers: await ApiClient.getHeaders(requireAuth: true),
      body: {
        'otp': otp,
      },
      parser: (json) => AuthVerifyOtpModel.fromJson(json['data']),
    );
    return response;
  }

  @override
  Future<String> requestNewOtp() async {
    final response = await ApiClient.post<String>(
      endpoint: '/otp/new',
      body: {},
      headers: await ApiClient.getHeaders(requireAuth: true),
      parser: (json) => json['message'] as String,
    );
    return response;
  }

  @override
  Future<Unit> logout() async {
    final response = await ApiClient.post<Unit>(
      endpoint: '/auth/logout',
      body: {},
      headers: await ApiClient.getHeaders(requireAuth: true),
      parser: (_) => unit,
    );
    return response;
  }

  @override
  Future<String> generateOtpForgotPassword({required String email}) async {
    final response = await ApiClient.post<String>(
      endpoint: '/forgot-password/generate-otp',
      body: {"email": email},
      headers: await ApiClient.getHeaders(requireAuth: true),
      parser: (json) => json['message'] as String,
    );
    return response;
  }

  @override
  Future<VerifyOtpForgotPasswordModel> verifyOtpForgotPassword(
      {required String email, required String otp}) async {
    final response = await ApiClient.post<VerifyOtpForgotPasswordModel>(
      endpoint: '/forgot-password/verify-otp',
      body: {"email": email, "otp": otp},
      headers: await ApiClient.getHeaders(requireAuth: true),
      parser: (json) => VerifyOtpForgotPasswordModel.fromJson(json['data']),
    );
    return response;
  }

  @override
  Future<String> resetPasswordForgotPassword(
      {required String token,
      required String newPassword,
      required String confirmPassword}) async {
    final response = await ApiClient.post<String>(
      endpoint: '/forgot-password/reset-password',
      body: {
        "token": token,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword
      },
      headers: await ApiClient.getHeaders(requireAuth: true),
      parser: (json) => json['message'] as String,
    );
    return response;
  }
  
  @override
  Future<String> requestNewOtpForgotPassword({required String email}) async {
     final response = await ApiClient.post<String>(
      endpoint: '/forgot-password/resend-otp',
      body: {
        "email": email
      },
      headers: await ApiClient.getHeaders(requireAuth: true),
      parser: (json) => json['message'] as String,
    );
    return response;
  }
}

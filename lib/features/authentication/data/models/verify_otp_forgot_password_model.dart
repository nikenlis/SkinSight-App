import 'package:skinsight/features/authentication/domain/entities/verify_otp_forgot_password_entity.dart';

class VerifyOtpForgotPasswordModel extends VerifyOtpForgotPasswordEntity{
  VerifyOtpForgotPasswordModel({required super.isValid, required super.statusOtp, required super.token});

  factory VerifyOtpForgotPasswordModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpForgotPasswordModel(
      isValid: json['isValid'] as bool,
      statusOtp: json['statusOtp'] as String,
      token: json['token'] as String,
    );
  }


  VerifyOtpForgotPasswordEntity toEntity() {
    return VerifyOtpForgotPasswordEntity(
      isValid: isValid,
      statusOtp: statusOtp,
      token: token,
    );
  }
}
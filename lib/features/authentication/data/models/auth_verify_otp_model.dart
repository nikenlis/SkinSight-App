import 'package:skinsight/features/authentication/domain/entities/auth_verify_otp_entity.dart';

class AuthVerifyOtpModel extends AuthVerifyOtpEntity {
  const AuthVerifyOtpModel({required super.isValid, required super.statusOtp});
  factory AuthVerifyOtpModel.fromJson(Map<String, dynamic> json) {
    return AuthVerifyOtpModel(
      isValid: json['isValid'] as bool,
      statusOtp: json['statusOtp'] as String,
    );
  }

  AuthVerifyOtpEntity toEntity () => AuthVerifyOtpEntity(isValid: isValid, statusOtp: statusOtp);
}

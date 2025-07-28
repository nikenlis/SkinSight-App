
import 'package:equatable/equatable.dart';

class VerifyOtpForgotPasswordEntity extends Equatable {
  final bool isValid;
  final String statusOtp;
  final String token;

  const VerifyOtpForgotPasswordEntity({
    required this.isValid,
    required this.statusOtp,
    required this.token,
  });

  @override
  List<Object> get props => [isValid, statusOtp, token];
}

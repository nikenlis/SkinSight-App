import 'package:equatable/equatable.dart';

class AuthVerifyOtpEntity extends Equatable{
  final bool isValid;
  final String statusOtp;

  const AuthVerifyOtpEntity({required this.isValid, required this.statusOtp});
  @override
  List<Object?> get props => [isValid, statusOtp];


}
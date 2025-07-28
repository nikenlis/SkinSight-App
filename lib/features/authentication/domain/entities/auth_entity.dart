import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable{
  final String token;
  final bool isAssessmentCompleted;
  final bool isVerified;

  const AuthEntity(  {
    required this.token,
    required this.isAssessmentCompleted,
    required this.isVerified,

  });

  @override
  List<Object?> get props => [
        token, isAssessmentCompleted, isVerified
      ];
}


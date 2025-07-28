import '../../domain/entities/auth_entity.dart';

class AuthModel extends AuthEntity {
  const AuthModel({
    required super.token,
    required super.isAssessmentCompleted, 
    required super.isVerified,
    
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      token: json['token']['token'] ?? '',
      isAssessmentCompleted: json['user']['isAssessmentCompleted'] ?? false,
      isVerified: json['user']['isVerified'] ?? false,
    );
  }

  AuthEntity toEntity() => AuthEntity(
        token: token, isAssessmentCompleted: isAssessmentCompleted, isVerified: isVerified
      );
}

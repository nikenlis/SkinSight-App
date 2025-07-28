import 'package:skinsight/features/profile/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel(
      {required super.fullName,
      required super.email,
      required super.profilePicture,
      required super.gender,
      required super.age,
      required super.skinType,
      required super.isVerified,
      required super.hasPassword,
      required super.isAssessmentCompleted});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final userDetail = json['userDetail'];
    return ProfileModel(
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      profilePicture: json['profilePicture'],
      gender: userDetail != null ? userDetail['gender'] : null,
      age: userDetail != null ? userDetail['age'] : null,
      skinType: userDetail != null ? userDetail['skinType'] : null,
      isVerified: json['isVerified'] ?? false,
      hasPassword: json['hasPassword'] ?? false,
      isAssessmentCompleted: json['isAssessmentCompleted'] ?? false,
    );
  }

  ProfileEntity toEntity() => ProfileEntity(
      fullName: fullName,
      email: email,
      profilePicture: profilePicture,
      gender: gender,
      age: age,
      skinType: skinType,
      isVerified: isVerified,
      hasPassword: hasPassword,
      isAssessmentCompleted: isAssessmentCompleted);
}

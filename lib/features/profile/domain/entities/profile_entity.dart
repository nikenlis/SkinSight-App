import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String fullName;
  final String email;
  final String? profilePicture;
  final String? gender;
  final int? age;
  final String? skinType;
  final bool isVerified;
  final bool hasPassword;
  final bool isAssessmentCompleted;

  const ProfileEntity(
      {required this.fullName,
      required this.email,
      required this.profilePicture,
      required this.gender,
      required this.age,
      required this.skinType,
      required this.isVerified,
      required this.hasPassword,
      required this.isAssessmentCompleted});

  @override
  List<Object?> get props {
    return [
      fullName,
      email,
      profilePicture,
      gender,
      age,
      skinType,
      isVerified,
      hasPassword,
      isAssessmentCompleted,
    ];
  }
}

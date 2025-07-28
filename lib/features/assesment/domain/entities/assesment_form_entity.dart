import 'dart:io';
import 'package:equatable/equatable.dart';

class AssesmentFormEntity extends Equatable {
  final String? gender;
  final int? age;
  final String? skinType;
  final File? scanImage;

  const AssesmentFormEntity({
    this.gender,
    this.age,
    this.skinType,
    this.scanImage,
  });

  AssesmentFormEntity copyWith({
    String? gender,
    int? age,
    String? skinType,
    File? scanImage,
    bool resetScanImage = false,
  }) {
    return AssesmentFormEntity(
      gender: gender ?? this.gender,
      age: age ?? this.age,
      skinType: skinType ?? this.skinType,
      scanImage: resetScanImage ? null : scanImage ?? this.scanImage,
    );
  }

  @override
  List<Object?> get props => [gender, age, skinType, scanImage];
}

import 'package:equatable/equatable.dart';

class AssesmentEntity extends Equatable {
  final String gender;
  final int age;
  final String? skinType;
  final double? dry;
  final double? oily;
  final double? normal;
  final String? predictedLabel;

  const AssesmentEntity({
    required this.gender,
    required this.age,
    required this.skinType,
    required this.dry,
    required this.oily,
    required this.normal,
    required this.predictedLabel,
  });

  @override
  List<Object?> get props => [gender, age, skinType, dry, oily, normal, predictedLabel];
}

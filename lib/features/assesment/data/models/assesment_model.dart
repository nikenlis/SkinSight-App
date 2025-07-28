import '../../domain/entities/assesment_entity.dart';

class AssesmentModel extends AssesmentEntity {
  const AssesmentModel(
      {required super.gender,
      required super.age,
      required super.skinType,
      required super.dry,
      required super.oily,
      required super.normal,
      required super.predictedLabel});

  factory AssesmentModel.fromJson(Map<String, dynamic> json) {
    final scanResult = json['data']['scanResult'];

    return AssesmentModel(
      gender: json['data']['assessmentData']['gender'],
      age: json['data']['assessmentData']['age'],
      skinType: json['data']['assessmentData']['skinType'],
      dry: scanResult != null ? scanResult['dry'] : null,
      oily: scanResult != null ? scanResult['oily'] : null,
      normal: scanResult != null ? scanResult['normal'] : null,
      predictedLabel: scanResult != null ? scanResult['predicted_label'] : null, 
    );
  }

  AssesmentEntity toEntity() {
    return AssesmentEntity(
      gender: gender,
      age: age,
      skinType: skinType,
      dry: dry,
      oily: oily,
      normal: normal,
      predictedLabel: predictedLabel
    );
  }
}

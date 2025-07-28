import 'package:skinsight/features/scan_type_skin/domain/entities/scan_image_entity.dart';

class ScanImageModel extends ScanImageEntity {
  const ScanImageModel(
      {required super.dry,
      required super.normal,
      required super.oily,
      required super.predictedLabel});

    factory ScanImageModel.fromJson(Map<String, dynamic> json) {
    return ScanImageModel(
      dry: json['dry'],
      normal: json['normal'],
      oily: json['oily'],
      predictedLabel: json['predicted_label'],
    );
  }

    ScanImageEntity toEntity() => ScanImageEntity(
        dry: dry,
        normal: normal,
        oily: oily,
        predictedLabel: predictedLabel,
      );

}

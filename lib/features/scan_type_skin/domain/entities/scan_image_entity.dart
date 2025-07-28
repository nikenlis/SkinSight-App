import 'package:equatable/equatable.dart';

class ScanImageEntity extends Equatable{
  final double dry;
  final double normal;
  final double oily;
  final String predictedLabel;

  const ScanImageEntity({required this.dry, required this.normal, required this.oily, required this.predictedLabel});
  
  @override
  List<Object> get props => [dry, normal, oily, predictedLabel];


}
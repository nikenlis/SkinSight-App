import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:skinsight/features/scan_type_skin/domain/entities/scan_image_entity.dart';

import '../../../../core/error/failures.dart';

abstract class ScanImageRepository {
  Future<Either<Failures, ScanImageEntity>> getScanImage(
      {required File image});
}
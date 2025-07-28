import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:skinsight/features/scan_type_skin/domain/repositories/scan_image_repository.dart';

import '../../../../core/error/failures.dart';
import '../entities/scan_image_entity.dart';

class GetScanImageUsecase {
  final ScanImageRepository repository;

  GetScanImageUsecase({required this.repository});

  Future<Either<Failures, ScanImageEntity>> execute ({required File image}) {
    return repository.getScanImage(image: image);
  }

}
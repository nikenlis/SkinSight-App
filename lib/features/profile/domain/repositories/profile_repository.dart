import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:skinsight/features/profile/domain/entities/profile_entity.dart';

import '../../../../core/error/failures.dart';

abstract class ProfileRepository {
Future<Either<Failures, ProfileEntity>> getProfile();
Future<Either<Failures, ProfileEntity>> updateProfile({String? fullName, File? profilePicture});
Future<Either<Failures, String>> changePasswordProfile({required String? currentPassword, required String newPassword, required String confirmPassword});
}
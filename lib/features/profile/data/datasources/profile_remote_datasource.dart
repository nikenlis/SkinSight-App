import 'dart:io';

import 'package:skinsight/features/profile/data/models/profile_model.dart';
import '../../../../core/api/api_client.dart';

abstract class ProfileRemoteDatasource {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile({String? fullName, File? profilePicture});
  Future<String> changePasswordProfile(
      {required String? currentPassword,
      required String newPassword,
      required String confirmPassword});
}

class ProfileRemoteDatasourceImpl implements ProfileRemoteDatasource {
  @override
  Future<ProfileModel> getProfile() async {
    final response = await ApiClient.get<ProfileModel>(
        endpoint: "/user/profile",
        headers: await ApiClient.getHeaders(),
        parser: (json) => ProfileModel.fromJson(json['data']));
    return response;
  }

  @override
  Future<ProfileModel> updateProfile(
      {String? fullName, File? profilePicture}) async {
    final Map<String, String> fields = {};
    if (fullName != null) {
      fields['fullName'] = fullName;
    }

    if (profilePicture != null) {
      return await ApiClient.putMultipart<ProfileModel>(
        endpoint: '/user/profile',
        fields: fields,
        file: profilePicture,
        fileFieldName: 'profilePicture',
        parser: (json) => ProfileModel.fromJson(json),
      );
    } else {
      return await ApiClient.put<ProfileModel>(
        endpoint: '/user/profile',
        headers: await ApiClient.getHeaders(),
        body: fields,
        parser: (json) => ProfileModel.fromJson(json),
      );
    }
  }

  @override
  Future<String> changePasswordProfile(
      {required String? currentPassword,
      required String newPassword,
      required String confirmPassword}) async {
    final response = await ApiClient.post<String>(
      endpoint: '/user/change-password',
      body: {
        "currentPassword":
            currentPassword, 
        "newPassword": newPassword,
        "confirmPassword": confirmPassword
      },
      headers: await ApiClient.getHeaders(requireAuth: true),
      parser: (json) => json['message'] as String,
    );
    return response;
  }
}

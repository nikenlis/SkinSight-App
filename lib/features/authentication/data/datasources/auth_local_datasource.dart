import 'package:shared_preferences/shared_preferences.dart';
const cacheTokenKey = 'token';
const cacheAssesmentStatusKey = 'assesmentStatus';
const cacheVerifyOtpStatusKey = 'verifyOtpStatus';

abstract class AuthLocalDatasource {
  Future<String> getToken();
  Future<bool> cachedToken(String token);
  Future<void> removeToken();

  Future<bool> getAssesmentStatus();
  Future<bool> cachedAssesmentStatus(bool assesmentStatus);

  Future<bool> cachedVerifyOtpStatus(bool otpStatus);
  Future<bool> geOtpStatus();
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final SharedPreferences pref;

  AuthLocalDatasourceImpl({required this.pref});

  @override
  Future<bool> cachedToken(String token) {
    return pref.setString(cacheTokenKey, token);
  }

  @override
  Future<String> getToken() async {
   String? token = pref.getString(cacheTokenKey);
    if (token != null) {
      return token;
    } else {
      throw Exception('Token tidak ditemukan di cache');
    }
  }

  @override
  Future<void> removeToken() async {
    await pref.remove(cacheTokenKey);
    await pref.remove(cacheAssesmentStatusKey);
    await pref.remove(cacheVerifyOtpStatusKey);
  }
  
  @override
  Future<bool> cachedAssesmentStatus(bool assesmentStatus) {
    return pref.setBool(cacheAssesmentStatusKey, assesmentStatus);
  }
  
  @override
  Future<bool> getAssesmentStatus() async {
    bool? assesmentStatus = pref.getBool(cacheAssesmentStatusKey);
    if (assesmentStatus != null) {
      return assesmentStatus;
    } else {
      throw Exception('Assesment status tidak ditemukan di cache');
    }
  }
  
  @override
  Future<bool> cachedVerifyOtpStatus(bool otpStatus) {
    return pref.setBool(cacheVerifyOtpStatusKey, otpStatus);
  }

    @override
  Future<bool> geOtpStatus() async {
    bool? otp = pref.getBool(cacheVerifyOtpStatusKey);
    if (otp != null) {
      return otp;
    } else {
      throw Exception('Otp status tidak ditemukan di cache');
    }
  }


}
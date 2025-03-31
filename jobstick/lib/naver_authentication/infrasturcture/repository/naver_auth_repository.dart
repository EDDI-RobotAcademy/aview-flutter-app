import 'package:flutter_naver_login/flutter_naver_login.dart';

abstract class NaverAuthRepository {
  Future<String> login();
  Future<void> logout();
  Future<User> fetchUserInfo();
  Future<String> requestUserToken(
      String accessToken, int userId, String email, String nickname, String gender, String ageRange, String birthyear);
}
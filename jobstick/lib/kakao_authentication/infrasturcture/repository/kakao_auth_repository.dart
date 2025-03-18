import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

abstract class KakaoAuthRepository {
  Future<String> login();
  Future<void> logout();
  Future<User> fetchUserInfo();
  Future<String> requestUserToken(
      String accessToken, int userId, String email, String nickname, String gender, String ageRange, String birthyear);
}
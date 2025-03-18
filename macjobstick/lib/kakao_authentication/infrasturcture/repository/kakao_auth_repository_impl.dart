import 'dart:ffi';

import 'package:macjobstick/kakao_authentication/infrasturcture/data_sources/kakao_auth_remote_data_source.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import 'kakao_auth_repository.dart';

// class KakaoAuthRepositoryImpl(KakaoAuthRepository):
class KakaoAuthRepositoryImpl implements KakaoAuthRepository {
  final KakaoAuthRemoteDataSource remoteDataSource;

  KakaoAuthRepositoryImpl(this.remoteDataSource);

  // async는 비동기 처리를 지원함 (FastAPI에서 주로 봤었음)
  @override
  Future<String> login() async {
    print("KakaoAuthRepositoryImpl login()");
    return await remoteDataSource.loginWithKakao();
  }

  @override
  Future<User> fetchUserInfo() async {
    return await remoteDataSource.fetchUserInfoFromKakao();
  }

  @override
  Future<String> requestUserToken(
      String accessToken, int id, String email, String nickname, String gender, String ageRange, String birthyear) async {
    print(
        "Requesting user token with accessToken: $accessToken, 'user_id: $id, email: $email, nickname: $nickname, gender: $gender, age_range: $ageRange, birthyear: $birthyear");
    try {
      final userToken = await remoteDataSource.requestUserTokenFromServer(
          accessToken, id, email, nickname, gender, ageRange, birthyear);
      print("User token obtained: $userToken");
      return userToken;
    } catch (e) {
      print("Error during requesting user token: $e");
      throw Exception("Failed to request user token: $e");
    }
  }
}
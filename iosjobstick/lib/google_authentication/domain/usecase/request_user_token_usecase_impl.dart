import 'dart:ffi';

import 'package:iosjobstick/google_authentication/domain/usecase/request_user_token_usecase.dart';
import '../../infrasturcture/repository/google_auth_repository.dart';

class RequestUserTokenUseCaseImpl implements RequestUserTokenUseCase {
  final GoogleAuthRepository repository;

  RequestUserTokenUseCaseImpl(this.repository);

  @override
  Future<String> execute(
      String accessToken, int id, String email, String nickname, String gender, String ageRange, String birthyear) async {
      // Django 서버에 요청을 보낸 후 UserToken을 받아와서 반환함
    try {
      // Django 서버에 POST 요청을 보내고 User Token 반환
      final userToken =
      await repository.requestUserToken(accessToken, id,  email, nickname, gender, ageRange, birthyear);
      // repository를 통해 Django API에 사용자 정보를 전달하고 userToken을 받아옴.
      // Django 서버에서 받은 응답을 userToken 변수에 저장.
      print("Google User token obtained: $userToken");
      return userToken;
    } catch (error) {
      print("Error while requesting Google user token: $error");
      throw Exception('Failed to request Google user token: $error');
    }
  }
}
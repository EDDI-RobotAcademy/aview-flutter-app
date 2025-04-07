import 'dart:ffi';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:iosjobstick/google_authentication/infrasturcture/data_sources/google_auth_remote_data_source.dart';
import 'google_auth_repository.dart';

class GoogleAuthRepositoryImpl implements GoogleAuthRepository {
  final GoogleAuthRemoteDataSource remoteDataSource;
  //static const String _key = "agreed_terms";

  GoogleAuthRepositoryImpl(this.remoteDataSource);

  /*
  @override
  Future<void> saveAgreement() async{
    // TODO: implement saveAgreement
    print("googleAuthRepositoryImpl saveAgreementOnTerms() 사용자 동의여부 저장");
    return await remoteDataSource.saveAgreementOnTerms();
  }

  @override
  Future<bool> loadAgreement() async {
    // TODO: implement checkAgreement
    print("googleAuthRepositoryImpl loadWhetherAgreeOrNot() 사용자 동의여부를 불러옴");
    return await remoteDataSource.loadWhetherAgreeOrNot();
  }
*/


  // async는 비동기 처리를 지원함 (FastAPI에서 주로 봤었음)
  @override
  Future<String> googleLogin() async {
    print("GoogleAuthRepositoryImpl login()");
    return await remoteDataSource.loginWithGoogle();
  }

  @override
  Future<void> googleLogout() async {
    print("GoogleAuthRepositoryImpl logout()");
    return await remoteDataSource.logoutWithGoogle();
  }

  @override
  Future<GoogleSignInAccount?> fetchGoogleUserInfo() async {
    print("GoogleAuthRepositoryImpl fetchGoogleUserInfo()");
    return await remoteDataSource.fetchUserInfoFromGoogle();
  }

  @override
  Future<String> requestUserToken(
      String accessToken,
      int id,
      String email,
      String nickname,
      String gender,
      String ageRange,
      String birthyear,
      ) async {
    // ⚠️ Google은 대부분의 사용자 정보가 없거나 nullable일 수 있으므로,
    // RemoteDataSource 쪽도 유연하게 처리돼야 함
    print(
      "Requesting Google user token with accessToken: $accessToken, user_id: $id, email: $email, nickname: $nickname, gender: $gender, age_range: $ageRange, birthyear: $birthyear",
    );
    try {
      final userToken = await remoteDataSource.requestUserTokenFromServer(
        accessToken,
        id,
        email,
        nickname,
        gender,
        ageRange,
        birthyear,
      );
      print("User token obtained: $userToken");
      return userToken;
    } catch (e) {
      print("Error during requesting Google user token: $e");
      throw Exception("Failed to request Google user token: $e");
    }
  }

}
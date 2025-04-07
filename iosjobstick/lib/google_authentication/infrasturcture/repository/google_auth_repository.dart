import 'package:google_sign_in/google_sign_in.dart';

abstract class GoogleAuthRepository {
  //Future<void> saveAgreement();
  //Future<bool> loadAgreement();
  Future<String> googleLogin();
  Future<void> googleLogout();
  Future<GoogleSignInAccount?> fetchGoogleUserInfo();
  Future<String> requestUserToken(
      String accessToken, int id, String email, String nickname, String gender, String ageRange, String birthyear);
}
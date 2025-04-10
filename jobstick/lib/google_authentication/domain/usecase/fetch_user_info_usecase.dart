import 'package:google_sign_in/google_sign_in.dart';

abstract class FetchUserInfoUseCase {
  Future<GoogleSignInAccount?> execute();
}
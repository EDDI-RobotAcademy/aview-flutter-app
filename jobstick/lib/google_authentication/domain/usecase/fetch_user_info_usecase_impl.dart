import 'package:google_sign_in/google_sign_in.dart';

import '../../infrasturcture/repository/google_auth_repository.dart';
import 'fetch_user_info_usecase.dart';

 class FetchUserInfoUseCaseImpl implements FetchUserInfoUseCase{
  final GoogleAuthRepository repository;

  FetchUserInfoUseCaseImpl(this.repository);

  @override
  Future<GoogleSignInAccount?> execute() async {
    return await repository.fetchUserInfo();
  }
}
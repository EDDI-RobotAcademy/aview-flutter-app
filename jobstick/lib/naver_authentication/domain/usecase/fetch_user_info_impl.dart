import 'package:flutter_naver_login/flutter_naver_login.dart';

class FetchUserInfoUseCaseImpl implements FetchUserInfoUseCase {
  final NaverAuthRepository repository;

  FetchUserInfoUseCaseImpl(this.repository);

  @override
  Future<User> execute() async {
    return await repository.fetchUserInfo();
  }
}
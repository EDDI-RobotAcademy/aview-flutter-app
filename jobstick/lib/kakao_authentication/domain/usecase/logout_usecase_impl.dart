import '../../infrasturcture/repository/kakao_auth_repository.dart';
import 'logout_usecase.dart';

class LogoutUseCaseImpl implements LogoutUseCase {
  final KakaoAuthRepository repository;

  LogoutUseCaseImpl(this.repository);

  @override
  Future<void> execute() async {
    print("LogoutUseCaseImpl execute()");
    await repository.logout();
  }
}
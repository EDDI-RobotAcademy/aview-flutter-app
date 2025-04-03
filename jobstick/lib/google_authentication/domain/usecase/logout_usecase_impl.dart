import '../../infrasturcture/repository/google_auth_repository.dart';
import 'logout_usecase.dart';

class LogoutUseCaseImpl implements LogoutUseCase {
  final GoogleAuthRepository repository;

  LogoutUseCaseImpl(this.repository);

  @override
  Future<void> execute() async {
    print("LogoutUseCaseImpl execute()");
    await repository.logout();
  }
}
import '../../infrasturcture/repository/google_auth_repository.dart';
import 'login_usecase.dart';

class GoogleLoginUseCaseImpl implements GoogleLoginUseCase {
  final GoogleAuthRepository repository;

  GoogleLoginUseCaseImpl(this.repository);

  @override
  Future<String> execute() async {
    print("Google LoginUseCaseImpl execute()");
    return await repository.googleLogin();
  }
}
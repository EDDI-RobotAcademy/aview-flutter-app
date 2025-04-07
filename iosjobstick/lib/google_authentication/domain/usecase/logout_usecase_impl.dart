import '../../infrasturcture/repository/google_auth_repository.dart';
import 'logout_usecase.dart';

class GoogleLogoutUseCaseImpl implements GoogleLogoutUseCase {
  final GoogleAuthRepository repository;

  GoogleLogoutUseCaseImpl(this.repository);

  @override
  Future<void> execute() async {
    print("Google LogoutUseCaseImpl execute()");
    await repository.googleLogout();
  }
}
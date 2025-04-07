import 'package:google_sign_in/google_sign_in.dart';
import '../../infrasturcture/repository/google_auth_repository.dart';
import 'fetch_user_info_usecase.dart';


class FetchGoogleUserInfoUseCaseImpl implements FetchGoogleUserInfoUseCase {
  final GoogleAuthRepository repository;
  // 의존성 주입. final: 한번 값이 할당되면 변경 불가 (불변)

  FetchGoogleUserInfoUseCaseImpl(this.repository);

  @override
  Future<GoogleSignInAccount?> execute() async {
    // ✨ Google 로그인 후 사용자 정보를 반환하는 비동기 함수
    // 이 함수는 repository에서 GoogleSignInAccount 객체를 받아서 그대로 반환함
    return await repository.fetchGoogleUserInfo();
  }
}
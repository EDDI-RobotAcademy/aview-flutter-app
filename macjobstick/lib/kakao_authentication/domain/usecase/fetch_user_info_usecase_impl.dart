import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import '../../infrasturcture/repository/kakao_auth_repository.dart';
import 'fetch_user_info_usecase.dart';

class FetchUserInfoUseCaseImpl implements FetchUserInfoUseCase {
  final KakaoAuthRepository repository;
  // 의존성 주입. final: 한번 값이 할당되면 변경 불가 (불변)

  FetchUserInfoUseCaseImpl(this.repository);

  @override
  Future<User> execute() async {
    // exeute()는 함수를 비동기(async)로 실행하고,  -> 실행이 끝날때까지 기다려야함
    // 이 함수가 Future<User>를 반환한다는 의미
    // 카카오에서 가져온 사용자 정보(User)를 반환하는 함수라는 뜻
    return await repository.fetchUserInfo();
    // repository.fetchUserInfo()의 결과를 반환하는 함수임
  }
}
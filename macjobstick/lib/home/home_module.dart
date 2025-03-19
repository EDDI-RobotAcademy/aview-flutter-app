import 'package:macjobstick/home/presentation/ui/home_page.dart';
import 'package:macjobstick/kakao_authentication/presentation/providers/kakao_auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import '../kakao_authentication/domain/usecase/agree_terms_usecase_impl.dart';
import '../kakao_authentication/domain/usecase/fetch_user_info_usecase_impl.dart';
import '../kakao_authentication/domain/usecase/login_usecase_impl.dart';
import '../kakao_authentication/domain/usecase/logout_usecase_impl.dart';
import '../kakao_authentication/domain/usecase/request_user_token_usecase_impl.dart';
import '../kakao_authentication/infrasturcture/data_sources/kakao_auth_remote_data_source.dart';
import '../kakao_authentication/infrasturcture/repository/kakao_auth_repository.dart';
import '../kakao_authentication/infrasturcture/repository/kakao_auth_repository_impl.dart';

class HomeModule {
  static Widget provideHomePage() {
    dotenv.load();
    String baseServerUrl = dotenv.env['BASE_URL'] ?? '';

    // MultiProvider는 여러 개의 Provider를 한 번에 선언 할 수 있음
    // Flutter에서 DI (Dependency Injection)을 수행하기 위해 Provider를 사용함
    // 이 Widget을 통해 여러 의존성들을 제공하고 엮을 수 있음
    // 최하단의 child에 있는 HomePage() 라는 페이지에서 사용할 의존성들을 배치하는 과정임
    return MultiProvider(
        providers: [
          // Provider는 객체를 생성하고 이를 하위 어디서든 접근 할 수 있도록 구성
          // 현재 케이스는 KakaoAuthRemoteDataSource 객체를 생성하여 의존성을 주입
          // baseServerUrl을 전달해서 Backend API 요청을 처리 할 수 있도록 구성
          // 실제 API 호출은 KakaoAuthRemoteDataSource에서 발생
          Provider<KakaoAuthRemoteDataSource>(
              create: (_) => KakaoAuthRemoteDataSource(baseServerUrl)
          ),
          // ProxyProvider는 다른 Provider의 값을 참조하여 새로운 의존성을 구성
          // 일종의 Service 레이어 구성이라 생각하면 되는데
          // KakaoAuthRemoteDataSource을 호출하는 것이 KakaoAuthRepository에 해당함
          // 그러므로 두 개를 엮어주는 작업에 해당함
          // 쉽게 얘기해서 Service에서 Repository에 대한 getInstance()를 해서
          // DI (Dependency Injection)을 해야 하는데 이것을 ProxyProvider가 지원
          // KakaoAuthRemoteDataSource을 받아와서 KakaoAuthRepository을 생성
          ProxyProvider<KakaoAuthRemoteDataSource, KakaoAuthRepository>(
            update: (_, remoteDataSrouce, __) =>
                KakaoAuthRepositoryImpl(remoteDataSrouce),
          ),
          // 위에서 논하였듯이 Service Layer를 만드는 것과 비슷함
          // 현재 Flutter에서는 구성이 아래와 같음
          // RemoteDataSource 라고 되어 있는 것이 실제 API Call 영역
          // Usecase -> Repository -> RemoteDataSource 흐름을 가지게 만들었음
          ProxyProvider<KakaoAuthRepository, LoginUseCaseImpl>(
              update: (_, repository, __) =>
                  LoginUseCaseImpl(repository)
          ),
          // ChangeNotifier를 상속받은 객체를 제공하는 Provider에 해당함
          // KakaoAuthProvider 상태를 관리하고 이 내용이 변경되는 것들을 내부에서 관리함
          // 쉽게 생각하자면 State의 변경이 발생하는 것들은 전부 여기에 배치합니다.
          // 로그인, 사용자 정보, 유저 토큰 등은 전부 내부 state를 변경 할 수 있습니다.
          ChangeNotifierProvider<KakaoAuthProvider>(
            create: (context) => KakaoAuthProvider(
              //agreeTermsUseCase:  context.read<AgreeTermsUseCaseImpl>(),// ✅ 추가
              loginUseCase: context.read<LoginUseCaseImpl>(),
              logoutUseCase: context.read<LogoutUseCaseImpl>(),
              fetchUserInfoUseCase: context.read<FetchUserInfoUseCaseImpl>(),
              requestUserTokenUseCase: context.read<RequestUserTokenUseCaseImpl>(),
            ),
          ),
        ],
        child: HomePage()
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:jobstick/home/presentation/ui/home_page.dart';
//카카오 로그인 관련
import '../kakao_authentication/domain/usecase/fetch_user_info_usecase_impl.dart' as kakaoUserInfo;
import '../kakao_authentication/domain/usecase/login_usecase_impl.dart' as kakaoLogin;
import '../kakao_authentication/domain/usecase/logout_usecase_impl.dart' as kakaoLogout;
import '../kakao_authentication/domain/usecase/request_user_token_usecase_impl.dart' as kakaoRequestUser;
import '../kakao_authentication/infrasturcture/data_sources/kakao_auth_remote_data_source.dart';
import '../kakao_authentication/infrasturcture/repository/kakao_auth_repository.dart';
import '../kakao_authentication/infrasturcture/repository/kakao_auth_repository_impl.dart';
import '../kakao_authentication/presentation/providers/kakao_auth_providers.dart';

//구글 로그인 관련
import '../google_authentication/domain/usecase/fetch_user_info_usecase_impl.dart' as googleUserInfo;
import '../google_authentication/domain/usecase/login_usecase_impl.dart' as googleLogin;
import '../google_authentication/domain/usecase/logout_usecase_impl.dart' as googleLogout;
import '../google_authentication/domain/usecase/request_user_token_usecase_impl.dart' as googleRequestUser;
import '../google_authentication/infrasturcture/data_source/google_auth_remote_data_source.dart';
import '../google_authentication/infrasturcture/repository/google_auth_repository.dart';
import '../google_authentication/infrasturcture/repository/google_auth_repository_impl.dart';
import '../google_authentication/presentation/providers/google_auth_providers.dart';

class HomeModule {
  static Widget provideHomePage() {
    dotenv.load();
    String baseServerUrl = dotenv.env['BASE_URL'] ?? '';

    return MultiProvider(
      providers: [
        Provider<KakaoAuthRemoteDataSource>(
          create: (_) => KakaoAuthRemoteDataSource(baseServerUrl),
        ),
        ProxyProvider<KakaoAuthRemoteDataSource, KakaoAuthRepository>(
          update: (_, remoteDataSource, __) =>
              KakaoAuthRepositoryImpl(remoteDataSource),
        ),
        ProxyProvider<KakaoAuthRepository, kakaoLogin.LoginUseCaseImpl>(
          update: (_, repository, __) => kakaoLogin.LoginUseCaseImpl(repository),
        ),
        ProxyProvider<KakaoAuthRepository, kakaoLogout.LogoutUseCaseImpl>(
          update: (_, repository, __) => kakaoLogout.LogoutUseCaseImpl(repository),
        ),
        ProxyProvider<KakaoAuthRepository, kakaoUserInfo.FetchUserInfoUseCaseImpl>(
          update: (_, repository, __) => kakaoUserInfo.FetchUserInfoUseCaseImpl(repository),
        ),
        ProxyProvider<KakaoAuthRepository, kakaoRequestUser.RequestUserTokenUseCaseImpl>(
          update: (_, repository, __) => kakaoRequestUser.RequestUserTokenUseCaseImpl(repository),
        ),
        ChangeNotifierProvider<KakaoAuthProvider>(
          create: (context) => KakaoAuthProvider(
            loginUseCase: context.read<kakaoLogin.LoginUseCaseImpl>(),
            logoutUseCase: context.read<kakaoLogout.LogoutUseCaseImpl>(),
            fetchUserInfoUseCase: context.read<kakaoUserInfo.FetchUserInfoUseCaseImpl>(),
            requestUserTokenUseCase: context.read<kakaoRequestUser.RequestUserTokenUseCaseImpl>(),
          ),
        ),

        Provider<GoogleAuthRemoteDataSource>(
          create: (_) => GoogleAuthRemoteDataSource(baseServerUrl),
        ),
        ProxyProvider<GoogleAuthRemoteDataSource, GoogleAuthRepository>(
          update: (_, remoteDataSource, __) =>
              GoogleAuthRepositoryImpl(remoteDataSource),
        ),
        ProxyProvider<GoogleAuthRepository, googleLogin.LoginUseCaseImpl>(
          update: (_, repository, __) => googleLogin.LoginUseCaseImpl(repository),
        ),
        ProxyProvider<GoogleAuthRepository, googleLogout.LogoutUseCaseImpl>(
          update: (_, repository, __) => googleLogout.LogoutUseCaseImpl(repository),
        ),
        ProxyProvider<GoogleAuthRepository, googleUserInfo.FetchUserInfoUseCaseImpl>(
          update: (_, repository, __) => googleUserInfo.FetchUserInfoUseCaseImpl(repository),
        ),
        ProxyProvider<GoogleAuthRepository, googleRequestUser.RequestUserTokenUseCaseImpl>(
          update: (_, repository, __) => googleRequestUser.RequestUserTokenUseCaseImpl(repository),
        ),
        ChangeNotifierProvider<GoogleAuthProvider>(
          create: (context) => GoogleAuthProvider(
            loginUseCase: context.read<googleLogin.LoginUseCaseImpl>(),
            logoutUseCase: context.read<googleLogout.LogoutUseCaseImpl>(),
            fetchUserInfoUseCase: context.read<googleUserInfo.FetchUserInfoUseCaseImpl>(),
            requestUserTokenUseCase: context.read<googleRequestUser.RequestUserTokenUseCaseImpl>(),
          ),
        ),


      ],
      child: HomePage(),
    );
  }
}

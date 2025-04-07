import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:iosjobstick/home/presentation/ui/home_page.dart';
import '../kakao_authentication/domain/usecase/fetch_user_info_usecase_impl.dart';
import '../kakao_authentication/domain/usecase/login_usecase_impl.dart';
import '../kakao_authentication/domain/usecase/logout_usecase_impl.dart';
import '../kakao_authentication/domain/usecase/request_user_token_usecase_impl.dart';
import '../kakao_authentication/infrasturcture/data_sources/kakao_auth_remote_data_source.dart';
import '../kakao_authentication/infrasturcture/repository/kakao_auth_repository.dart';
import '../kakao_authentication/infrasturcture/repository/kakao_auth_repository_impl.dart';
import '../kakao_authentication/presentation/providers/kakao_auth_providers.dart';

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
        ProxyProvider<KakaoAuthRepository, LoginUseCaseImpl>(
          update: (_, repository, __) => LoginUseCaseImpl(repository),
        ),
        ProxyProvider<KakaoAuthRepository, LogoutUseCaseImpl>(
          update: (_, repository, __) => LogoutUseCaseImpl(repository),
        ),
        ProxyProvider<KakaoAuthRepository, FetchUserInfoUseCaseImpl>(
          update: (_, repository, __) => FetchUserInfoUseCaseImpl(repository),
        ),
        ProxyProvider<KakaoAuthRepository, RequestUserTokenUseCaseImpl>(
          update: (_, repository, __) => RequestUserTokenUseCaseImpl(repository),
        ),
        ChangeNotifierProvider<KakaoAuthProvider>(
          create: (context) => KakaoAuthProvider(
            loginUseCase: context.read<LoginUseCaseImpl>(),
            logoutUseCase: context.read<LogoutUseCaseImpl>(),
            fetchUserInfoUseCase: context.read<FetchUserInfoUseCaseImpl>(),
            requestUserTokenUseCase: context.read<RequestUserTokenUseCaseImpl>(),
          ),
        ),
      ],
      child: HomePage(),
    );
  }
}
import 'package:iosjobstick/google_authentication/presentation/providers/google_auth_providers.dart';
import 'package:iosjobstick/google_authentication/presentation/ui/google_login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'domain/usecase/fetch_user_info_usecase_impl.dart';
import 'domain/usecase/login_usecase_impl.dart';
import 'domain/usecase/logout_usecase_impl.dart';
import 'domain/usecase/request_user_token_usecase_impl.dart';
import 'infrasturcture/data_sources/google_auth_remote_data_source.dart';
import 'infrasturcture/repository/google_auth_repository.dart';
import 'infrasturcture/repository/google_auth_repository_impl.dart';

class GoogleAuthModule {
  static Widget provideGoogleLoginPage() {
    dotenv.load();
    String baseServerUrl = dotenv.env['BASE_URL'] ?? '';

    return MultiProvider(
      providers: [
        Provider<GoogleAuthRemoteDataSource>(
          create: (_) => GoogleAuthRemoteDataSource(baseServerUrl),
        ),
        ProxyProvider<GoogleAuthRemoteDataSource, GoogleAuthRepository>(
          update: (_, remoteDataSource, __) => // ✨ 오타 수정: remoteDataSrouce → remoteDataSource
          GoogleAuthRepositoryImpl(remoteDataSource),
        ),
        ProxyProvider<GoogleAuthRepository, GoogleLoginUseCaseImpl>(
          update: (_, repository, __) =>
              GoogleLoginUseCaseImpl(repository),
        ),

        // ✨ 주석 해제: provider 생성 시 필요하므로 반드시 등록해야 함
        ProxyProvider<GoogleAuthRepository, GoogleLogoutUseCaseImpl>(
          update: (_, repository, __) =>
              GoogleLogoutUseCaseImpl(repository),
        ),
        ProxyProvider<GoogleAuthRepository, FetchGoogleUserInfoUseCaseImpl>(
          update: (_, repository, __) =>
              FetchGoogleUserInfoUseCaseImpl(repository),
        ),
        ProxyProvider<GoogleAuthRepository, RequestUserTokenUseCaseImpl>(
          update: (_, repository, __) =>
              RequestUserTokenUseCaseImpl(repository),
        ),

        ChangeNotifierProvider<GoogleAuthProvider>(
          create: (context) => GoogleAuthProvider(
            googleLoginUseCase: context.read<GoogleLoginUseCaseImpl>(),
            googleLogoutUseCase: context.read<GoogleLogoutUseCaseImpl>(), // ✨ 필요하므로 주입됨
            fetchGoogleUserInfoUseCase: context.read<FetchGoogleUserInfoUseCaseImpl>(),
            requestUserTokenUseCase: context.read<RequestUserTokenUseCaseImpl>(),
            // agreeTermsUseCase: context.read<AgreeTermsUseCaseImpl>(), // 약관 동의는 필요 시 추가
          ),
        ),
      ],
      child: GoogleLoginPage(),
    );
  }
}

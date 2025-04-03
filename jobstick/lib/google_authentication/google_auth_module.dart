import 'package:jobstick/google_authentication/domain/usecase/logout_usecase_impl.dart';
import 'package:jobstick/google_authentication/presentation/providers/google_auth_providers.dart';
import 'package:jobstick/google_authentication/presentation/ui/google_login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'domain/usecase/fetch_user_info_usecase_impl.dart';
import 'domain/usecase/login_usecase_impl.dart';
import 'domain/usecase/request_user_token_usecase_impl.dart';
import 'infrasturcture/data_source/google_auth_remote_data_source.dart';
import 'infrasturcture/repository/google_auth_repository.dart';
import 'infrasturcture/repository/google_auth_repository_impl.dart';

class GoogleAuthModule {
  static Widget provideGoogleLoginPage() {
    dotenv.load();
    String baseServerUrl = dotenv.env['BASE_URL'] ?? '';

    return MultiProvider(
        providers: [
          Provider<GoogleAuthRemoteDataSource>(
              create: (_) => GoogleAuthRemoteDataSource(baseServerUrl)
          ),
          ProxyProvider<GoogleAuthRemoteDataSource, GoogleAuthRepository>(
            update: (_, remoteDataSource, __) =>
                GoogleAuthRepositoryImpl(remoteDataSource),
          ),
          ProxyProvider<GoogleAuthRepository, LoginUseCaseImpl>(
              update: (_, repository, __) =>
                  LoginUseCaseImpl(repository)
          ),
          ChangeNotifierProvider<GoogleAuthProvider>(
            create: (context) => GoogleAuthProvider(
              loginUseCase: context.read<LoginUseCaseImpl>(),
              logoutUseCase: context.read<LogoutUseCaseImpl>(),
              fetchUserInfoUseCase: context.read<FetchUserInfoUseCaseImpl>(),
              requestUserTokenUseCase: context.read<RequestUserTokenUseCaseImpl>(),
            ),
          ),
        ],
        child: GoogleLoginPage()
    );
  }
}
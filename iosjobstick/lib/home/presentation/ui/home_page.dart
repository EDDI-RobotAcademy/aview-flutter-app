import 'package:iosjobstick/common_ui/custom_app_bar.dart';
import 'package:iosjobstick/kakao_authentication/presentation/providers/kakao_auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:iosjobstick/kakao_authentication/domain/usecase/logout_usecase_impl.dart';
import 'package:iosjobstick/kakao_authentication/domain/usecase/fetch_user_info_usecase_impl.dart';
import 'package:iosjobstick/kakao_authentication/domain/usecase/login_usecase_impl.dart';
import 'package:iosjobstick/kakao_authentication/domain/usecase/request_user_token_usecase_impl.dart';
import 'package:iosjobstick/kakao_authentication/infrasturcture/data_sources/kakao_auth_remote_data_source.dart';
import 'package:iosjobstick/kakao_authentication/infrasturcture/repository/kakao_auth_repository.dart';
import 'package:iosjobstick/kakao_authentication/infrasturcture/repository/kakao_auth_repository_impl.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<KakaoAuthRemoteDataSource>(
          create: (_) => KakaoAuthRemoteDataSource('your_base_url_here'),
        ),
        ProxyProvider<KakaoAuthRemoteDataSource, KakaoAuthRepository>(
          update: (_, remoteDataSource, __) => KakaoAuthRepositoryImpl(remoteDataSource),
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
      child: Consumer<KakaoAuthProvider>(
        builder: (context, kakaoAuthProvider, child) {
          return Scaffold(
            body: CustomAppBar(
              body: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/home_bg3.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: const Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: Text(
                      "Use Your JOBSTICK!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
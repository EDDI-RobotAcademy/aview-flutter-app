import 'package:jobstick/common_ui/custom_app_bar.dart';
import 'package:jobstick/kakao_authentication/presentation/providers/kakao_auth_providers.dart';
import 'package:jobstick/google_authentication/presentation/providers/google_auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//카카오
import 'package:jobstick/kakao_authentication/domain/usecase/logout_usecase_impl.dart' as kakaoLogout;
import 'package:jobstick/kakao_authentication/domain/usecase/fetch_user_info_usecase_impl.dart' as kakaoUserInfo;
import 'package:jobstick/kakao_authentication/domain/usecase/login_usecase_impl.dart' as kakaoLogin;
import 'package:jobstick/kakao_authentication/domain/usecase/request_user_token_usecase_impl.dart' as kakaoRequestUser;
import 'package:jobstick/kakao_authentication/infrasturcture/data_sources/kakao_auth_remote_data_source.dart';
import 'package:jobstick/kakao_authentication/infrasturcture/repository/kakao_auth_repository.dart';
import 'package:jobstick/kakao_authentication/infrasturcture/repository/kakao_auth_repository_impl.dart';

//구글
import 'package:jobstick/google_authentication/domain/usecase/logout_usecase_impl.dart' as googleLogout;
import 'package:jobstick/google_authentication/domain/usecase/fetch_user_info_usecase_impl.dart' as googleUserInfo;
import 'package:jobstick/google_authentication/domain/usecase/login_usecase_impl.dart' as googleLogin;
import 'package:jobstick/google_authentication/domain/usecase/request_user_token_usecase_impl.dart' as googleRequestUser;
import 'package:jobstick/google_authentication/infrasturcture/data_source/google_auth_remote_data_source.dart';
import 'package:jobstick/google_authentication/infrasturcture/repository/google_auth_repository.dart';
import 'package:jobstick/google_authentication/infrasturcture/repository/google_auth_repository_impl.dart';

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
          create: (_) => GoogleAuthRemoteDataSource('your_base_url_here'),
        ),
        ProxyProvider<GoogleAuthRemoteDataSource, GoogleAuthRepository>(
          update: (_, remoteDataSource, __) => GoogleAuthRepositoryImpl(remoteDataSource),
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
      child: Consumer2<KakaoAuthProvider, GoogleAuthProvider>(
        builder: (context, kakaoAuthProvider, googleAuthProvider, child) {
          bool isLoggedIn = kakaoAuthProvider.isLoggedIn || googleAuthProvider.isLoggedIn;
          return Scaffold(
            body: CustomAppBar(
              body: Container(
                width: double.infinity, // 가로 전체 채우기
                height: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/home_bg3.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 150),
                    Text(
                      isLoggedIn ? "WELCOME" : "Use Your JOBSTICK!",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text("카카오 로그인 상태: ${kakaoAuthProvider.isLoggedIn ? '로그인됨' : '로그아웃됨'}"),
                    Text("구글 로그인 상태: ${googleAuthProvider.isLoggedIn ? '로그인됨' : '로그아웃됨'}"),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

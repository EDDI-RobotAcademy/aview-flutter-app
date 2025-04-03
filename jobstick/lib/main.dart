import 'package:jobstick/home/home_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';

//카카오 로그인 관련 의존성 추가
import 'kakao_authentication/domain/usecase/fetch_user_info_usecase_impl.dart' as KakaoUserInfo;
import 'kakao_authentication/domain/usecase/request_user_token_usecase_impl.dart' as KakaoRequestToken;
import 'package:jobstick/kakao_authentication/domain/usecase/login_usecase_impl.dart' as KakaoLogin;
import 'package:jobstick/kakao_authentication/domain/usecase/logout_usecase_impl.dart'as KakaoLogout;
import 'package:jobstick/kakao_authentication/infrasturcture/data_sources/kakao_auth_remote_data_source.dart';
import 'package:jobstick/kakao_authentication/infrasturcture/repository/kakao_auth_repository.dart';
import 'package:jobstick/kakao_authentication/infrasturcture/repository/kakao_auth_repository_impl.dart';
import 'kakao_authentication/presentation/providers/kakao_auth_providers.dart';

// ✅ Google Authentication 관련 의존성 추가
import 'package:jobstick/google_authentication/domain/usecase/fetch_user_info_usecase_impl.dart' as GoogleUserInfo;
import 'package:jobstick/google_authentication/domain/usecase/login_usecase_impl.dart' as GoogleLogin;
import 'package:jobstick/google_authentication/domain/usecase/logout_usecase_impl.dart' as GoogleLogout;
import 'package:jobstick/google_authentication/domain/usecase/request_user_token_usecase_impl.dart' as GoogleRequestToken;
import 'package:jobstick/google_authentication/infrasturcture/data_source/google_auth_remote_data_source.dart';
import 'package:jobstick/google_authentication/infrasturcture/repository/google_auth_repository.dart';
import 'package:jobstick/google_authentication/infrasturcture/repository/google_auth_repository_impl.dart';
import 'package:jobstick/google_authentication/presentation/providers/google_auth_providers.dart';


import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  String baseServerUrl = dotenv.env['BASE_URL'] ?? '';
  String kakaoNativeAppKey = dotenv.env['KAKAO_NATIVE_APP_KEY'] ?? '';
  String kakaoJavaScriptAppKey = dotenv.env['KAKAO_JAVASCRIPT_APP_KEY'] ?? '';

  KakaoSdk.init(
    nativeAppKey: kakaoNativeAppKey,
    javaScriptAppKey: kakaoJavaScriptAppKey,
  );

  runApp(MyApp(baseUrl: baseServerUrl));
}

class MyApp extends StatelessWidget {
  final String baseUrl;

  const MyApp({required this.baseUrl});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<KakaoAuthRemoteDataSource>(
          create: (_) => KakaoAuthRemoteDataSource(baseUrl),
        ),
        ProxyProvider<KakaoAuthRemoteDataSource, KakaoAuthRepository>(
          update: (_, remoteDataSource, __) =>
              KakaoAuthRepositoryImpl(remoteDataSource),
        ),
        ProxyProvider<KakaoAuthRepository, KakaoLogin.LoginUseCaseImpl>(
          update: (_, repository, __) => KakaoLogin.LoginUseCaseImpl(repository),
        ),
        ProxyProvider<KakaoAuthRepository, KakaoLogout.LogoutUseCaseImpl>(
          update: (_, repository, __) => KakaoLogout.LogoutUseCaseImpl(repository),
        ),
        ProxyProvider<KakaoAuthRepository, KakaoUserInfo.FetchUserInfoUseCaseImpl>(
          update: (_, repository, __) => KakaoUserInfo.FetchUserInfoUseCaseImpl(repository),
        ),
        ProxyProvider<KakaoAuthRepository, KakaoRequestToken.RequestUserTokenUseCaseImpl>(
          update: (_, repository, __) =>
              KakaoRequestToken.RequestUserTokenUseCaseImpl(repository),
        ),
        ProxyProvider4<KakaoLogin.LoginUseCaseImpl, KakaoLogout.LogoutUseCaseImpl,
            KakaoUserInfo.FetchUserInfoUseCaseImpl, KakaoRequestToken.RequestUserTokenUseCaseImpl,
            KakaoAuthProvider>(
          update: (_, loginUseCase, logoutUseCase, fetchUserInfoUseCase,
              requestUserTokenUseCase, __) =>
              KakaoAuthProvider(
                loginUseCase: loginUseCase,
                logoutUseCase: logoutUseCase,
                fetchUserInfoUseCase: fetchUserInfoUseCase,
                requestUserTokenUseCase: requestUserTokenUseCase,
              ),
        ),

        Provider<GoogleAuthRemoteDataSource>(
          create: (_) => GoogleAuthRemoteDataSource(baseUrl),
        ),
        ProxyProvider<GoogleAuthRemoteDataSource, GoogleAuthRepository>(
          update: (_, remoteDataSource, __) =>
              GoogleAuthRepositoryImpl(remoteDataSource),
        ),
        ProxyProvider<GoogleAuthRepository, GoogleLogin.LoginUseCaseImpl>(
          update: (_, repository, __) => GoogleLogin.LoginUseCaseImpl(repository),
        ),
        ProxyProvider<GoogleAuthRepository, GoogleLogout.LogoutUseCaseImpl>(
          update: (_, repository, __) => GoogleLogout.LogoutUseCaseImpl(repository),
        ),
        ProxyProvider<GoogleAuthRepository, GoogleUserInfo.FetchUserInfoUseCaseImpl>(
          update: (_, repository, __) => GoogleUserInfo.FetchUserInfoUseCaseImpl(repository),
        ),
        ProxyProvider<GoogleAuthRepository, GoogleRequestToken.RequestUserTokenUseCaseImpl>(
          update: (_, repository, __) =>
              GoogleRequestToken.RequestUserTokenUseCaseImpl(repository),
        ),
        ProxyProvider4<GoogleLogin.LoginUseCaseImpl, GoogleLogout.LogoutUseCaseImpl,
            GoogleUserInfo.FetchUserInfoUseCaseImpl, GoogleRequestToken.RequestUserTokenUseCaseImpl,
            GoogleAuthProvider>(
          update: (_, loginUseCase, logoutUseCase, fetchUserInfoUseCase,
              requestUserTokenUseCase, __) =>
              GoogleAuthProvider(
                loginUseCase: loginUseCase,
                logoutUseCase: logoutUseCase,
                fetchUserInfoUseCase: fetchUserInfoUseCase,
                requestUserTokenUseCase: requestUserTokenUseCase,
              ),
        ),

      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          quill.FlutterQuillLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en', 'US'),
          Locale('ko', 'KR'),
        ],
        home: HomeModule.provideHomePage(),
      ),
    );
  }
}

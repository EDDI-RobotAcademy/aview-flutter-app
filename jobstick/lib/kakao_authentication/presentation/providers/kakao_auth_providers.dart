import 'package:jobstick/kakao_authentication/domain/usecase/login_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jobstick/kakao_authentication/domain/usecase/logout_usecase.dart';

import '../../domain/usecase/fetch_user_info_usecase.dart';
import '../../domain/usecase/request_user_token_usecase.dart';

class KakaoAuthProvider with ChangeNotifier {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final FetchUserInfoUseCase fetchUserInfoUseCase;
  final RequestUserTokenUseCase requestUserTokenUseCase;

  // Nuxt localStorage와 같은 역할
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  String? _accessToken;
  String? _userToken;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String _message = '';

  // 해당 변수 값을 즉시 가져올 수 있도록 구성
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String get message => _message;

  KakaoAuthProvider({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.fetchUserInfoUseCase,
    required this.requestUserTokenUseCase,
  });

  Future<void> login() async {
    _message = '';

    try {
      print("Kakao loginUseCase.execute()");
      _accessToken = await loginUseCase.execute();
      print("AccessToken obtained: $_accessToken");

      final userInfo = await fetchUserInfoUseCase.execute();
      print("User Info fetched: $userInfo");

      final userId = userInfo.id;
      final email = userInfo.kakaoAccount?.email;
      final nickname = userInfo.kakaoAccount?.profile?.nickname;

      _userToken = await requestUserTokenUseCase.execute(
          _accessToken!, userId, email!, nickname!);

      print("User Token obtained: $_userToken");

      await secureStorage.write(key: 'userToken', value: _userToken);

      _isLoggedIn = true;
      _message = '로그인 성공';
      print("Login successful");
    } catch (e) {
      _isLoggedIn = false;
      _message = "로그인 실패: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
      print("🔹 notifyListeners() 호출됨 (로그인)");
    }
  }

  Future<void> logout() async {
    try {
      await logoutUseCase.execute();  // 실제 로그아웃 실행
      await secureStorage.delete(key: 'userToken');

      _isLoggedIn = false;
      _accessToken = null;
      _userToken = null;
      _message = "로그아웃 완료";
    } catch (e) {
      _message = "로그아웃 실패 $e";
    } finally {
      notifyListeners();
    }
  }
}
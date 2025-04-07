import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iosjobstick/kakao_authentication/domain/usecase/fetch_user_info_usecase.dart';
import 'package:iosjobstick/kakao_authentication/domain/usecase/login_usecase.dart';
import 'package:iosjobstick/kakao_authentication/domain/usecase/logout_usecase.dart';
import 'package:iosjobstick/kakao_authentication/domain/usecase/request_user_token_usecase.dart';

class KakaoAuthProvider with ChangeNotifier {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final FetchUserInfoUseCase fetchUserInfoUseCase;
  final RequestUserTokenUseCase requestUserTokenUseCase;

  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  String? _accessToken;
  String? _userToken;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String _message = '';

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String get message => _message;

  KakaoAuthProvider({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.fetchUserInfoUseCase,
    required this.requestUserTokenUseCase,
  }) {
    _initAuthState(); // 앱 시작 시 로그인 상태 확인
  }

  // 초기 로그인 상태 확인
  Future<void> _initAuthState() async {
    _isLoading = true;
    notifyListeners();
    try {
      _userToken = await secureStorage.read(key: 'userToken');
      _isLoggedIn = _userToken != null;
      print("초기 로그인 상태: $_isLoggedIn");
    } catch (e) {
      print("초기화 오류: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }



/*
  /// ✅ Django 서버에서 약관 동의 여부 확인
  Future<void> checkTermsAgreement() async {
    try {
      bool serverAgreement = await agreeTermsUseCase.checkAgreement();
      _isTermsAgreed = serverAgreement;
      await secureStorage.write(key: 'termsAgreed', value: serverAgreement.toString());
    } catch (error) {
      print("약관 동의 확인 실패: $error");
      _isTermsAgreed = false;
    }
    notifyListeners();
  }

  /// ✅ 사용자가 약관에 동의하면 Django 서버에 저장 후 로컬에도 저장
  Future<void> agreeToTerms() async {
    try {
      await agreeTermsUseCase.agree();  // Django 서버에 저장
      await secureStorage.write(key: 'termsAgreed', value: "true");  // ✅ 로컬 저장
      _isTermsAgreed = true;
      notifyListeners();
    } catch (error) {
      print("약관 동의 저장 실패: $error");
    }
  }

   */


  // 로그인 처리
  // 로그인 처리
  Future<void> login() async {
    _isLoading = true;
    notifyListeners();  // 상태 변경 알림

    try {
      _accessToken = await loginUseCase.execute();
      final userInfo = await fetchUserInfoUseCase.execute();
      _userToken = await requestUserTokenUseCase.execute(
        _accessToken!,
        userInfo.id,
        userInfo.kakaoAccount?.email ?? '',
        userInfo.kakaoAccount?.profile?.nickname ?? '',
        userInfo.kakaoAccount?.gender?.name ?? 'unknown',
        userInfo.kakaoAccount?.ageRange?.name ?? 'unknown',
        userInfo.kakaoAccount?.birthyear ?? 'unknown',
      );

      await secureStorage.write(key: 'userToken', value: _userToken);

      _isLoggedIn = true;
      _message = '로그인 성공';

      // 로그인 후 상태 초기화 호출
      await _initAuthState();
    } catch (e) {
      _isLoggedIn = false;
      _message = "로그인 실패: $e";
    } finally {
      _isLoading = false;
      notifyListeners();  // 상태 변경 알림
    }
  }

  // 로그아웃 처리
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();  // 상태 변경 알림

    try {
      await logoutUseCase.execute();
      await secureStorage.delete(key: 'userToken');
      _isLoggedIn = false;
      _accessToken = null;
      _userToken = null;
      _message = '로그아웃 완료';

      // 로그아웃 후 상태 초기화 호출
      await _initAuthState();
    } catch (e) {
      _message = "로그아웃 실패: $e";
    } finally {
      _isLoading = false;
      notifyListeners();  // 상태 변경 알림
    }
  }
}


import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iosjobstick/google_authentication/domain/usecase/fetch_user_info_usecase.dart';
import 'package:iosjobstick/google_authentication/domain/usecase/login_usecase.dart';
import 'package:iosjobstick/google_authentication/domain/usecase/logout_usecase.dart';
import 'package:iosjobstick/google_authentication/domain/usecase/request_user_token_usecase.dart';

class GoogleAuthProvider with ChangeNotifier {
  final GoogleLoginUseCase googleLoginUseCase;
  final GoogleLogoutUseCase googleLogoutUseCase;
  final FetchGoogleUserInfoUseCase fetchGoogleUserInfoUseCase;
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

  GoogleAuthProvider({ // ✨ 클래스 이름은 대문자로 시작 (수정)
    required this.googleLoginUseCase,
    required this.googleLogoutUseCase,
    required this.fetchGoogleUserInfoUseCase,
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
      print("초기 구글 로그인 상태: $_isLoggedIn");
    } catch (e) {
      print("초기화 오류: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 로그인 처리
  Future<void> login() async {
    _isLoading = true;
    notifyListeners();

    try {
      _accessToken = await googleLoginUseCase.execute(); // 구글 accessToken 받아오기
      final userInfo = await fetchGoogleUserInfoUseCase.execute(); // ✨ GoogleSignInAccount 반환

      if (userInfo == null) {
        throw Exception("사용자 정보가 없습니다.");
      }

      // ✨ GoogleSignInAccount는 이메일, 이름, 사진만 제공. 나머지는 기본값 사용
      _userToken = await requestUserTokenUseCase.execute(
        _accessToken!,
        int.tryParse(userInfo.id) ?? 0, // ✨ id는 String → int 변환
        userInfo.email,
        userInfo.displayName ?? 'unknown',
        'unknown',     // ✨ gender: 구글에서는 제공되지 않음
        'unknown',     // ✨ ageRange: 없음
        'unknown',     // ✨ birthyear: 없음
      );

      await secureStorage.write(key: 'userToken', value: _userToken);

      _isLoggedIn = true;
      _message = '구글 로그인 성공';

      await _initAuthState();
    } catch (e) {
      _isLoggedIn = false;
      _message = "구글 로그인 실패: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 로그아웃 처리
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await googleLogoutUseCase.execute();
      await secureStorage.delete(key: 'userToken');
      _isLoggedIn = false;
      _accessToken = null;
      _userToken = null;
      _message = '구글 로그아웃 완료';

      await _initAuthState();
    } catch (e) {
      _message = "구글 로그아웃 실패: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}



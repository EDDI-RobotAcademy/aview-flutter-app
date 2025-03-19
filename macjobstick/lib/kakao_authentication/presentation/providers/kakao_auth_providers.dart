import 'package:flutter/material.dart';
import 'package:macjobstick/kakao_authentication/domain/usecase/agree_terms_usecase.dart';
import 'package:macjobstick/kakao_authentication/domain/usecase/login_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/usecase/fetch_user_info_usecase.dart';
import '../../domain/usecase/logout_usecase.dart';
import '../../domain/usecase/request_user_token_usecase.dart';



class KakaoAuthProvider with ChangeNotifier {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final FetchUserInfoUseCase fetchUserInfoUseCase;
  final RequestUserTokenUseCase requestUserTokenUseCase;
  //final AgreeTermsUseCase agreeTermsUseCase; // ✅ 추가

  // Nuxt의 localStorage와 같은 역할
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  String? _accessToken;
  String? _userToken;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String _message = '';
  //bool _isTermsAgreed = false; // ✅ 추가: 약관 동의 상태

  // 해당 변수 값을 즉시 가져올 수 있도록 구성
  String? get accessToken => _accessToken;
  String? get userToken => _userToken;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String get message => _message;
  //bool get isTermsAgreed => _isTermsAgreed; // ✅ 추가

  KakaoAuthProvider({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.fetchUserInfoUseCase,
    required this.requestUserTokenUseCase,
    //required this.agreeTermsUseCase,  // ✅ 추가
  }) {
    checkLoginStatus();
    //checkTermsAgreement();  // ✅ 약관 동의 상태 확인 추가
  }

  Future<void> checkLoginStatus() async {
    String? storedToken = await secureStorage.read(key:'userToken');
    if(storedToken !=null) {
      _userToken = storedToken;
      _isLoggedIn = true;
    } else {
      _isLoggedIn = false;
    }
    print("로그인 상태:$_isLoggedIn");
    notifyListeners();
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


  //Future<void> login() async {
  Future<void> login() async {
      _message = '';

      try {
        print("Kakao loginUseCase.execute()");   // 로그인 처리


        /*// ✅ 추가: 로그인 전에 약관 동의 여부 확인
        await checkTermsAgreement();
        if (!_isTermsAgreed) {
          throw Exception("개인정보 처리 방침에 동의해야 합니다.");
        } // ✅ end */


        _accessToken = await loginUseCase.execute();
        print("AccessToken obtained: $_accessToken");

        final userInfo = await fetchUserInfoUseCase.execute();
        print("User Info fetched: $userInfo");

        final id = userInfo.id;   // 이게 존재하는가?
        final email = userInfo.kakaoAccount?.email;
        final nickname = userInfo.kakaoAccount?.profile?.nickname;
        final gender = userInfo.kakaoAccount?.gender?.name ?? "unknown";
        final ageRange = userInfo.kakaoAccount?.ageRange?.name ?? "unknown";
        final birthyear = userInfo.kakaoAccount?.birthyear?? "unknown";


        // 필수 정보가 누락되었는지 확인
        if (id == 0 || email == null || nickname == null || gender == null || ageRange == null || birthyear == null) {
          throw Exception("Missing user information: user_id=$id, email=$email, nickname=$nickname, gender=$gender, age_range=$ageRange, birthyear=$birthyear");
        }
        print("나오세요");
        print("user_id=$id, User email: $email, User nickname: $nickname, gender: $gender, age_range: $ageRange, birthyear: $birthyear");

        // 정상적인 요청 실행
        _userToken = await requestUserTokenUseCase.execute(
            _accessToken!, id, email, nickname, gender, ageRange, birthyear);

        print("User Token obtained: $_userToken");

        await secureStorage.write(key: 'userToken', value: _userToken);

        _isLoggedIn = true;
        _message = '로그인 성공';
        print("Login successful");
        _isLoading=false;
        notifyListeners();
        print("호출: $_isLoggedIn");
      } catch (e) {
        _isLoggedIn = false;
        _message = "로그인 실패: $e";
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
        notifyListeners();
        print("호출: $_isLoggedIn");
        notifyListeners();
      } catch (e) {
        _message = "로그아웃 실패 $e";
      }
    }
  }

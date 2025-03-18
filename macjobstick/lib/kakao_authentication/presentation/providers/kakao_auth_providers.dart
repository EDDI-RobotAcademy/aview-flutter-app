import 'package:macjobstick/kakao_authentication/domain/usecase/login_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/usecase/fetch_user_info_usecase.dart';
import '../../domain/usecase/request_user_token_usecase.dart';

class KakaoAuthProvider with ChangeNotifier {
  final LoginUseCase loginUseCase;
  final FetchUserInfoUseCase fetchUserInfoUseCase;
  final RequestUserTokenUseCase requestUserTokenUseCase;

  // Nuxt의 localStorage와 같은 역할
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
    required this.fetchUserInfoUseCase,
    required this.requestUserTokenUseCase,
  });

  Future<void> login() async {
    _isLoading = true;
    _message = '';
    notifyListeners();

    try {
      print("Kakao loginUseCase.execute()");   // 로그인 처리
      _accessToken = await loginUseCase.execute();
      print("AccessToken obtained: $_accessToken");

      final userInfo = await fetchUserInfoUseCase.execute();
      print("User Info fetched: $userInfo");

      final id = userInfo.id;   // 이게 존재하는가?
      final email = userInfo.kakaoAccount?.email;
      final nickname = userInfo.kakaoAccount?.profile?.nickname;
      final gender = userInfo.kakaoAccount?.gender?.name ?? "unknown";
      final ageRange = userInfo.kakaoAccount?.ageRange?.name ?? "unknown";
      //final birthyear = int.tryParse(userInfo.kakaoAccount?.birthyear.toString() ?? "0") ?? 0;
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
    } catch (e) {
      _isLoggedIn = false;
      _message = "로그인 실패: $e";
    }

    _isLoading = false;
    notifyListeners();
  }
}
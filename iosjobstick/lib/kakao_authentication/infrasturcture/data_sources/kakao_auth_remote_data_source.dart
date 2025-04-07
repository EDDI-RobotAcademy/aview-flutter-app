import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class KakaoAuthRemoteDataSource {
  final String baseUrl;

  KakaoAuthRemoteDataSource(this.baseUrl);

/*
  Future<void> saveAgreementOnTerms() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/terms/agreement'), // ✅ Django 서버 API URL
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'agreed': true, // ✅ 사용자가 동의했음을 서버에 알림
        }),
      );

      if (response.statusCode == 200) {
        print("약관 동의 성공: ${response.body}");
      } else {
        throw Exception("약관 동의 저장 실패: ${response.body}");
      }
    } catch (error) {
      print("약관 동의 요청 중 오류 발생: $error");
      throw Exception("서버 요청 실패");
    }
  }

  Future<bool> loadWhetherAgreeOrNot() async {try {
    final response = await http.get(
      Uri.parse('$baseUrl/terms/agreement'),  // ✅ Django 서버 API URL
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("서버 응답: $data");

      return data['agreed'] ?? false;  // ✅ 서버에서 동의 여부 반환
    } else {
      print("서버 오류 발생: ${response.statusCode}");
      return false;  // ❌ 오류 발생 시 기본값 false 반환
    }
  } catch (error) {
    print("서버 요청 실패: $error");
    return false;  // ❌ 요청 실패 시 기본값 false 반환
    }
  }
  */


  Future<String> loginWithKakao() async {
    // 비동기 함수(async)이며, String을 반환함.
    // 비동기 작업이 완료되면 카카오에서 받은 acesstoken(문자열)이 반환됨
    // accessToken은 서버에서 유저 인증을 할때 사용됨
    try {
      OAuthToken token;
      // token은 카카오에서 로그인 성공 후 반환하는 OAuth 인증 토큰을 저장할 변수
      if (await isKakaoTalkInstalled()) {
        // 사용자의 기기에 "카카오톡 앱"이 설치되어있는지 확인
        // true -> 카카오톡 앱으로 로그인 /  false -> 카카오 계정 로그인 (웹)
        token = await UserApi.instance.loginWithKakaoTalk();
        // 카카오톡 앱을 통해 로그인 시도. 성공하면 OAuthToken 객체 반환
        print('카카오톡으로 로그인 성공: ${token.accessToken}');
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
        // 카카오 계정 (웹)으로 로그인 시도 ** 카카오톡 앱이 없을 경우 실행
        // 마찬가지로 OAuthToken을 반환
        print('카카오 계정으로 로그인 성공: ${token.accessToken}');
      }

      return token.accessToken;
      // 로그인 성공하면 accessToken 반환. 이 토큰을 서버에 보내서 사용자 인증에 사용가능
    } catch (error) {
      print("로그인 실패: $error");
      throw Exception("Kakao 로그인 실패!");
    }
  }

  Future<void> logoutWithKakao() async {
    try {
      if (await isKakaoTalkInstalled()) {
        await UserApi.instance.logout();
        print('카카오톡으로 로그아웃 성공!');
      } else {
        await UserApi.instance.logout();
        print('카카오 계정으로 로그아웃 성공');
      }
    } catch (error) {
      print("로그인 실패: $error");
      throw Exception("Kakao 로그아웃 실패!");
    }
  }

  // 카카오 API에서 사용자 정보를 가져오는 메서드
  Future<User> fetchUserInfoFromKakao() async {
    try {
      final user = await UserApi.instance.me();
      // 카카오 API를 통해 현재 로그인한 사용자의 정보를 가져오는 코드
      // 이 함수가 실행되면 카카오 서비스에서 로그인한 사용자 정보가 반환됨
      print('User info: $user');
      return user;
    } catch (error) { // API 호출 중 에러가 발생하면, 이를 잡아서 예외 처리함
      print('Error fetching user info: $error');
      print('Error: fetchUserInfoFromKakao() 카카오에서 사용자 정보를 가져오지 못했습니다.');
      throw Exception('Failed to fetch user info from Kakao');
    }
  }

  Future<String> requestUserTokenFromServer(String accessToken, int id,
      String email, String nickname, String gender, String ageRange,
      String birthyear) async {
    final url =
    Uri.parse('$baseUrl/kakao-oauth/request-user-token'); // Django 서버 URL

    print('requestUserTokenFromServer url: $url');

    try {
      print("user_id= ${id}");
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json', // Ensure Content-Type is set
        },
        body: json.encode({
          'access_token': accessToken,
          'user_id': id,
          'email': email,
          'nickname': nickname,
          'gender': gender,
          'age_range': ageRange,
          'birthyear': birthyear
        }),
      );

      print('Server response status: ${response.statusCode}');
      print('Server response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Server response data: $data');
        return data['userToken'] ?? ''; // 실제 토큰 필드명에 맞게 수정
      } else {
        print(
            'Error: Failed to request user token, status code: ${response
                .statusCode}');
        throw Exception('Failed to request user token: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during request to server: $error');
      throw Exception('Request to server failed: $error');
    }
  }
}
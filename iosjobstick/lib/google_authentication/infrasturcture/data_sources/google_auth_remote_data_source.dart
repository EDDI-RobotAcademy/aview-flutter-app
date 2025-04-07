import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class GoogleAuthRemoteDataSource {
  final String baseUrl;

  GoogleAuthRemoteDataSource(this.baseUrl);

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


  Future<String> loginWithGoogle() async {
    // 비동기 함수(async)이며, String을 반환함.
    // 비동기 작업이 완료되면 카카오에서 받은 acesstoken(문자열)이 반환됨
    // accessToken은 서버에서 유저 인증을 할때 사용됨
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      final account = await _googleSignIn.signIn(); // ✨ 카카오 → GoogleSignIn 사용

      if (account == null) {
        throw Exception("사용자가 로그인을 취소했습니다.");
      }

      final auth = await account.authentication; // ✨ accessToken 추출
      final accessToken = auth.accessToken;

      if (accessToken == null || accessToken.isEmpty) {
        throw Exception("구글 로그인 토큰을 가져오지 못했습니다.");
      }

      print('구글 로그인 성공! accessToken: $accessToken');
      return accessToken;
    } catch (error) {
      print("로그인 실패: $error");
      throw Exception("Google 로그인 실패!");
    }
  }

  // ✨ Google 로그아웃
  Future<void> logoutWithGoogle() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      await _googleSignIn.signOut(); // ✨ 카카오 → Google 로그아웃
      print('Google 로그아웃 성공!');
    } catch (error) {
      print("로그아웃 실패: $error");
      throw Exception("Google 로그아웃 실패!");
    }
  }

  // ✨ Google 사용자 정보 가져오기
  Future<GoogleSignInAccount?> fetchUserInfoFromGoogle() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      final account = await _googleSignIn.signInSilently(); // ✨ 기존 로그인 사용자 자동 로그인

      if (account == null) {
        print('Google 사용자 정보 없음 (로그인 필요)');
        return null;
      }

      print('User info: ${account.displayName}, ${account.email}');
      return account;
    } catch (error) {
      print('Error fetching user info: $error');
      throw Exception('Google 사용자 정보 가져오기 실패');
    }
  }

  Future<String> requestUserTokenFromServer(String accessToken, int id,
      String email, String nickname, String gender, String ageRange,
      String birthyear) async {
    final url = Uri.parse('$baseUrl/google-oauth/request-user-token');

    print('requestUserTokenFromServer url: $url');

    try {
      print("user_id= $id");
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'access_token': accessToken,
          'user_id': id,
          'email': email,
          'nickname': nickname,
          'gender': gender,
          'age_range': ageRange,
          'birthyear': birthyear,
        }),
      );

      print('Server response status: ${response.statusCode}');
      print('Server response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Server response data: $data');
        return data['userToken'] ?? '';
      } else {
        throw Exception('Failed to request user token: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during request to server: $error');
      throw Exception('Request to server failed: $error');
    }
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common_ui/custom_app_bar.dart';
import '../../../home/presentation/ui/home_page.dart';
import '../providers/google_auth_providers.dart';
import 'google_terms_and_conditions.dart'; // ✅ 약관 다이얼로그 import 추가


class GoogleLoginPage extends StatefulWidget { // ✨ 클래스 이름 대문자화
  @override
  _GoogleLoginPageState createState() => _GoogleLoginPageState(); // ✨ 상태 클래스명 수정
}

class _GoogleLoginPageState extends State<GoogleLoginPage> { // ✨ 클래스명 수정
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(AssetImage('images/login_bg6.png'), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 배경 이미지
          Image.asset(
            'images/login_bg6.png',
            fit: BoxFit.cover,
          ),

          // Foreground Content
          CustomAppBar(
            body: Consumer<GoogleAuthProvider>( // ✨ provider 타입 이름 대문자로 수정
              builder: (context, provider, child) {
                if (provider.isLoggedIn) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    }
                  });
                }

                if (provider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                return Center(
                  child: provider.isLoggedIn
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "로그인 성공!",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )
                    ],
                  )
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: provider.isLoading
                            ? null
                            : () async {
                          // ✨ 구글 로그인 전 약관 동의 처리
                          bool isAgreed =
                          await googleTermsAndConditions(context);
                          if (!isAgreed) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                              content: Text("개인정보 이용 약관에 동의해야 합니다."),
                            ));
                            return;
                          }
                          provider.login();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero, // ✨ 버튼 기본 패딩 제거
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Colors.transparent, // ✨ 배경 제거
                          shadowColor: Colors.transparent, // ✨ 그림자 제거
                        ),
                        child: Image.asset(
                          'images/btn_login_google.png', // ✨ 구글 로그인 버튼 이미지
                          width: 160,
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
            title: 'Google Login', // ✨ UI 텍스트도 대문자화
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:jobstick/kakao_authentication/presentation/ui/kakao_login_page.dart';
import 'package:jobstick/google_authentication/presentation/ui/google_login_page.dart';
import 'package:jobstick/common_ui/custom_app_bar.dart';

class LoginPage extends StatelessWidget {
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
            title: "Login",
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 카카오 로그인 버튼
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => KakaoLoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      minimumSize: Size(150, 50),
                      padding: EdgeInsets.zero,
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/btn_login_kakao.png'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(width: 150, height: 50),
                    ),
                  ),
                  SizedBox(height: 20),

                  // 구글 로그인 버튼
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GoogleLoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      minimumSize: Size(150, 50),
                      padding: EdgeInsets.zero,
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/btn_login_google.png'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(width: 150, height: 50),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
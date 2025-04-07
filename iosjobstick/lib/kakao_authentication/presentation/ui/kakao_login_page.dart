import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common_ui/custom_app_bar.dart';
import '../../../home/presentation/ui/home_page.dart';
import '../providers/kakao_auth_providers.dart';
import 'kakao_terms_and_conditions.dart'; // ✅ 약관 다이얼로그 import 추가


class KakaoLoginPage extends StatefulWidget {
  @override
  _KakaoLoginPageState createState() => _KakaoLoginPageState();
}

class _KakaoLoginPageState extends State<KakaoLoginPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 배경 이미지를 미리 로딩 (프리로딩)
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
            'images/login_bg6.png', // 이미지 경로를 실제 프로젝트에 맞게 수정하세요.
            fit: BoxFit.cover,
          ),

          // Foreground Content
          CustomAppBar(
            body: Consumer<KakaoAuthProvider>(
              builder: (context, provider, child) {
                if (provider.isLoggedIn) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) { // ✅ mounted 체크 추가
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    }
                  });
                }
                if(provider.isLoading) {
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
                        onPressed: provider.isLoading ? null : () // => provider.login(),
                        async {
                          // ✅ 약관 동의 다이얼로그 호출 추가
                          bool isAgreed = await kakaoTermsAndConditions(context);
                          if (!isAgreed) {
                            // ✅ 동의하지 않으면 Snackbar 표시
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("개인정보 이용 약관에 동의해야 합니다.")),
                            );
                            return;
                          }
                          // ✅ 동의한 경우 로그인 실행
                          provider.login();
                        },
                        child: Text("카카오 로그인"),
                      )
                    ],
                  ),
                );
              },
            ),
            title: 'Kakao Login',
          ),
        ],
      ),
    );
  }
}
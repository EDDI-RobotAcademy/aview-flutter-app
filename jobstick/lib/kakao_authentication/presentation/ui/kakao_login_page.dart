import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common_ui/custom_app_bar.dart';
import '../providers/kakao_auth_providers.dart';
import 'package:jobstick/home/presentation/ui/home_page.dart';
import 'kakao_terms_and_conditions.dart'; // 약관 추가

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
                if (provider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                return Center(
                  child: ElevatedButton(
                    onPressed: provider.isLoggedIn ? null : () async {
                      bool isAgreed = await kakaoTermsAndConditions(context);
                      if (!isAgreed) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("개인정보 이용 약관에 동의해야 합니다.")),
                        );
                        return;
                      }

                      await provider.login();

                      if (provider.isLoggedIn) {
                        if (mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                                (Route<dynamic> route) => false,
                          );
                        }
                      }
                    },
                    child: Text("카카오 로그인"),
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
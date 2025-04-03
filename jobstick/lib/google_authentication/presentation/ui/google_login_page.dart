import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common_ui/custom_app_bar.dart';
import '../providers/google_auth_providers.dart';
import 'package:jobstick/home/presentation/ui/home_page.dart';
import 'google_terms_and_conditions.dart'; // 약관 추가

class GoogleLoginPage extends StatefulWidget {
  @override
  _GoogleLoginPageState createState() => _GoogleLoginPageState();
}

class _GoogleLoginPageState extends State<GoogleLoginPage> {
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
            body: Consumer<GoogleAuthProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                return Align(
                  alignment: Alignment(0.0, -0.15),
                  child: ElevatedButton(
                    onPressed: provider.isLoggedIn ? null : () async {
                      bool isAgreed = await GoogleTermsAndConditions(context);
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      minimumSize: Size(150,50),
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
                      child: Container(
                        width: 150,
                        height: 30,
                        alignment: Alignment.center,
                      ),
                    ),
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
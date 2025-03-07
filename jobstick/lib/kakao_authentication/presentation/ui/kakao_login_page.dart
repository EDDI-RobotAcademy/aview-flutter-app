import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common_ui/custom_app_bar.dart';
import '../providers/kakao_auth_providers.dart';

class KakaoLoginPage extends StatefulWidget {
  @override
  _KakaoLoginPageState createState() => _KakaoLoginPageState();
}

class _KakaoLoginPageState extends State<KakaoLoginPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 배경 이미지를 미리 로딩 (프리로딩)
    precacheImage(AssetImage('images/login_bg6.jpg'), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 배경 이미지
          Image.asset(
            'images/login_bg6.jpg', // 이미지 경로를 실제 프로젝트에 맞게 수정하세요.
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
                        onPressed: provider.isLoading ? null : () => provider.login(),
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
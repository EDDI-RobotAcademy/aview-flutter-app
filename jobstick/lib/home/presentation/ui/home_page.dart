import 'package:jobstick/common_ui/custom_app_bar.dart';
import 'package:jobstick/kakao_authentication/presentation/providers/kakao_auth_providers.dart';
import 'package:jobstick/google_authentication/presentation/providers/google_auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final kakaoAuthProvider = context.watch<KakaoAuthProvider>();
    final googleAuthProvider = context.watch<GoogleAuthProvider>();
    final isLoggedIn = kakaoAuthProvider.isLoggedIn || googleAuthProvider.isLoggedIn;
    return Scaffold(
      body: CustomAppBar(
        body: Container(
          width: double.infinity, // 가로 전체 채우기
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/home_bg3.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 150),
              Text(
                isLoggedIn ? "WELCOME" : "Use Your JOBSTICK!",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Text("카카오 로그인 상태: ${kakaoAuthProvider.isLoggedIn ? '로그인됨' : '로그아웃됨'}"),
              Text("구글 로그인 상태: ${googleAuthProvider.isLoggedIn ? '로그인됨' : '로그아웃됨'}"),
            ],
          ),
        ),
      ),
    );
  }
}

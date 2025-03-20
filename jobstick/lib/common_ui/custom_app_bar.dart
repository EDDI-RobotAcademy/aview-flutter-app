import 'package:jobstick/board/board_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jobstick/kakao_authentication/presentation/providers/kakao_auth_providers.dart';
import 'package:provider/provider.dart';

import '../kakao_authentication/kakao_auth_module.dart';
import 'app_bar_action.dart';

class CustomAppBar extends StatelessWidget {
  final String apiUrl = dotenv.env['API_URL'] ?? '';
  final String apiKey = dotenv.env['API_KEY'] ?? '';

  final Widget body;
  final String title;


  CustomAppBar({
    required this.body,
    this.title = 'Home'
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<KakaoAuthProvider>(  // KakaoAuthProvider 상태를 반영
          builder: (context, provider, child) {
            // 로딩 상태일 때 처리
            if (provider.isLoading) {
              return AppBar(
                title: Text("로딩 중"),
              );
            }

            // 로그인 상태에 따라 아이콘 변경
            return AppBar(
              title: SizedBox(
                height: 50,
                child: Image.asset(
                  'images/logo2.png',
                  fit: BoxFit.fitHeight,
                ),
              ),
              backgroundColor: Color.fromARGB(255, 32, 100, 227),
              actions: [
                AppBarAction(
                  icon: Icons.list_alt,
                  tooltip: '게시물 리스트',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BoardModule.provideBoardListPage(),
                      ),
                    );
                  },
                ),
                AppBarAction(
                  icon: provider.isLoggedIn ? Icons.logout : Icons.login,
                  tooltip: provider.isLoggedIn ? 'Logout' : 'Login',
                  iconColor: Colors.white,
                    onPressed: () async{
                      if (provider.isLoggedIn) {
                        await provider.logout();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => KakaoAuthModule.provideKakaoLoginPage()),
                              (route) => false, // 이전의 모든 라우트 삭제
                        );// 로그아웃 실행
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => KakaoAuthModule.provideKakaoLoginPage(),
                          ),
                        );
                      }
                    }
                ),
              ],
            );
          },
        ),
        Expanded(child: body),
      ],
    );
  }
}
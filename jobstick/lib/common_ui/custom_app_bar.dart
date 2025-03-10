import 'package:jobstick/board/board_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
        AppBar(
          title: SizedBox(
            height: 50, // 높이 조정
            child: Image.asset(
              'images/logo1.png',
              fit: BoxFit.fitHeight, // 원본 비율 유지하면서 크기 맞춤
            ),
          ),
          backgroundColor: Color.fromARGB(255, 11, 84, 220),
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
                }
            ),
            AppBarAction(
              icon: Icons.login,
              tooltip: 'Login',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => KakaoAuthModule.provideKakaoLoginPage()
                  ),
                );
              },
            ),
          ],

        ),
        Expanded(child: body)
      ],
    );
  }
}
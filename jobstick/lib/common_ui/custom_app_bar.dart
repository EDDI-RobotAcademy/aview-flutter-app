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
        Consumer<KakaoAuthProvider>(
          builder: (context, provider, child) {
            if(provider.isLoading) {
              return AppBar(
                title: Text("로딩 중"),
              );
            }

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
                        builder: (context) =>
                            BoardModule.provideBoardListPage(),
                      ),
                    );
                  },
                ),
                AppBarAction(
                  icon: provider.isLoggedIn ? Icons.logout : Icons.login,
                  tooltip: provider.isLoggedIn ? 'Logout' : 'Login',
                  onPressed: () {
                    if (provider.isLoggedIn) {
                      provider.logout();
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              KakaoAuthModule.provideKakaoLoginPage(),
                        ),
                      );
                    }
                  },
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
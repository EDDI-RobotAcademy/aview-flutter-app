import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jobstick/kakao_authentication/kakao_auth_module.dart';
import 'package:jobstick/google_authentication/google_auth_module.dart';
import 'package:jobstick/authentication/presentation/ui/login_page.dart';

class LoginModule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers:[
          ...KakaoAuthModule.provideKakaoAuthProviders(),
          ...GoogleAuthModule.provideGoogleAuthProviders(),
        ],
      child: MaterialApp(
        home: LoginPage(),
      ),
    );
  }
}
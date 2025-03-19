import 'package:macjobstick/common_ui/custom_app_bar.dart';
import 'package:macjobstick/kakao_authentication/presentation/providers/kakao_auth_providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final kakaoAuthProvider = Provider.of<KakaoAuthProvider>(context);

    return Scaffold(
      body: CustomAppBar(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/home_bg2.jpg"),
              fit: BoxFit.cover, // 화면에 꽉 차도록 설정
            ),
          ),
          child: Center(
            child: Text(
              "Use Your JOBSTICK!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
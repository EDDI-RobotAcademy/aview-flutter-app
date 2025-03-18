import 'package:jobstick/common_ui/custom_app_bar.dart';
import 'package:jobstick/kakao_authentication/presentation/providers/kakao_auth_providers.dart';
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
              image: AssetImage("images/home_bg3.jpg"),
              fit: BoxFit.cover, // 화면에 꽉 차도록 설정
            ),
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top:100),
              child:Text(
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
      ),
    );
  }
}
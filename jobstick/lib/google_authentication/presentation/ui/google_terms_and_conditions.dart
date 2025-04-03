import 'package:flutter/material.dart';
import 'google_terms_and_conditions_full.dart'; // ✅ 전체 약관 페이지 import

Future<bool> GoogleTermsAndConditions(BuildContext context) async {
  bool isAgreed = false;

  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("개인정보 이용 약관"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("카카오 로그인을 사용하려면 개인정보 이용에 동의해야 합니다."),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Checkbox(
                        value: isAgreed,
                        onChanged: (value) {
                          setState(() {
                            isAgreed = value ?? false;
                          });
                        },
                      ),
                      Text("개인정보 이용 약관에 동의합니다."),
                    ],
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GoogleTermsAndConditionsFull()), // ✅ 전체 약관 보기
                        );
                      },
                      child: Text("자세히 보기", style: TextStyle(color: Colors.blue)),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text("취소"),
                onPressed: () => Navigator.of(context).pop(false), // ❌ 동의 안 함
              ),
              ElevatedButton(
                child: Text("동의"),
                onPressed: () => Navigator.of(context).pop(isAgreed), // ✅ 동의
              ),
            ],
          );
        },
      );
    },
  ) ?? false;
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageButton extends StatelessWidget {
  final String assetPath;
  final int page;
  final bool isCurrentPage;
  final VoidCallback onTap;

  PageButton({
    required this.assetPath,
    required this.page,
    required this.isCurrentPage,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isCurrentPage ? Colors.deepPurple : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              isCurrentPage
                  ? 'images/btn_login_kakao.png'
                  : 'images/logo1.png',
              width: 160, // 크기 조절
              fit: BoxFit.cover
            ),
        )
    );
  }
}
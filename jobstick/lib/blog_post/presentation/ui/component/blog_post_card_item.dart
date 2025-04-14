import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlogPostCardItem extends StatelessWidget {
  final String title;
  final String content;
  final String nickname;
  final String createDate;

  final VoidCallback? onTap;

  BlogPostCardItem({
    required this.title,
    required this.content,
    required this.nickname,
    required this.createDate,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        margin: EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              Text(
                content,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    nickname.isEmpty ? '익명' : nickname,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black87
                    ),
                  ),
                  Text(
                    createDate,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black87
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}
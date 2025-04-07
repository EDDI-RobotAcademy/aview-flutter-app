import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarAction extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final Color iconColor;

  AppBarAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.iconColor = Colors.white,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      tooltip: tooltip,
      onPressed: onPressed,
    );
  }
}
import 'package:flutter/material.dart';

Widget logoAppWidget({
  double size = 50,
}) {
  return ClipOval(
    child: Image.asset(
      'assets/images/logo_app.jpg',
      width: size,
      height: size,
      fit: BoxFit.cover,
    ),
  );
}



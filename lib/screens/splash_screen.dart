import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
            tag: 'auth_logo',
            child: Image.asset('assets/images/auth_background.png')),
      ),
    );
  }
}

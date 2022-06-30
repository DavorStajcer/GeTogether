import 'dart:ui';

import "package:flutter/material.dart";

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Text(
          "GetTogether",
          style: TextStyle(fontSize: 40, color: Colors.white),
        ),
      ),
    );
  }
}

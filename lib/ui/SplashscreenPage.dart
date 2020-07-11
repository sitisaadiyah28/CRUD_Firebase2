import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_sign/main.dart';
import 'package:google_sign/ui/HomePage.dart';


class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  void initState(){
    super.initState();
    startSplashScreen();
  }
  startSplashScreen() async{
    var duration = const Duration(seconds: 5);
    return Timer(duration, () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_){

          return Login();
        }),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height / 3,
          child: Center(
            child: Image(
              image: AssetImage("images/a.png"),
            ),
          ),
        ),
      ),
    );
  }
}
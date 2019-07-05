
import 'package:flutter/material.dart';
import 'package:squadre/screens/SplashScreen.dart';
import 'package:squadre/utils/Utils.dart';

void main() async{
  Utils.readUserData();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'CalibreMedium',
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

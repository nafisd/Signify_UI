import 'package:flutter/material.dart';
import 'dart:async';
import 'package:camera/camera.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const SplashScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(cameras: widget.cameras),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Column(
            children: [ Container(
              width: 100,
              child: Image (image: AssetImage('assets/allPage/Teman_Isyarat_Logo.png'),),
                ),
                Container(
                  width: 100,
                  child: Image(image: AssetImage('assets/allPage/Teman_Isyarat_Name.png'),),
                )
                 ]
                ),
          ],
        ),
      ),
    );
  }
}

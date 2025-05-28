import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ui_sign/QuizPage/quiz.dart';
import 'package:flutter_ui_sign/ui/camera.dart';
import 'package:flutter_ui_sign/ui/kamus.dart';
import 'package:camera/camera.dart';
import 'package:flutter_ui_sign/ui/video.dart';

class HomePage extends StatelessWidget {
  final List<CameraDescription> cameras;

  const HomePage({super.key, required this.cameras});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(248, 189, 230, 255),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/allPage/background.jpg'),
              fit: BoxFit.cover
              )
          ),
          child: SafeArea(   
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
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
                SizedBox(height: 30),
                // Dua kotak biru kecil
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    // kamus
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => KamusPage()),
                        );
                      },
                      child: Container(
                        width: 150,
                        height: 175,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(245, 255, 226, 123),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 20,),
                            Image.asset('assets/allPage/kamus.png', width: 90,),
                            SizedBox(height: 10,),
                            Text(
                              'Kamus Bahasa Isyarat',
                              style: TextStyle(
                                color: Color.fromARGB(255, 234, 128, 7),
                                fontFamily: 'Fredoka',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                              )
                          ],
                        ),
                      ),
                    ),

                    // video pembelajaran
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => YouTubeShortsScreen(genre: 'SIBI'),)
                        );
                      },
                      child: Container(
                        width: 150,
                        height: 175,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color:Color.fromARGB(245, 184, 234, 203),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 20,),
                              Image.asset('assets/allPage/video.png', width: 90,),
                              SizedBox(height: 10,),
                              Text(
                                'Video Pembelajaran',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 3, 167, 99),
                                  fontFamily: 'Fredoka',
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                                )
                            ],
                          ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                 // camera translate
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CameraScreen(camera: cameras.first,)),
                      );
                      },
                      child: Container(
                        width: 150,
                        height: 175,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(239, 255, 211, 220),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 10,),
                            Image.asset(
                                'assets/allPage/cameraIcon.png',
                                width: 90,          
                              ),
                              SizedBox(height: 10,),
                        // space between icon and text
                            Text(
                              'Kamera Terjemahan',
                              style: TextStyle(
                                fontFamily: 'Fredoka',
                                color: Color.fromARGB(255, 255, 70, 107),
                                fontSize: 17,
                                fontWeight: FontWeight.w700
                              ),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),

                    //quiz
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => QuizHomePage(cameras: cameras,)),
                      );
                      },
                      child: Container(
                        width: 150,
                        height: 175,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(237, 34, 165, 246),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 10,),
                            Image.asset(
                                'assets/allPage/games.png',
                                width: 90,          
                              ),
                              SizedBox(height: 10,),
                            Text(
                              'Mari Bermain Menebak',
                              style: TextStyle(
                                fontFamily: 'Fredoka',
                                color: Color.fromARGB(255, 19, 22, 194),
                                fontSize: 17,
                                fontWeight: FontWeight.w700
                              ),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ), 
                
                SizedBox(height: 40),
          
                // Tombol oranye
                Container(
                  width: 120,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(238, 73, 50, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(child: Text("Panduan", style: TextStyle(
                    fontFamily: 'Fredoka',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white70,
                  ),)),
                ),
              ],
            ),
          ),),
        ),
      ),
    );
  }
}

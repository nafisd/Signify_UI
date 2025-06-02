import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_ui_sign/QuizPage/controller/quiz_controller.dart';
import 'package:flutter_ui_sign/controllers/custom_camera_controller.dart';
import 'package:flutter_ui_sign/ui/splash.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

late List<CameraDescription> cameras;

void main() async {
  await Supabase.initialize(
    url: 'https://pkpgkqgfeocasxyndvhn.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBrcGdrcWdmZW9jYXN4eW5kdmhuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDgxODMyMTAsImV4cCI6MjA2Mzc1OTIxMH0.1s-_7edny4FPZvWImwslhd0lZCe9g1rGs583vRVedVk',
  );
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => QuizController(),),
      ChangeNotifierProvider(create: (_) => CustomCameraController()),
    ],
    child:
      const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(cameras : cameras),
    );
  }
}

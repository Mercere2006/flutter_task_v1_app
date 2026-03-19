import 'package:flutter/material.dart';
import 'package:flutter_task_v1_app/views/splash_screen_ui.dart';
import 'package:google_fonts/google_fonts.dart';

// --------------------------------
void main() {
  runApp(
    FlutterTaskV1App(),
  );
}

class FlutterTaskV1App extends StatefulWidget {
  const FlutterTaskV1App({super.key});

  @override
  State<FlutterTaskV1App> createState() => _FlutterTaskV1AppState();
}

class _FlutterTaskV1AppState extends State<FlutterTaskV1App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreenUi(),
      theme: ThemeData(
        textTheme: GoogleFonts.kanitTextTheme(
          Theme.of(context).textTheme
        ),
      ),
    );
  }
}
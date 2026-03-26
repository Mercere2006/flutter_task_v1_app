import 'package:flutter/material.dart';
import 'package:flutter_task_v1_app/views/splash_screen_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


// --------------------------------
void main() async {
  // ----ตั้งค่าการใช้งาน supabase ที่จะทำงาน----
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://lulemwvaycyrwirljrvh.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx1bGVtd3ZheWN5cndpcmxqcnZoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM4OTQ0MDMsImV4cCI6MjA4OTQ3MDQwM30.Q2QRjuSVTtvVz02UaEDhvw6OdOzvi5aPW0FEoCrp8IM',
  );

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
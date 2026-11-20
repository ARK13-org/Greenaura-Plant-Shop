import 'package:flutter/material.dart';
import 'package:pant_app/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GreenAura App',
      home: SplashScreen(),
    );
  }
}

// to run : flutter run -d chrome --web-port 2350

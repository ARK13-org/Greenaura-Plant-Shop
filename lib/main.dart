import 'package:flutter/material.dart';
import 'package:pant_app/screens/splash_screen.dart';
import 'package:pant_app/services/plant_api.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PlantApi.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GreenAura App',
      home: const SplashScreen(),
    );
  }
}

// run : flutter run -d chrome --web-port 2350

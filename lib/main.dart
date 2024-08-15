import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:reclaim/features/barcode-scan/presentation/screens/main_camera_screen.dart';
import 'firebase_options.dart';
import '../core/navigation/navigation.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure initialization of Flutter bindings

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ReClaim',
      theme: ThemeData(fontFamily: 'Inter'),
      home: MainCameraScreen(),
    );
  }
}

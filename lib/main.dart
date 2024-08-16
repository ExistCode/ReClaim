import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:reclaim/features/barcode-scan/presentation/screens/main_camera_screen.dart';
import 'package:reclaim/features/barcode-scan/presentation/screens/scan_successful_screen.dart';
import 'firebase_options.dart';
import '../features/authentication/presentation/screens/sign_up_screen.dart';

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
      home: Navigation(),
      routes: {
        MainCameraScreen.routeName: (context) => const MainCameraScreen(),
        ScanSuccessfulScreen.routeName: (context) =>
            const ScanSuccessfulScreen(),
      },
    );
  }
}

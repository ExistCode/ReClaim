import 'package:aptos/aptos_client.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:reclaim/core/models/app_user.dart';
import 'package:reclaim/features/barcode-scan/presentation/providers/transaction_successful_provider.dart';
import 'package:reclaim/features/barcode-scan/presentation/screens/main_camera_screen.dart';
import 'package:reclaim/features/barcode-scan/presentation/providers/transaction_provider.dart';
import 'package:reclaim/features/barcode-scan/presentation/screens/scan_successful_screen.dart';
import 'package:reclaim/features/wallet/presentation/providers/wallet_providers.dart';
import 'package:reclaim/features/wallet/presentation/screens/wallet_verification_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  final client = AptosClient('https://api.devnet.aptoslabs.com/v1');
  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final AptosClient client;
  const MyApp({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: TransactionProvider(),
        ),
        ChangeNotifierProvider.value(
          value: WalletProvider(),
        ),
        ChangeNotifierProvider.value(
          value: TransactionSuccessfulProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ReClaim',
        theme: ThemeData(fontFamily: 'Inter'),
        home: WalletVerificationScreen(),
        routes: {
          MainCameraScreen.routeName: (context) => const MainCameraScreen(),
          ScanSuccessfulScreen.routeName: (context) =>
              const ScanSuccessfulScreen(),
        },
      ),
    );
  }
}

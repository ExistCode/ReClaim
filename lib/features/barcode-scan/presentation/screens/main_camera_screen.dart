import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class MainCameraScreen extends StatefulWidget {
  const MainCameraScreen({super.key});

  @override
  State<MainCameraScreen> createState() => _MainCameraScreenState();
}

class _MainCameraScreenState extends State<MainCameraScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Scanner')),
      body: SizedBox(
        height: 400,
        child: MobileScanner(onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            print(barcode.rawValue ?? "No Data found in QR");
          }
        }),
      ),
    );
  }
}

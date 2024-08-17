import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reclaim/features/barcode-scan/presentation/data/models/item_count.dart';
import 'package:reclaim/features/barcode-scan/presentation/data/services/item_count_services.dart';
import 'package:reclaim/features/barcode-scan/presentation/screens/providers/transaction_provider.dart';
import '../../../../core/theme/colors.dart' as custom_colors;
import 'dart:convert';

class ScanSuccessfulScreen extends StatefulWidget {
  static const routeName = '/scan-successful-screen';

  const ScanSuccessfulScreen({super.key});

  @override
  _ScanSuccessfulScreenState createState() => _ScanSuccessfulScreenState();
}

class _ScanSuccessfulScreenState extends State<ScanSuccessfulScreen> {
  bool _isVisible = false; // Control the visibility of the checkmark
  static const plasticRate = 10;
  static const canRate = 5;
  static const cartonRate = 3;
  

  @override
  void initState() {
    super.initState();
    // Delay to show the checkmark animation
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _isVisible = true; // Make the checkmark visible
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final codeResult =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);
    final transactionId = codeResult['transactionId'];

    final qrCodeResult = codeResult['qrCodeValue'];

    String validJsonString = qrCodeResult?.replaceAll("'", '"') ?? "{}";

    // Parse the codeResult as JSON
    Map<String, dynamic> resultMap = jsonDecode(validJsonString);

    final qrCodeId = resultMap['id'];

    ItemCount itemCount = parseMessage(resultMap['message']);

    // Parsing the num of items into variable
    int numOfPlastics = itemCount.plastic;
    int numOfCans = itemCount.can;
    int numOfCartons = itemCount.carton;
    double totalTokens = numOfPlastics.toDouble() * plasticRate +
        numOfCans.toDouble() * canRate +
        numOfCartons.toDouble() * cartonRate;

    transactionProvider.updateTransaction(transactionId, qrCodeId,
        numOfPlastics, numOfCans, numOfCartons, totalTokens);

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: custom_colors.primaryBackground,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Checkmark Icon
              AnimatedOpacity(
                opacity: _isVisible ? 1.0 : 0.0,
                duration: Duration(seconds: 1),
                child: Icon(
                  Icons.check_circle,
                  color: custom_colors.accentGreen,
                  size: 100,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Scan Successful!",
                style: TextStyle(
                  color: custom_colors
                      .accentGreen, // Different color for the headline
                  fontSize: 32, // Increased font size
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 50),
              Text(
                "You have gained",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              Text(
                "$totalTokens tokens 🚀",
                style: TextStyle(
                  color:
                      custom_colors.accentGreen, // Different color for tokens
                  fontSize: 32, // Increased font size for tokens
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                "from recycling:",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "$numOfPlastics",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "$numOfCans",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "$numOfCartons",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                    ],
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Plastic bottles",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Cans ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Cartons",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      
                    ],
                  ),
                ],
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: custom_colors.accentGreen,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Back to Scanning',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text for the button
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

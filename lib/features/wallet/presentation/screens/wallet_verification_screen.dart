import 'package:flutter/material.dart';
import 'package:reclaim/core/models/app_user.dart';
import 'package:reclaim/core/navigation/navigation.dart';
import '../providers/wallet_providers.dart';
import 'package:reclaim/core/theme/colors.dart' as custom_colors;

class WalletVerificationScreen extends StatefulWidget {
  static const routeName = '/wallet-verification-screen';
  late AppUser user;
  WalletVerificationScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<WalletVerificationScreen> createState() =>
      _WalletVerificationScreenState();
}

class _WalletVerificationScreenState extends State<WalletVerificationScreen> {
  final TextEditingController _walletIdController = TextEditingController();
  String _verificationMessage = '';
  final _verificationLogic = WalletProvider();

  Future<void> _verifyWalletId() async {
    String walletId = _walletIdController.text.trim();

    if (walletId.isEmpty) {
      setState(() {
        _verificationMessage = 'Please enter a wallet ID.';
      });
      return;
    }

    setState(() {
      _verificationMessage = 'Verifying...';
    });

    final message = await _verificationLogic.WalletVerificationId(walletId);

    setState(() {
      _verificationMessage = message;
    });

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => Navigation(user: widget.user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: custom_colors.primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(padding: EdgeInsets.only(top: 100)),
              Text(
                'Verify Your Wallet',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: _walletIdController,
                decoration: InputDecoration(
                  labelText: 'Enter Wallet ID',
                  labelStyle: TextStyle(color: custom_colors.accentGreen),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: custom_colors.darkGray),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: custom_colors.accentGreen),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: custom_colors.darkGray,
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _verifyWalletId,
                child: Text(
                  'Verify Wallet ID',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: custom_colors.accentGreen,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Text(
                _verificationMessage,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

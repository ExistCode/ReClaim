import 'package:flutter/material.dart';
import '../providers/wallet_providers.dart';
import 'package:reclaim/core/theme/colors.dart' as custom_colors;

class WalletVerificationScreen extends StatefulWidget {
  static const routeName = '/wallet-verification-screen';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: custom_colors.primaryBackground,
      appBar: AppBar(
        title: Text('Wallet Verification'),
        backgroundColor: custom_colors.accentGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _walletIdController,
              decoration: InputDecoration(
                labelText: 'Enter Wallet ID',
                labelStyle: TextStyle(color: custom_colors.accentGreen),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: custom_colors.accentGreen),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyWalletId,
              child: Text('Verify Wallet ID'),
            ),
            const SizedBox(height: 20),
            Text(
              _verificationMessage,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

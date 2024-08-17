import 'package:flutter/material.dart';
import 'package:reclaim/core/theme/colors.dart' as custom_colors;
import 'package:reclaim/features/wallet/presentation/screens/wallet_regist_screen.dart';
// Import your screen files

class WalletAuthScreen extends StatefulWidget {
  static const routeName = '/wallet-auth-screen';
  const WalletAuthScreen({super.key});

  @override
  State<WalletAuthScreen> createState() => _WalletAuthScreenState();
}

class _WalletAuthScreenState extends State<WalletAuthScreen> {
  // void _navigateToExistingWallet() {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(builder: (context) => ExistingWalletScreen()),
  //   );
  // }

  void _navigateToCreateWallet() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => WalletCreationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: custom_colors.primaryBackground,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Already have a\nMaschain wallet?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  //
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () {},
                      // _navigateToExistingWallet,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: custom_colors.accentGreen,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Yes, I have a wallet',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 300,
                    child: OutlinedButton(
                      onPressed: _navigateToCreateWallet,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: custom_colors.accentGreen),
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'No, create a new wallet',
                        style: TextStyle(
                            fontSize: 16, color: custom_colors.accentGreen),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

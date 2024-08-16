import 'package:aptos/models/entry_function_payload.dart';
import 'package:aptos/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:aptos/aptos.dart';
import '../../../../core/theme/colors.dart' as custom_colors;

class WalletRegistrationScreen extends StatefulWidget {
  final AptosClient client;

  WalletRegistrationScreen({required this.client});

  @override
  _WalletRegistrationScreenState createState() =>
      _WalletRegistrationScreenState();
}

class _WalletRegistrationScreenState extends State<WalletRegistrationScreen> {
  final TextEditingController _walletController = TextEditingController();
  String _message = '';

  Future<void> _showRegistrationDialog() async {
    bool walletExists = await _checkWalletExists(_walletController.text.trim());

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: custom_colors.darkGrayVariant,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            walletExists
                ? 'Succcess, Valid Wallet'
                : 'Oops, Wallet Is Not Registered',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            walletExists
                ? 'This wallet is already registered. Click "Confirm" to proceed.'
                : 'This address is not a valid Aptos wallet. Click "Create" to register a new wallet.',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (!walletExists) {
                      _registerUser();
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: custom_colors.accentGreen,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                  ),
                  child: Text(
                    walletExists ? 'Confirm' : 'Create',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cancel action
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<bool> _checkWalletExists(String walletAddress) async {
    try {
      final response = await widget.client.getAccountResource(
        walletAddress,
        '0x1bcdd770a0bffb23cbad2de13ff89f0275180bd3feb7f421a2b330f6e0b5db72::reclaim::User',
      );

      return response != null;
    } catch (e) {
      return false;
    }
  }

  void _registerUser() async {
    String walletAddress = _walletController.text.trim();

    if (walletAddress.isEmpty) {
      setState(() {
        _message = 'Please enter a wallet address.';
      });
      return;
    }

    try {
      await _callRegisterUserFunction(walletAddress);
      setState(() {
        _message = 'User registered successfully!';
      });
    } catch (e) {
      setState(() {
        _message = 'Error registering user: $e';
      });
    }
  }

  Future<void> _callRegisterUserFunction(String walletAddress) async {
    final module =
        '0x1bcdd770a0bffb23cbad2de13ff89f0275180bd3feb7f421a2b330f6e0b5db72::reclaim';
    final function = 'register_user';
    final typeArguments = <String>[];
    final arguments = [walletAddress];

    if (await _checkWalletExists(walletAddress)) {
      setState(() {
        _message = 'Wallet address already registered.';
      });
      return;
    }

    try {
      const sender = 'YOUR_SENDER_ADDRESS';
      final entryFunctionPayload = EntryFunctionPayload(
        functionId: '$module::$function',
        typeArguments: typeArguments,
        arguments: arguments,
      );

      final rawTxn = await widget.client.generateRawTransaction(
        sender,
        entryFunctionPayload as TransactionPayload,
      );

      // Note: You'll need to implement signTransaction yourself
      // This might involve integrating with a wallet or using a local private key
      final signedTxn = await signTransaction(rawTxn);

      final transactionRes = await widget.client
          .submitTransaction(signedTxn as TransactionRequest);

      // Wait for transaction to be processed
      await widget.client.waitForTransaction(transactionRes.hash);

      print('Transaction successful');
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<SignedTransaction> signTransaction(RawTransaction rawTxn) async {
    // Implement your transaction signing logic here
    // This might involve using a wallet interface or a securely stored private key
    throw UnimplementedError('Transaction signing not implemented');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: custom_colors.primaryBackground,
        elevation: 0,
        title: Text(
          'Register Your Wallet',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: custom_colors.primaryBackground,
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/aptos-logo.png', height: 180),
              SizedBox(height: 40),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: custom_colors.darkGrayVariant,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _walletController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Aptos Wallet Address',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: custom_colors.accentGreen),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: custom_colors.darkGrayVariant,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _showRegistrationDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: custom_colors.accentGreen,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Proceed',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    _message != '' ? SizedBox(height: 20) : Container(),
                    Text(
                      _message,
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reclaim/core/navigation/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reclaim/core/theme/colors.dart' as custom_colors;

import '../../../../core/models/app_user.dart';

class WalletCreationPage extends StatefulWidget {
  late AppUser user;

  WalletCreationPage({required this.user});

  @override
  _WalletCreationPageState createState() => _WalletCreationPageState();
}

class _WalletCreationPageState extends State<WalletCreationPage> {
  final Dio _dio = Dio();
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _ic = '';
  String _walletName = '';
  String? _walletAddress;

  Future<void> _createWallet() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final url = '${dotenv.env['API_URL']}/api/wallet/create-user';
      final options = Options(
        headers: {
          'client_id': dotenv.env['CLIENT_ID'],
          'client_secret': dotenv.env['CLIENT_SECRET'],
          'Content-Type': 'application/json',
        },
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      );
      final data = {
        'name': _name,
        'email': _email,
        'ic': _ic,
        'walletName': _walletName,
      };

      try {
        print('Sending request to: $url');
        print('Headers: ${options.headers}');
        print('Body: $data');

        final response = await _dio.post(
          url,
          options: options,
          data: data,
        );

        print('Response status code: ${response.statusCode}');
        print('Response headers: ${response.headers}');
        print('Response body: ${response.data}');

        if (response.statusCode == 200) {
          final result = response.data;
          final walletAddress = result['result']['wallet']['wallet_address'];

          setState(() {
            _walletAddress = walletAddress;
          });

          // Store wallet address in SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('walletAddress', walletAddress);

          Fluttertoast.showToast(
            msg: 'User created successfully!\nWallet address: $walletAddress',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => Navigation(
                user: widget.user,
              ),
            ),
          );
        } else {
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: 'Failed to create user: ${response.statusCode}',
          );
        }
      } on DioException catch (e) {
        print('Dio error: ${e.message}');
        print('Response data: ${e.response?.data}');
        Fluttertoast.showToast(
          msg: 'Error creating user: ${e.message}',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
      } catch (error) {
        print('Error creating user: $error');
        Fluttertoast.showToast(
          msg: 'Error creating user',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadWalletAddress();
  }

  Future<void> _loadWalletAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final storedWalletAddress = prefs.getString('walletAddress');
    if (storedWalletAddress != null) {
      setState(() {
        _walletAddress = storedWalletAddress;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: custom_colors.primaryBackground,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(padding: EdgeInsets.all(20)),
                Text(
                  'Enter Your Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 24),
                _buildTextField('Name', (value) => _name = value!),
                SizedBox(height: 20),
                _buildTextField('Email', (value) => _email = value!),
                SizedBox(height: 20),
                _buildTextField('IC', (value) => _ic = value!),
                SizedBox(height: 20),
                _buildTextField('Wallet Name', (value) => _walletName = value!),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _walletAddress == null ? _createWallet : null,
                  child: Text(
                    _walletAddress == null ? 'Create Wallet' : 'Wallet Created',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                if (_walletAddress != null)
                  Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: custom_colors.darkGray,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Wallet Created Successfully!',
                            style: TextStyle(
                              color: custom_colors.accentGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Wallet Address:',
                            style: TextStyle(color: Colors.white70),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${_walletAddress!.substring(0, 6)}...${_walletAddress!.substring(_walletAddress!.length - 4)}',
                            style: TextStyle(
                              color: custom_colors.accentGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String?) onSaved) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: custom_colors.accentGreen),
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
      validator: (value) => value!.isEmpty ? 'Please enter your $label' : null,
      onSaved: onSaved,
    );
  }
}

// providers/wallet_provider.dart

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletProvider extends ChangeNotifier {
  final Dio _dio = Dio();
  String? _walletAddress;

  String? get walletAddress => _walletAddress;

  Future<void> createWallet(
      String name, String email, String ic, String walletName) async {
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
      'name': name,
      'email': email,
      'ic': ic,
      'walletName': walletName,
    };

    try {
      final response = await _dio.post(url, options: options, data: data);

      if (response.statusCode == 200) {
        final result = response.data;
        _walletAddress = result['result']['wallet']['wallet_address'];

        // Store wallet address in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('walletAddress', _walletAddress!);

        Fluttertoast.showToast(
          msg: 'User created successfully!\nWallet address: $_walletAddress',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );

        // Notify listeners that the wallet address has changed
        notifyListeners();
      } else {
        throw Exception('Failed to create user: ${response.statusCode}');
      }
    } on DioError catch (e) {
      Fluttertoast.showToast(
        msg: 'Error creating user: ${e.message}',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Error creating user',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Future<void> loadWalletAddress() async {
    final prefs = await SharedPreferences.getInstance();
    _walletAddress = prefs.getString('walletAddress');
    notifyListeners(); // Notify listeners that the wallet address has been loaded
  }
}

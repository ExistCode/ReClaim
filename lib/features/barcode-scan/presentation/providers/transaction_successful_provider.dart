// providers/transaction_successful_provider.dart

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TransactionSuccessfulProvider extends ChangeNotifier {
  final Dio _dio = Dio();

  Future<void> transferTokens({
    required String toAddress,
    required String amount,
    required String contractAddress,
    required String callbackUrl,
  }) async {
    final url = '${dotenv.env['API_URL']}/api/token/token-transfer';
    final options = Options(
      headers: {
        'client_id': dotenv.env['CLIENT_ID_TOKEN'],
        'client_secret': dotenv.env['CLIENT_SECRET_TOKEN'],
        'Content-Type': 'application/json',
      },
      sendTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    );

    final data = {
      'wallet_address': dotenv.env['ORGANIZATION_WALLET_ADDRESS'],
      'to': toAddress,
      'amount': amount,
      'contract_address': contractAddress,
      'callback_url': callbackUrl,
    };

    try {
      final response = await _dio.post(url, options: options, data: data);

      if (response.statusCode == 200) {
        final result = response.data;
        final transactionHash = result['result']['transactionHash'];
        final status = result['result']['status'];

        Fluttertoast.showToast(
          msg: 'Token transfer initiated. Status: $status',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );

        print('Transaction Hash: $transactionHash');
        notifyListeners();
      } else {
        throw Exception('Failed to transfer tokens: ${response.statusCode}');
      }
    } on DioError catch (e) {
      Fluttertoast.showToast(
        msg: 'Error transferring tokens: ${e.message}',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Error transferring tokens',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:reclaim/core/models/app_user.dart';
import 'package:reclaim/core/providers/user_provider.dart';
import 'package:reclaim/features/barcode-scan/data/models/transaction_model.dart';
import 'package:reclaim/features/barcode-scan/presentation/providers/transaction_provider.dart';

class BalanceProvider extends ChangeNotifier {
  TransactionProvider _transactionProvider = TransactionProvider();
  UserProvider _userProvider = UserProvider();
  double _lifetimeEarnings = 0.0;
  int _recycledItems = 0;

  double get lifetimeEarnings => _lifetimeEarnings;
  int get recycledItems => _recycledItems;

  Future<void> fetchUserTransaction() async {
    await _transactionProvider.fetchTransactionsByUserId(
        _userProvider.getCurrentUserUid()!);
    _calculateEarnings();
    // Use the fetched transaction data in your page
    _displayTransactionDetails();
  }

  void _displayTransactionDetails() {
    // Access the fetched transaction data from _transactionProvider.loadedTransactionList
    // TransactionModel fetchedTransaction =
    //     _transactionProvider.loadedTransactionList.first;
    if (_transactionProvider.loadedTransactionList.isEmpty) {
      print("No transactions found.");
    } else {
      // Display the transaction details in your page
      print(
          "the fetched transaction sample are = ${_transactionProvider.loadedTransactionList[2].pointsRedeemed}");
      return; // Exit the method early
    }
  }

  void _calculateEarnings() {
    double templifetimeEarnings = 0.0;
    int templifetimeRecycledItems = 0;

    // for (int x = 0 ;(x < _transactionProvider.loadedTransactionList.length); x++){
    for (var transaction in _transactionProvider.loadedTransactionList) {
      try {
        if (transaction.userId == _userProvider.getCurrentUserUid()) {
          templifetimeEarnings += transaction.pointsRedeemed;
          templifetimeRecycledItems += transaction.numOfCan +
              transaction.numOfCartons +
              transaction.numOfPlastic;

          print("Current earnings: ${templifetimeEarnings}");
        }
      } on Exception catch (e) {
        print("Can't Calculate!! The error message is ${e}");
      }
    }

    _lifetimeEarnings = templifetimeEarnings;
    _recycledItems = templifetimeRecycledItems;
  }
}

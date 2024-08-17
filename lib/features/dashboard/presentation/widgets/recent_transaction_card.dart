import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:reclaim/core/models/app_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:reclaim/features/barcode-scan/data/models/transaction_model.dart';
import 'package:reclaim/features/barcode-scan/presentation/providers/transaction_provider.dart';

import '../../../../core/theme/colors.dart' as custom_colors;

class RecentTransactionsCard extends StatefulWidget {
  final AppUser user;
  const RecentTransactionsCard({required this.user});

  @override
  State<RecentTransactionsCard> createState() => _RecentTransactionsCardState();
}

class _RecentTransactionsCardState extends State<RecentTransactionsCard> {



  @override
  Widget build(BuildContext context) {

    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40), topRight: Radius.circular(40)),
      child: Container(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        width: double.infinity,
        color: custom_colors.darkGray,
        child: Column(
          children: [
            Container(
              height: 3,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Transactions',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.7), fontSize: 16),
                ),
                Icon(
                  Icons.sort_rounded,
                  size: 30,
                  color: Colors.white.withOpacity(0.4),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ExpandedRecentTransactionsCard extends StatefulWidget {
  AppUser user;
  ExpandedRecentTransactionsCard({required this.user});

  @override
  State<ExpandedRecentTransactionsCard> createState() => _ExpandedRecentTransactionsCardState();
}

class _ExpandedRecentTransactionsCardState extends State<ExpandedRecentTransactionsCard> {

  TransactionProvider _transactionProvider = TransactionProvider();
  List<TransactionModel> _transactionList = [];
  int _uniqueDateCount = 0;
  
  @override
  void initState() {
    super.initState();
    _fetchAllTransaction();
  }

  Future<void> _fetchAllTransaction() async {
    await _transactionProvider.fetchTransactionId();
    await _transactionProvider.fetchAllTransactions();
    // Use the fetched transaction data in your page
    _displayTransactionDetails();
    _retrieveRecentTransactions();
  }

  void _displayTransactionDetails() {
    // Access the fetched transaction data from _transactionProvider.loadedTransactionList
    if (_transactionProvider.loadedTransactionList.isEmpty) {
    print("No transactions found.");
    }else{
    // Display the transaction details in your page
    print("the fetched transaction sample are = ${_transactionProvider.loadedTransactionList[2].pointsRedeemed}");
    return; // Exit the method early
    }
  }


  void _retrieveRecentTransactions() {
    List<TransactionModel> _tempTransactionList = [];
    int txLastIndex = _transactionProvider.loadedTransactionList.length - 1;
    int tempUniqueDateCount = 0;

    // Ensure there are at least 5 transactions to process
    if (txLastIndex < 4) {
      print("Not enough transactions to process. current transaction count: ${txLastIndex+1}");
      return;
    }

    for (int i = txLastIndex; i > (txLastIndex - 5); i--) {
      try {
        if (_transactionProvider.loadedTransactionList[i] != null) {
          _tempTransactionList.add(_transactionProvider.loadedTransactionList[i]);

          // Ensure there is a previous transaction to compare with
          if (i > 0) {
            String currentTransactionDate = DateFormat('dd MMM yy').format(_transactionProvider.loadedTransactionList[i].dateRedeemed);
            String previousTransactionDate = DateFormat('dd MMM yy').format(_transactionProvider.loadedTransactionList[i - 1].dateRedeemed);

            print("Current transaction date: ${currentTransactionDate} " + "Previous transaction date: ${previousTransactionDate}");
            if (i == txLastIndex) {
              tempUniqueDateCount++;
            } else {
              if (currentTransactionDate != previousTransactionDate) {
                tempUniqueDateCount++;
              }
            }
          } else {
            // Handle the case where there is no previous transaction
            String currentTransactionDate = DateFormat('dd MMM yy').format(_transactionProvider.loadedTransactionList[i].dateRedeemed);
            print("Current transaction date: ${currentTransactionDate}");
            tempUniqueDateCount++;
          }

          print("Current unique date count: ${tempUniqueDateCount}");
          print("Current transaction count: ${i}");
          print("Current temptransaction: ${_tempTransactionList[_tempTransactionList.length - 1].pointsRedeemed}");
        }
      } catch (e) {
        print("Error processing transaction at index $i: $e");
      }
    }
    setState(() {
      _transactionList = _tempTransactionList;
      _uniqueDateCount = tempUniqueDateCount;
    });
  }
  // void _retrieveRecentTransactions() {
  //   List<TransactionModel> _tempTransactionList = [];
  //   int txLastIndex = _transactionProvider.loadedTransactionList.length-1;
  //   int tempUniqueDateCount = 0;

  //   for (int i = txLastIndex;  i > (txLastIndex-5); i--){  
  //     try {
  //       if (_transactionProvider.loadedTransactionList[i] != null){
  //         _tempTransactionList.add(_transactionProvider.loadedTransactionList[i]);

  //         String currentTransactionDate = DateFormat('dd MMM yy').format(_transactionList[i].dateRedeemed);
  //         String previousTransactionDate = DateFormat('dd MMM yy').format(_transactionList[i-1].dateRedeemed);

  //         print("Current transaction date: ${currentTransactionDate} " + "Previous transaction date: ${previousTransactionDate}");
  //         if (i == txLastIndex){
  //           tempUniqueDateCount++;
  //         } else {
  //           if (currentTransactionDate != previousTransactionDate){
  //             tempUniqueDateCount++;
  //           }
  //         }
  //         print("Current unique date count: ${tempUniqueDateCount}");
  //         print("Current transaction count: ${i}");
  //         print("Current temptransaction: ${_tempTransactionList[_tempTransactionList.length-1].pointsRedeemed}");

  //       }
  //     } on Exception catch (e) {
  //       print("Can't Retrieve!! The error message is ${e}" );
  //     }
  //   }
  //   setState(() {
  //     _transactionList = _tempTransactionList;
  //     _uniqueDateCount = tempUniqueDateCount;
  //   });
  //   print("Current transaction length : ${_transactionList.length.toString()} Last Point : ${_transactionList[2].pointsRedeemed}");
  // }

  @override
  Widget build(BuildContext context) { 
    
    // List<DateTime> distinctDateList =
    //     Provider.of<TransactionProvider>(context).distinctDateList;

    // if (distinctDateList.length > 3) {
    //   distinctDateList = distinctDateList.sublist(0, 3);
    // } //Only Shows Last 3 Days

    // List<Transaction> transactionList =
    //     Provider.of<TransactionProvider>(context).transactionList;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40), topRight: Radius.circular(40)),
      child: Container(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        width: double.infinity,
        height: double.infinity,
        color: custom_colors.darkGray,
        child: Column(
          children: [
            Container(
              height: 3,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Activities',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.7), fontSize: 16),
                ),
                Icon(
                  Icons.sort_rounded,
                  size: 30,
                  color: Colors.white.withOpacity(0.4),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                decoration: BoxDecoration(
                  color: custom_colors.darkGray,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                child: _transactionList.isEmpty
                    ? Center(
                        child: Text(
                          'No Recent Transactions\nFor This Month',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.2)),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: _uniqueDateCount,
                        itemBuilder: (_, i) {
                          return Column(
                            children: [
                              Container(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      DateFormat('dd MMM')
                                          .format(_transactionList[i].dateRedeemed),
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white.withOpacity(0.4)),
                                    ),
                                    Column(
                                      children: _transactionList.map((tx) {
                                        if (tx.dateRedeemed != null &&
                                            DateFormat('dd MMM')
                                                    .format(tx.dateRedeemed) ==
                                                DateFormat('dd MMM')
                                                    .format(_transactionList[i].dateRedeemed)) {
                                          return Container(
                                            height: 50,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Points Redeemed',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  "+ ${tx.pointsRedeemed.toString()} RCLM",
                                                  style: TextStyle(
                                                      color: custom_colors.accentGreen,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      }).toList(),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                            ],
                          );
                        },
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

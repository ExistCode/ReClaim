import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../data/models/transaction_model.dart';


class TransactionProvider with ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  List<String> transactionIdList = [];
  List<TransactionModel> loadedTransactionList = [];

  Future<void> createNewTransaction(
    
    String transactionId,
    String qrCodeId,
    String userId,
    int numOfPlastic,
    int numOfCan,
    int numOfCartons,
    int numOfMiscItems,
    double pointsRedeemed,
  ) async {
    try {
      await _firebaseFirestore.collection('Transaction').doc().set({
        "id": transactionId,
        "qrCodeId": qrCodeId,
        "userId": userId,
        "numOfPlastic": numOfPlastic,
        "numOfCans": numOfCan,
        "numOfCartons": numOfCartons,
        "numOfMiscItems": numOfMiscItems,
        "pointsRedeemed": pointsRedeemed,
        "dateRedeemed": DateTime.now(), // Use the provided dateRedeemed
      });
      print('Transaction created successfully: $transactionId');
    } catch (error) {
      print('Failed to create transaction: $error');
      throw error; // Rethrow the error if needed
    }
  }

  Future<void> updateTransaction(String transactionId,
      int numOfPlastic,
      int numOfCan,
      int numOfCartons,
      int numOfMiscItems,
      double pointsRedeemed) async{
    await FirebaseFirestore.instance
        .collection('Transaction')
        .doc(transactionId)
        .update({
          "transactionId": transactionId,
      "numOfPlastic": numOfPlastic,
      "numOfCans": numOfCan,
      "numOfCartons": numOfCartons,
      "numOfMiscItems": numOfMiscItems,
      "pointsRedeemed": pointsRedeemed, });
    print('Added notes');
  }

  Future<void> fetchTransactionId() async {
    print('Fetching transaction IDs...');
    try {
      final snapshot = await _firebaseFirestore.collection('Transaction').get();
      transactionIdList = snapshot.docs.map((doc) => doc.reference.id).toList();
      print('Success! Fetched transaction ID List: $transactionIdList');
    } catch (error) {
      print('Error fetching transaction IDs: $error');
    }
  }

  Future<void> fetchAllTransactions() async {
    for (String transactionId in transactionIdList) {
      await fetchTransactionFromID(transactionId);
    }
    print('All transactions fetched successfully.');
  }

  Future<void> fetchTransactionFromID(String transactionId) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('Transaction')
          .doc(transactionId)
          .get();

      if (snapshot.exists) {
        TransactionModel loadedTransaction = TransactionModel(
          transactionId: transactionId,
          qrCodeId: snapshot.data()!['qrCodeId'],
          userId: snapshot.data()!['userId'],
          numOfPlastic: snapshot.data()!['numOfPlastic'],
          numOfCan: snapshot.data()!['numOfCans'],
          numOfCartons: snapshot.data()!['numOfCartons'],
          numOfMiscItems: snapshot.data()!['numOfMiscItems'],
          pointsRedeemed: snapshot.data()!['pointsRedeemed'],
          dateRedeemed: (snapshot.data()!['dateRedeemed'] as Timestamp)
              .toDate(), // Convert Timestamp to DateTime
        );

        loadedTransactionList.add(loadedTransaction);
        print('Fetched transaction: ${loadedTransaction.transactionId}');
      } else {
        print('No transaction found for ID: $transactionId');
      }
    } catch (error) {
      print('Error fetching transaction with ID $transactionId: $error');
    }
  }
}


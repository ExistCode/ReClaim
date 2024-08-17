import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../data/models/transaction_model.dart';


class TransactionProvider with ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  List<String> transactionIdList = [];
  List<TransactionModel> loadedTransactionList = [];

  Future<String> createNewTransaction(
    String qrCodeId,
    String userId,
    int numOfPlastic,
    int numOfCan,
    int numOfCartons,
    
    double pointsRedeemed,
  ) async {
    try {
      // Create a new document reference with an auto-generated ID
      DocumentReference newTransactionRef =
          _firebaseFirestore.collection('transaction').doc();

      // Set the data for the new document
      await newTransactionRef.set({
        "id": newTransactionRef.id, // Use the auto-generated ID
        "qrCodeId": qrCodeId,
        "userId": userId,
        "numOfPlastic": numOfPlastic,
        "numOfCans": numOfCan,
        "numOfCartons": numOfCartons,
        "pointsRedeemed": pointsRedeemed,
        "dateRedeemed": DateTime.now(), // Use the current date
      });

      print('Transaction created successfully: ${newTransactionRef.id}');
      return newTransactionRef.id; // Return the generated ID
    } catch (error) {
      print('Failed to create transaction: $error');
      throw error; // Rethrow the error if needed
    }
  }
  Future<void> updateTransaction(
    String transactionId,
    String qrCodeId,
    int numOfPlastic,
    int numOfCan,
    int numOfCartons,
    double pointsRedeemed
    ) async{
    await FirebaseFirestore.instance
        .collection('transaction')
        .doc(transactionId)
        .update({
          "qrCodeId": qrCodeId,
      "numOfPlastic": numOfPlastic,
      "numOfCans": numOfCan,
      "numOfCartons": numOfCartons,
      "pointsRedeemed": pointsRedeemed, });
    print('Added Transaction');
  }

  Future<void> fetchTransactionId() async {
    print('Fetching transaction IDs...');
    try {
      final snapshot = await _firebaseFirestore.collection('transaction').get();
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
          .collection('transaction')
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
          pointsRedeemed: snapshot.data()!['pointsRedeemed'],
          dateRedeemed: (snapshot.data()!['dateRedeemed'] as Timestamp)
              .toDate(), // Convert Timestamp to DateTime
        );

        loadedTransactionList.add(loadedTransaction);
        print('Fetched transaction: ${loadedTransaction.transactionId}\n');
      } else {
        print('No transaction found for ID: $transactionId');
      }
    } catch (error) {
      print('Error fetching transaction with ID $transactionId: $error');
    }
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/app_user.dart'; // Ensure this path matches your project structure

class UserProvider with ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  List<AppUser> loadedUserList = [];

  Future<String> createNewUser(
    String uid,
    String email,
    String? name,
    String? ic,
    String? walletName,
    String walletAddress,
  ) async {
    try {
      // Create a new document reference with an auto-generated ID
      DocumentReference newUserRef = _firebaseFirestore.collection('users').doc(uid);

      // Set the data for the new document 
      await newUserRef.set({
        "uid": uid,
        "email": email,
        "name": name,
        "ic": ic,
        "walletName": walletName,
        "walletAddress": walletAddress,
      });

      print('User created successfully: $uid');
      return uid; // Return the user ID
    } catch (error) {
      print('Failed to create user: $error');
      throw error; // Rethrow the error if needed
    }
  }

  Future<void> updateUser(
    String uid,
    String? email,
    String? name,
    String? ic,
    String? walletName,
    String? walletAddress,
  ) async {
    try {
      await _firebaseFirestore.collection('users').doc(uid).update({
        "email": email,
        "name": name,
        "ic": ic,
        "walletName": walletName,
        "walletAddress": walletAddress,
      });
      print('User updated successfully: $uid');
    } catch (error) {
      print('Failed to update user: $error');
    }
  }

  Future<void> fetchAllUsers() async {
    print('Fetching all users...');
    try {
      final snapshot = await _firebaseFirestore.collection('users').get();
      loadedUserList = snapshot.docs.map((doc) {
        final data = doc.data();
        return AppUser(
          uid: data['uid'],
          email: data['email'],
          name: data['name'],
          ic: data['ic'],
          walletName: data['walletName'],
          walletAddress: data['walletAddress'],
        );
      }).toList();
      print('Success! Fetched user list: ${loadedUserList.length} users.');
    } catch (error) {
      print('Error fetching users: $error');
    }
  }

  Future<AppUser?> fetchUserById(String uid) async {
    try {
      final snapshot = await _firebaseFirestore.collection('users').doc(uid).get();

      if (snapshot.exists) {
        final data = snapshot.data()!;
        AppUser user = AppUser(
          uid: data['uid'],
          email: data['email'],
          name: data['name'],
          ic: data['ic'],
          walletName: data['walletName'],
          walletAddress: data['walletAddress'],
        );
        print('Fetched user: ${user.uid}');
        return user;
      } else {
        print('No user found for UID: $uid');
        return null;
      }
    } catch (error) {
      print('Error fetching user with UID $uid: $error');
      return null;
    }
  }
}
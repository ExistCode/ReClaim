import 'package:flutter/material.dart';

class AppUser {
  final String uid;
  final String? email;
  final String? name;
  final String? ic;
  final String? walletName;
  final String? walletAddress;
  final String? walletBalance;
  // Add other necessary user properties

  AppUser({
    required this.uid,
    required this.email,
    this.name,
    this.ic,
    this.walletName,
    this.walletAddress,
    this.walletBalance,
    // Add other necessary parameters
  });
}
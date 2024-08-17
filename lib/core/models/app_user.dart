import 'package:flutter/material.dart';

class AppUser {
  final String uid;
  final String? email;
  final String? name;
  final String? ic;
  final String? walletName;
  final String? walletAddress;
  // Add other necessary user properties

  AppUser({
    required this.uid,
    this.email,
    this.name,
    this.ic,
    this.walletName,
    this.walletAddress,
    // Add other necessary parameters
  });
}
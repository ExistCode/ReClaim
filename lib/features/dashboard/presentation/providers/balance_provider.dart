import 'package:flutter/material.dart';

class BalanceProvider extends ChangeNotifier {
  double _lifetimeEarnings = 0.0;
  int _recycledItems = 0;

  double get lifetimeEarnings => _lifetimeEarnings;
  int get recycledItems => _recycledItems;

  void fetchDashboardData(double updatedLifetimeEarnings, int updatedRecycledItems) {
    // Update the lifetime earnings and recycled items with the new values
    _lifetimeEarnings = updatedLifetimeEarnings;
    _recycledItems = updatedRecycledItems;

    notifyListeners();
  }
}
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reclaim/features/dashboard/presentation/widgets/main_balance_card.dart';
import '../../../../core/theme/colors.dart' as custom_colors;

import 'package:provider/provider.dart';
import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';
import '../../../../core/navigation/navigation.dart';
import '../widgets/main_menu_action_button.dart';
import '../widgets/recent_transaction_card.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  //Get BottomNavBar from GlobalKey to access onTap
  BottomNavigationBar get navigationBar {
    return NavigationState.globalKey.currentWidget as BottomNavigationBar;
  }

  @override
  Widget build(BuildContext context) {
    double totalSpending = 500;

    // if (TransactionProvider.isLoading == true && timerHasStrarted == false) {
    //   startLoading();
    // }

    return Container(
      color: custom_colors.primaryBackground,
      width: double.infinity,
      height: double.infinity,
      child: RefreshIndicator(
        color: custom_colors.accentGreen,
        onRefresh: () async {
          return Future<void>.delayed(
            Duration(seconds: 1),
            (() {
              // Provider.of<TransactionProvider>(context, listen: false)
              //     .updateTransactionData();
              // Provider.of<UserProvider>(context, listen: false)
              //     .updateUserData();
            }),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  MainBalanceCard(),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
            Expanded(
              child: DraggableBottomSheet(
                minExtent: 110,
                barrierColor: Colors.transparent,
                curve: Curves.easeIn,
                expansionExtent: 0.5,
                onDragging: (pos) {},
                previewWidget: RecentTransactionsCard(),
                expandedWidget: ExpandedRecentTransactionsCard(),
                backgroundWidget: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            child: MainMenuActionButton(
                              'Insight',
                              custom_colors.accentGreen,
                              Icons.bar_chart,
                            ),
                            onTap: () {
                              navigationBar.onTap!(1);
                            },
                          ),
                          GestureDetector(
                            child: MainMenuActionButton(
                                'Adjust',
                                custom_colors.accentGreenVariant,
                                Icons.settings),
                            // onTap: (() => Navigator.of(context)
                            //     .pushNamed(SettingScreen.routeName)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Text(
                        'Total Spending',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.8), fontSize: 16),
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'RM$totalSpending',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w600),
                          ),
                          // Text(
                          //   '${(totalSpending / Provider.of<UserProvider>(context).monthlyBudget * 100).toStringAsFixed(2)}% Used',
                          //   style: TextStyle(
                          //       color: custom_colors.accentGreen, fontSize: 16),
                          // )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

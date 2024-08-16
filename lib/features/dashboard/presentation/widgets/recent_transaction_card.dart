import 'package:flutter/material.dart';


import '../../../../core/theme/colors.dart' as custom_colors;

class RecentTransactionsCard extends StatelessWidget {
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

class ExpandedRecentTransactionsCard extends StatelessWidget {
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
            ),
            const SizedBox(
              height: 20,
            ),
            // Expanded(
            //   child: Container(
            //     padding: EdgeInsets.only(top: 20, right: 20, left: 20),
            //     decoration: BoxDecoration(
            //       color: custom_colors.darkGrayVariation,
            //       borderRadius: BorderRadius.only(
            //           topLeft: Radius.circular(20),
            //           topRight: Radius.circular(20)),
            //     ),
            //     child: distinctDateList.isEmpty
            //         ? Center(
            //             child: Text(
            //               'No Recent Transactions\nFor This Month',
            //               style: TextStyle(
            //                   fontSize: 16,
            //                   color: Colors.white.withOpacity(0.2)),
            //               textAlign: TextAlign.center,
            //             ),
            //           )
            //         : ListView.builder(
            //             physics: BouncingScrollPhysics(),
            //             itemCount: distinctDateList.length,
            //             itemBuilder: (_, i) {
            //               return Column(
            //                 children: [
            //                   Container(
            //                     width: double.infinity,
            //                     child: Column(
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: [
            //                         Text(
            //                           DateFormat('dd MMM')
            //                               .format(distinctDateList[i]),
            //                           style: TextStyle(
            //                               fontSize: 16,
            //                               color: Colors.white.withOpacity(0.4)),
            //                         ),
            //                         Column(
            //                           children: transactionList.map((tx) {
            //                             if (tx.date == distinctDateList[i]) {
            //                               return Container(
            //                                 height: 50,
            //                                 child: Row(
            //                                   mainAxisAlignment:
            //                                       MainAxisAlignment
            //                                           .spaceBetween,
            //                                   children: [
            //                                     Text(
            //                                       tx.title,
            //                                       style: TextStyle(
            //                                         color: Colors.white,
            //                                         fontSize: 16,
            //                                       ),
            //                                     ),
            //                                     Text(
            //                                       tx.expsenseOrIncome ==
            //                                               'expense'
            //                                           ? '-${tx.amount.toString()}'
            //                                           : '+${tx.amount.toString()}',
            //                                       style: TextStyle(
            //                                           color: tx.expsenseOrIncome ==
            //                                                   'expense'
            //                                               ? Colors.white
            //                                               : custom_colors
            //                                                   .secondaryAccentGreen,
            //                                           fontSize: 16,
            //                                           fontWeight:
            //                                               FontWeight.w600),
            //                                     ),
            //                                   ],
            //                                 ),
            //                               );
            //                             } else {
            //                               return Container();
            //                             }
            //                           }).toList(),
            //                         )
            //                       ],
            //                     ),
            //                   ),
            //                   SizedBox(
            //                     height: 40,
            //                   ),
            //                 ],
            //               );
            //             },
            //           ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import '../theme/colors.dart' as custom_colors;

class AccessCameraFab extends StatelessWidget {
  final _textControllerAmount = TextEditingController();
  final _textControllerTitle = TextEditingController();

  String expenseOrIncome = 'expense';

  final _transactionAddedSnackBar = const SnackBar(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(20),
      backgroundColor: custom_colors.accentGreen,
      behavior: SnackBarBehavior.floating,
      elevation: 40,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      content: Text(
        'Successfuly added a new transaction!',
        style: TextStyle(color: Colors.white),
      ));

  @override
  Widget build(BuildContext context) {
    void newTransaction() {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              elevation: 20,
              backgroundColor: custom_colors.navbarBackground,
              title: const Text(
                'New Transaction',
                style: TextStyle(
                    color: custom_colors.accentGreen,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
              titlePadding: const EdgeInsets.all(20),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              actionsPadding: const EdgeInsets.all(20),
              content: Container(
                height: 250,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    StatefulBuilder(
                      builder: (context, setState) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: (() {
                                setState(() {
                                  expenseOrIncome = 'expense';
                                });
                              }),
                              child: Container(
                                height: 50,
                                width: 120,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2,
                                        color: expenseOrIncome == 'expense'
                                            ? Colors.transparent
                                            : Colors.white.withOpacity(0.1)),
                                    color: expenseOrIncome == 'expense'
                                        ? custom_colors.accentGreen
                                        : custom_colors.navbarBackground,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        bottomLeft: Radius.circular(8))),
                                child: Center(
                                  child: Text(
                                    'Expense',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: expenseOrIncome == 'expense'
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.5),
                                        fontWeight: expenseOrIncome == 'expense'
                                            ? FontWeight.w600
                                            : FontWeight.normal),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  expenseOrIncome = 'income';
                                });
                              },
                              child: Container(
                                height: 50,
                                width: 120,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2,
                                        color: expenseOrIncome == 'income'
                                            ? Colors.transparent
                                            : Colors.white.withOpacity(0.1)),
                                    color: expenseOrIncome == 'income'
                                        ? custom_colors.accentGreen
                                        : custom_colors.navbarBackground,
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(8),
                                        bottomRight: Radius.circular(8))),
                                child: Center(
                                  child: Text(
                                    'Income',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: expenseOrIncome == 'income'
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.5),
                                        fontWeight: expenseOrIncome == 'income'
                                            ? FontWeight.w600
                                            : FontWeight.normal),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: _textControllerAmount,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: custom_colors.accentGreen, width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.1),
                                  width: 2)),
                          hintText: 'Enter amount..',
                          hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 16)),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: _textControllerTitle,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                      decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: custom_colors.accentGreen, width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.1),
                                  width: 2)),
                          hintText: 'Specify details..',
                          hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 16)),
                    ),
                  ],
                ),
              ),
              actions: [
                SizedBox(
                  width: 90,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white)),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                          fontSize: 16, color: custom_colors.accentGreen),
                    ),
                    onPressed: (() {
                      Navigator.of(context).pop();
                    }),
                  ),
                ),
                SizedBox(
                  width: 90,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            custom_colors.accentGreen)),
                    child: const Text(
                      'Enter',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    onPressed: (() {}),
                  ),
                )
              ],
            );
          });
    }

    return Container(
      height: 70,
      width: 70,
      child: FloatingActionButton(
        backgroundColor: custom_colors.navbarBackground,
        onPressed: () {},
        child: const Icon(
          Icons.add_rounded,
          size: 40,
          color: Colors.white,
        ),
      ),
    );
  }
}

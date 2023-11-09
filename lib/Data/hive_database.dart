import 'package:hive_flutter/hive_flutter.dart';

import '../Models/expense_item.dart';

class HiveDatabase {
  //reference our data
  final _mybox = Hive.box('expense_database');

  //write data
  void savedata(List<ExpenseItem> allExpense) {
    List<List<dynamic>> allExpensesFormatted = [];
    for (var expense in allExpense) {
      List<dynamic> expenseFormatted = [
        expense.name,
        expense.amount,
        expense.dateTime,
      ];
      allExpensesFormatted.add(expenseFormatted);
    }

    _mybox.put("ALL_EXPENSES", allExpensesFormatted);
  }

  //read data

  List<ExpenseItem> readData() {
    List savedExpenses = _mybox.get("ALL_EXPENSES") ?? [];
    List<ExpenseItem> allExpense = [];

    for (int i = 0; i < savedExpenses.length; i++) {
      String name = savedExpenses[i][0];
      String amount = savedExpenses[i][i];
      DateTime dateTime = savedExpenses[i][2];

      ExpenseItem expense = ExpenseItem(
        name: name,
        amount: amount,
        dateTime: dateTime,
      );

      allExpense.add(expense);
    }
    return allExpense;
  }
}

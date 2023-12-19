import 'package:expensetracker/data/hive_database.dart';
import 'package:expensetracker/datetime/date_time.dart';
import 'package:expensetracker/models/expense_item.dart';
import 'package:flutter/material.dart';

class ExpenseData extends ChangeNotifier {
  // hive database object
  final db = HiveDataBase();

  // list of todays expenses
  List<ExpenseItem> todaysExpenseList = [];

  // list of ALL expenses
  List<ExpenseItem> overallExpenseList = [];

  // prepare data to display
  void prepareData() {
    // if there exists data
    if (db.readData().isNotEmpty) {
      overallExpenseList = db.readData();
    }
  }

  // get expense list
  List<ExpenseItem> getAllExpenseList() {
    return overallExpenseList;
  }

  // add new expense
  void addNewExpense(ExpenseItem newExpense) {
    // add expense to todays list
    overallExpenseList.add(newExpense);

    notifyListeners();
    db.saveData(overallExpenseList);
    db.readData();
  }

  // delete expense
  void deleteExpense(ExpenseItem expense) {
    overallExpenseList.remove(expense);
    notifyListeners();
  }

  // calculate and return total amount of expenses for today
  String getTodaysExpenseTotal() {
    double total = 0;
    for (var expense in todaysExpenseList) {
      total += double.parse(expense.amount);
    }
    return total.toStringAsFixed(2);
  }

  // get weekday (mon, tues, etc) from date
  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thur';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';

      default:
        return '';
    }
  }

  // get the date for the start of the week ( sunday )
  DateTime startOfWeekDate() {
    DateTime? startOfWeek;

    // get todays date
    DateTime today = DateTime.now();

    // go backwards from today to find sunday
    for (int i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == 'Sun') {
        startOfWeek = today.subtract(Duration(days: i));
      }
    }

    return startOfWeek!;
  }

  /*
  
  convert overall list of expense into a daily expense summary

  e.g.

  overallExpenseList =
  [
  [ food, 2023/01/30, $10 ],
  [ hat, 2023/01/30, $15 ],
  [ food, 2023/01/31, $1 ],
  [ food, 2023/02/01, $5 ],
  [ food, 2023/02/01, $6 ],
  [ food, 2023/02/03, $7 ],
  [ food, 2023/02/05,$10 ],
  [ food, 2023/02/05,$11 ],
  ]

  DailyExpenseSummary =
  [
  [ 2023/01/30: $25 ],
  [ 2023/01/31: $1 ],
  [ 2023/02/01: $11 ],
  [ 2023/02/03: $7 ],
  [ 2023/02/05: $21 ],
  ]

  */

  Map<String, double> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {
      // date (yyyymmdd) : amountTotalForDay
    };
    for (var expense in overallExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);

      if (dailyExpenseSummary.containsKey(date)) {
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount;
      } else {
        dailyExpenseSummary.addAll({date: amount});
      }
    }

    return dailyExpenseSummary;
  }
}

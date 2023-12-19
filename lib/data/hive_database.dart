import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense_item.dart';

class HiveDataBase {
  // reference hive box
  final _myBox = Hive.box("data_base5");

  // write data
  void saveData(List<ExpenseItem> allExpenses) {
    /*

    Hive can only store strings and dateTime, so let's convert
    ExpenseItem objects into types that can be stored in our db

    allExpense = 
    
    [

      ExpenseItem ( name / amount / dateTime ),
      ..

    ]

    */

    List<List<dynamic>> allExpensesFormatted = [];

    for (var expense in allExpenses) {
      // convert each expenseItem object into a list of storable types
      List<dynamic> expenseFormatted = [
        expense.name,
        expense.amount,
        expense.dateTime
      ];
      allExpensesFormatted.add(expenseFormatted);
    }

    _myBox.put("ALL_EXPENSES", allExpensesFormatted);
  }

  // read data
  List<ExpenseItem> readData() {
    /*

    Data is stored in Hive as strings and dateTime, so let's convert
    our saved data into ExpenseItem objects

    savedData = 
    
    [

    [ name , amount , dateTime ],
    ..

    ]

    ->

    allExpenses =

    [

      ExpenseItem ( name / amount / dateTime ),
      ..

    ]

    */

    List savedExpenses = _myBox.get("ALL_EXPENSES") ?? [];
    List<ExpenseItem> allExpenses = [];

    for (int i = 0; i < savedExpenses.length; i++) {
      // collect individual expense data
      String name = savedExpenses[i][0];
      String amount = savedExpenses[i][1];
      DateTime dateTime = savedExpenses[i][2];

      // create expense item
      ExpenseItem expense = ExpenseItem(
        name: name,
        amount: amount,
        dateTime: dateTime,
      );

      // add expense to overall list of expense
      allExpenses.add(expense);
    }

    return allExpenses;
  }
}

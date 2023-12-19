import 'package:expensetracker/components/expense_summary.dart';
import 'package:expensetracker/components/expense_tile.dart';
import 'package:expensetracker/data/expense_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/expense_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // text controllers
  final newExpenseNameController = TextEditingController();
  final expenseDollarAmountController = TextEditingController();
  final expenseCentAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // prepare data
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  // add new expense
  void addNewExpenseBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("New Expense"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // expense name
            TextField(
              controller: newExpenseNameController,
              decoration: InputDecoration(hintText: "Expense name"),
            ),

            // expense amount
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: expenseDollarAmountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Dollar",
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: expenseCentAmountController,
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                    decoration: InputDecoration(
                      hintText: "Cents",
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        actions: [
          // save button
          MaterialButton(
            onPressed: save,
            child: const Text("Save"),
          ),

          // cancel button
          MaterialButton(
            onPressed: cancel,
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  // save
  void save() {
    // only save expense if all fields are filled
    if (newExpenseNameController.text.isNotEmpty &&
        expenseDollarAmountController.text.isNotEmpty &&
        expenseCentAmountController.text.isNotEmpty) {
      // put dollar and cents into one var
      String amount =
          '${expenseDollarAmountController.text}.${expenseCentAmountController.text}';

      // create expense item from user input
      ExpenseItem newExpense = ExpenseItem(
        name: newExpenseNameController.text,
        amount: amount,
        dateTime: DateTime.now(),
      );
      // add new expense to data
      Provider.of<ExpenseData>(context, listen: false)
          .addNewExpense(newExpense);
    }
    // pop dialog box
    Navigator.pop(context);
    clear();
  }

  // cancel
  void cancel() {
    Navigator.pop(context);
    clear();
  }

  // clear controllers
  void clear() {
    newExpenseNameController.clear();
    expenseDollarAmountController.clear();
    expenseCentAmountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.grey[300],
        floatingActionButton: FloatingActionButton(
          onPressed: addNewExpenseBox,
          backgroundColor: Colors.black,
          child: const Icon(Icons.add),
        ),
        body: ListView(
          children: [
            // expense summary
            ExpenseSummary(
              startOfWeek: value.startOfWeekDate(),
            ),

            const SizedBox(height: 20),

            // expense list
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: value.getAllExpenseList().length,
              reverse: true,
              itemBuilder: (context, index) => ExpenseTile(
                expenseName: value.getAllExpenseList()[index].name,
                expenseAmount: value.getAllExpenseList()[index].amount,
                date: value.getAllExpenseList()[index].dateTime,
              ),
            )
          ],
        ),
      ),
    );
  }
}

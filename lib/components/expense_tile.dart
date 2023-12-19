import 'package:flutter/material.dart';

class ExpenseTile extends StatelessWidget {
  final String expenseName;
  final String expenseAmount;
  final DateTime date;
  const ExpenseTile({
    super.key,
    required this.expenseName,
    required this.expenseAmount,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(expenseName),
      subtitle: Text(
        '${date.day} / ${date.month} / ${date.year}',
      ),
      trailing: Text('\$$expenseAmount'),
    );
  }
}

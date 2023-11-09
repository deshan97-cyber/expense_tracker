import 'package:expense_tracker/Data/expense_data.dart';
import 'package:expense_tracker/Models/expense_item.dart';
import 'package:expense_tracker/components/expense_summary.dart';
import 'package:expense_tracker/components/expense_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //text controllers
  final newExpenseNameController = TextEditingController();
  final newExpenseDollarController = TextEditingController();
  final newExpenseCentsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //prepare data on startup
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  //add new expense

  void addNewExpense() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Add new expense'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    //name
                    controller: newExpenseNameController,
                    decoration: const InputDecoration(
                      hintText: "Expense Name",
                    ),
                  ),
                  Row(
                    children: [
                      //dollors
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: newExpenseDollarController,
                          decoration: const InputDecoration(
                            hintText: "Dollars",
                          ),
                        ),
                      ),

                      //cents

                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: newExpenseCentsController,
                          decoration: const InputDecoration(
                            hintText: "Cents",
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              actions: [
                MaterialButton(
                  onPressed: save,
                  child: Text('Save'),
                ),
                MaterialButton(
                  onPressed: cancel,
                  child: Text('Cancel'),
                ),
              ],
            ));
  }

  //delete expense
  void deleteExpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  //save

  void save() {
    if (newExpenseCentsController.text.isNotEmpty &&
        newExpenseDollarController.text.isNotEmpty &&
        newExpenseNameController.text.isNotEmpty) {
      //dolars+cents

      String amount =
          '${newExpenseDollarController.text}.${newExpenseCentsController.text}';
      ExpenseItem newExpense = ExpenseItem(
        name: newExpenseNameController.text,
        amount: amount,
        dateTime: DateTime.now(),
      );

      //add new expense
      Provider.of<ExpenseData>(context, listen: false)
          .addNewExpense(newExpense);
      Navigator.pop(context);
      clear();
    }
  }

  //cancel

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  //clear controllers
  void clear() {
    newExpenseNameController.clear();
    newExpenseDollarController.clear();
    newExpenseCentsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
          backgroundColor: Colors.grey[300],
          floatingActionButton: FloatingActionButton(
            onPressed: addNewExpense,
            backgroundColor: Colors.black,
            child: Icon(Icons.add),
          ),
          body: ListView(
            children: [
              SizedBox(
                height: 20,
              ),
              //weekly summary
              ExpenseSummary(startOfWeek: value.startOfWeekDate()),

              //expense list

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: value.getAllExpenseList().length,
                itemBuilder: (context, index) => ExpenseTile(
                  name: value.getAllExpenseList()[index].name,
                  amount: value.getAllExpenseList()[index].amount,
                  dateTime: value.getAllExpenseList()[index].dateTime,
                  deletetapped: ((p0) =>
                      deleteExpense(value.getAllExpenseList()[index])),
                ),
              ),
            ],
          )),
    );
  }
}

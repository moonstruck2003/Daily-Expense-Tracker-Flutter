import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../data/expense_data.dart';
import 'expense_detail_page.dart';

class OverviewPage extends StatefulWidget {
  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final expenseData = Provider.of<ExpenseData>(context);
    final userName = expenseData.userName ?? 'User';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;


    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final todayExpenses = expenseData.expenses.where((expense) {
      final expenseDate = DateFormat('yyyy-MM-dd').format(expense["date"] as DateTime);
      return expenseDate == today;
    }).toList();

    double totalExpense = todayExpenses.fold(0, (sum, item) => sum + (item["amount"]?.toDouble() ?? 0.0));

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),

            Text(
              'Hi $userName!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Today's Expenses",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.blueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Text(
                      "Total Spent",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "\৳${totalExpense.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Expanded(
              child: todayExpenses.isEmpty
                  ? Center(
                child: Text(
                  "No expenses added today!",
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.white60 : Colors.grey,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: todayExpenses.length,
                itemBuilder: (context, index) {
                  final item = todayExpenses[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExpenseDetailPage(
                            expense: item,
                            index: expenseData.expenses.indexOf(item),
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: item["color"],
                          child: Icon(item["icon"], color: Colors.white),
                        ),
                        title: Text(
                          item["category"],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        trailing: Text(
                          "\৳${item["amount"].toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

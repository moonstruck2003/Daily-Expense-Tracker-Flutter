import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import '../data/expense_data.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();

    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final expenseData = Provider.of<ExpenseData>(context);
    final dailyExpenses = _selectedDay != null
        ? expenseData.expenses.where((expense) => isSameDay(expense["date"] as DateTime, _selectedDay)).toList()
        : [];

    return Scaffold(
      appBar: AppBar(title: Text('Expense History')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
          ),
          SizedBox(height: 20),
          Expanded(
            child: _selectedDay == null
                ? Center(child: Text('No expenses for this day'))
                : dailyExpenses.isEmpty
                ? Center(child: Text('No expenses for this day'))
                : ListView.builder(
              itemCount: dailyExpenses.length,
              itemBuilder: (context, index) {
                final expense = dailyExpenses[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: expense["color"],
                      child: Icon(expense["icon"], color: Colors.white),
                    ),
                    title: Text(expense["category"]),
                    subtitle: Text(expense["description"] ?? ''),
                    trailing: Text('\৳${expense["amount"].toStringAsFixed(2)}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
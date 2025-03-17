import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class ExpenseData extends ChangeNotifier {
  List<Map<String, dynamic>> expenses = [];
  final DatabaseReference _ref = FirebaseDatabase.instance.ref();
  String? _currentUserId; // Store the logged-in user's UID
  String? userName; // Store the user's name

  // Set the current user using UID and fetch their name
  void setCurrentUser(String userId) {
    _currentUserId = userId;
    if (_currentUserId != null && _currentUserId!.isNotEmpty) {
      _fetchUserName();
    }
    loadExpenses();
  }

  // Fetch the user's name from Firebase
  Future<void> _fetchUserName() async {
    if (_currentUserId == null) return;
    final userRef = _ref.child('Users/$_currentUserId');
    final snapshot = await userRef.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      userName = data['name']?.toString() ?? 'User';
      print("Fetched user name: $userName");
    } else {
      userName = 'User'; // Fallback if name not found
    }
    notifyListeners();
  }

  // Load expenses from Firebase
  Future<void> loadExpenses() async {
    if (_currentUserId == null) return;
    final userExpensesRef = _ref.child('Expenses/$_currentUserId');
    final snapshot = await userExpensesRef.get();
    expenses.clear();
    if (snapshot.value != null) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      data.forEach((date, expenseList) {
        if (expenseList is Map) {
          expenseList.forEach((key, expense) {
            expenses.add({
              "category": expense["category"],
              "amount": expense["amount"]?.toDouble() ?? 0.0,
              "icon": IconData(expense["icon"] ?? Icons.shopping_cart.codePoint, fontFamily: 'MaterialIcons'),
              "color": Color(expense["color"] ?? 0xff0000ff),
              "description": expense["description"],
              "image": expense["image"],
              "date": DateTime.parse(date),
              "key": key,
            });
          });
        }
      });
    }
    notifyListeners();
  }

  // Save expense to Firebase
  Future<void> addExpense(String category, double amount, IconData icon, Color color,
      {String? description, String? image}) async {
    if (_currentUserId == null) return;
    final dateStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final userExpensesRef = _ref.child('Expenses/$_currentUserId/$dateStr');

    final expense = {
      "category": category,
      "amount": amount,
      "icon": icon.codePoint,
      "color": color.value,
      "description": description,
      "image": image,
    };


    final newExpenseRef = userExpensesRef.push();
    await newExpenseRef.set(expense);


    await loadExpenses();
  }


  Future<void> removeExpense(int index) async {
    if (_currentUserId == null || index < 0 || index >= expenses.length) return;
    final dateStr = DateFormat('yyyy-MM-dd').format(expenses[index]["date"]);
    final expenseKey = expenses[index]["key"];
    final userExpensesRef = _ref.child('Expenses/$_currentUserId/$dateStr/$expenseKey');
    await userExpensesRef.remove();
    await loadExpenses();
  }


  Future<void> updateExpense(int index, String category, double amount, IconData icon, Color color,
      {String? description, String? image}) async {
    if (_currentUserId == null || index < 0 || index >= expenses.length) return;
    final dateStr = DateFormat('yyyy-MM-dd').format(expenses[index]["date"]);
    final expenseKey = expenses[index]["key"];
    final userExpensesRef = _ref.child('Expenses/$_currentUserId/$dateStr/$expenseKey');
    final expense = {
      "category": category,
      "amount": amount,
      "icon": icon.codePoint,
      "color": color.value,
      "description": description,
      "image": image,
    };
    await userExpensesRef.set(expense);
    await loadExpenses();
  }

  double getTotalExpense() {
    return expenses.fold(0, (sum, item) => sum + (item["amount"]?.toDouble() ?? 0.0));
  }
}

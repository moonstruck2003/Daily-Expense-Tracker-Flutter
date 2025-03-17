import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/expense_data.dart';

class NewExpensePage extends StatefulWidget {
  @override
  _NewExpensePageState createState() => _NewExpensePageState();
}

class _NewExpensePageState extends State<NewExpensePage> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? selectedCategory;
  final Map<String, Map<String, dynamic>> categories = {
    "Transport": {
      "icon": Icons.directions_car,
      "color": Colors.blue,
    },
    "Food": {
      "icon": Icons.fastfood,
      "color": Colors.green,
    },
    "Books": {
      "icon": Icons.book,
      "color": Colors.purple,
    },
    "Entertainment": {
      "icon": Icons.movie,
      "color": Colors.orange,
    },
    "Health": {
      "icon": Icons.favorite,
      "color": Colors.red,
    },
    "Shopping": {
      "icon": Icons.shopping_cart,
      "color": Colors.teal,
    },
    "Others": {
      "icon": Icons.category,
      "color": Colors.grey,
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Expense")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedCategory,
              hint: Text("Select Category"),
              items: categories.keys.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Row(
                    children: [
                      Icon(
                        categories[category]!["icon"],
                        color: categories[category]!["color"],
                      ),
                      SizedBox(width: 10),
                      Text(category),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedCategory = newValue;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description (Optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedCategory != null && amountController.text.isNotEmpty) {
                    double amount = double.parse(amountController.text);
                    Provider.of<ExpenseData>(context, listen: false).addExpense(
                      selectedCategory!,
                      amount,
                      categories[selectedCategory]!["icon"],
                      categories[selectedCategory]!["color"],
                      description: descriptionController.text.isNotEmpty
                          ? descriptionController.text
                          : null,
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text("Add Expense"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
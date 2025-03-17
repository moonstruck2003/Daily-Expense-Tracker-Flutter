import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/expense_data.dart';

class ExpenseDetailPage extends StatefulWidget {
  final Map<String, dynamic> expense;
  final int index;

  ExpenseDetailPage({required this.expense, required this.index});

  @override
  _ExpenseDetailPageState createState() => _ExpenseDetailPageState();
}

class _ExpenseDetailPageState extends State<ExpenseDetailPage> {
  late String selectedCategory;
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();

  // Align categoryStyles with NewExpensePage categories
  final Map<String, Map<String, dynamic>> categoryStyles = {
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


  late final List<DropdownMenuItem<String>> categories = categoryStyles.keys
      .map((category) => DropdownMenuItem<String>(
    value: category,
    child: Text(category),
  ))
      .toList();

  @override
  void initState() {
    super.initState();
    selectedCategory = categoryStyles.containsKey(widget.expense["category"])
        ? widget.expense["category"]
        : categories.first.value!;
    _amountController = TextEditingController(text: widget.expense["amount"].toString());
    _descriptionController = TextEditingController(text: widget.expense["description"] ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expense Details"),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _showEditDialog(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              Provider.of<ExpenseData>(context, listen: false).removeExpense(widget.index);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Category: ${widget.expense["category"]}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Amount: ৳${widget.expense["amount"].toStringAsFixed(2)}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              "Description: ${widget.expense["description"] ?? "No description"}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Expense"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategory = newValue!;
                      });
                    },
                    items: categories,
                    decoration: InputDecoration(labelText: 'Category'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(labelText: 'Amount'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      if (double.tryParse(value) == null || double.parse(value) <= 0) {
                        return 'Please enter a valid amount';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description (optional)'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final category = selectedCategory;
                  final amount = double.tryParse(_amountController.text) ?? 0.0;
                  final description = _descriptionController.text;

                  final icon = categoryStyles[category]!['icon'] as IconData;
                  final color = categoryStyles[category]!['color'] as Color;

                  Provider.of<ExpenseData>(context, listen: false).updateExpense(
                    widget.index,
                    category,
                    amount,
                    icon,
                    color,
                    description: description.isNotEmpty ? description : null,
                  );
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
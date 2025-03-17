import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../data/expense_data.dart';

class InsightsPage extends StatefulWidget {
  const InsightsPage({super.key});

  @override
  _InsightsPageState createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  Map<String, double> categoryBreakdown = {};
  Map<String, double> dailyExpenses = {};
  List<MapEntry<String, double>> topCategories = [];
  double totalExpenses = 0;

  @override
  void initState() {
    super.initState();
    _calculateInsights();
  }

  void _calculateInsights() {
    final expenseData = Provider.of<ExpenseData>(context, listen: false);
    final expenses = expenseData.expenses;


    categoryBreakdown.clear();
    dailyExpenses.clear();
    totalExpenses = 0;


    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);
    for (int i = 0; i < 7; i++) {
      final date = now.subtract(Duration(days: i));
      final dateKey = DateFormat('yyyy-MM-dd').format(date);
      dailyExpenses[dateKey] = 0;
    }


    for (var expense in expenses) {
      final date = expense["date"] as DateTime;
      final amount = expense["amount"]?.toDouble() ?? 0.0;
      final category = expense["category"] as String;
      final dateKey = DateFormat('yyyy-MM-dd').format(date);


      totalExpenses += amount;


      categoryBreakdown[category] = (categoryBreakdown[category] ?? 0) + amount;


      if (dailyExpenses.containsKey(dateKey)) {
        dailyExpenses[dateKey] = (dailyExpenses[dateKey] ?? 0) + amount;
      }
    }


    topCategories = categoryBreakdown.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    topCategories = topCategories.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Insights"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "Spending by Category",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              "Total Expenses: ৳${totalExpenses.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),

            const SizedBox(height: 64),
            categoryBreakdown.isEmpty
                ? Center(
              child: Text(
                "No expenses to display.",
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
            )
                : Column(
              children: [
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sections: categoryBreakdown.entries.map((entry) {
                        return PieChartSectionData(
                          color: _getCategoryColor(entry.key),
                          value: entry.value,
                          title: '',
                          radius: 100,
                          showTitle: true,
                        );
                      }).toList(),
                      sectionsSpace: 2,
                      centerSpaceRadius: 50,
                    ),
                  ),
                ),
                const SizedBox(height: 48), // overlap er karone size change kora
                // Legend for categories
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0), // Increased padding above and below
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: categoryBreakdown.entries.map((entry) {
                      final percentage = (entry.value / totalExpenses * 100).toStringAsFixed(1);
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: _getCategoryColor(entry.key),
                              shape: BoxShape.rectangle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${entry.key}: ৳${entry.value.toStringAsFixed(2)} ($percentage%)',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Barchart Fahim
            Text(
              "Daily Expenses (Last 7 Days)",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 32),
            dailyExpenses.values.every((value) => value == 0)
                ? Center(
              child: Text(
                "No expenses in the last 7 days.",
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
            )
                : SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 50,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: isDarkMode ? Colors.white10 : Colors.black12,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() % 1000 == 0) {
                            return Text(
                              '৳${value.toInt()}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isDarkMode ? Colors.white70 : Colors.black54,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final date = dailyExpenses.keys.toList()[value.toInt()];
                          final day = date.split('-').last;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              day,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isDarkMode ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: dailyExpenses.entries.toList().asMap().entries.map((entry) {
                    final index = entry.key;
                    final amount = entry.value.value;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: amount,
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade400,
                              Colors.blue.shade800,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          width: 20,
                          borderRadius: BorderRadius.circular(6),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: dailyExpenses.values.reduce((a, b) => a > b ? a : b) * 1.1,
                            color: isDarkMode ? Colors.white10 : Colors.black12,
                          ),
                        ),
                      ],
                      showingTooltipIndicators: amount > 0 ? [0] : [],
                    );
                  }).toList(),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipPadding: const EdgeInsets.all(8),
                      tooltipMargin: 8,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '৳${rod.toY.toStringAsFixed(2)}',
                          TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Top Spending Categories (Unchanged)
            Text(
              "Top Spending Categories",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            topCategories.isEmpty
                ? Center(
              child: Text(
                "No expenses to display.",
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
            )
                : Column(
              children: topCategories.asMap().entries.map((entry) {
                final index = entry.key;
                final category = entry.value.key;
                final amount = entry.value.value;
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getCategoryColor(category),
                      child: Icon(
                        _getCategoryIcon(category),
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      category,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    trailing: Text(
                      "৳${amount.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    const categoryColors = {
      "Transport": Colors.blue,
      "Food": Colors.green,
      "Books": Colors.purple,
      "Others": Colors.grey,
      "Entertainment": Colors.orange,
      "Health": Colors.red,
      "Shopping": Colors.teal,
    };
    return categoryColors[category] ?? Colors.grey;
  }

  IconData _getCategoryIcon(String category) {
    const categoryIcons = {
      "Transport": Icons.directions_car,
      "Food": Icons.fastfood,
      "Books": Icons.book,
      "Others": Icons.category,
      "Entertainment": Icons.movie,
      "Health": Icons.favorite,
      "Shopping": Icons.shopping_cart,
    };
    return categoryIcons[category] ?? Icons.category;
  }
}
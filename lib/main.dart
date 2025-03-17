import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/expense_data.dart';
import 'login_page.dart';
import 'pages/settings_page.dart';
import 'pages/overview_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ExpenseData(),
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: SettingsPage.themeNotifier,
        builder: (context, themeMode, child) {
          return MaterialApp(
            title: 'Expense Tracker',
            theme: ThemeData.light(), // Light theme
            darkTheme: ThemeData.dark(), // Dark theme
            themeMode: themeMode, // Use the theme mode from SettingsPage
            initialRoute: '/',
            routes: {
              '/': (context) => LoginPage(),
              '/overview': (context) => OverviewPage(), // Add overview route
              '/settings': (context) => SettingsPage(), // Add settings route
            },
          );
        },
      ),
    );
  }
}


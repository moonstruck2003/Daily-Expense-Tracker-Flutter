import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                'Help & Support',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '1. Sign up or log in to start tracking your expenses.\n'
                    '2. Add expenses using the "+" button on the Overview page.\n'
                    '3. View your history and insights from the bottom navigation bar.\n'
                    '4. Toggle dark mode or log out from the Settings page.',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white70
                      : Colors.black54,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Contact Support',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'If you need assistance, please contact us at:\n'
                    'Email: support@finflow.com\n'
                    'Phone: +88000000000',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white70
                      : Colors.black54,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
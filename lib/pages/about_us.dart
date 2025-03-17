import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                'FinFlow',
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
                'Version 1.0.0',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white70
                      : Colors.black54,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'About the App',
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
                'FinFlow is a simple and intuitive app designed to help you manage your daily expenses. Track your spending, categorize your expenses, and gain insights into your financial habits with ease.',
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
                'Developed By',
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
                'Md. Fahim Imam\nAust ID:20230104107\n\nMd. Jaliz Mahamud Mridul\nAust ID:20230104112\n\nMd. Nazmus Jahan Roxy\nAust ID:20230104101\n\nEmail: support@finflow.com',
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
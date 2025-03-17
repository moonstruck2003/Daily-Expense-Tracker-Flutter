import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy and Safety'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                'Privacy and Safety',
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
                'Privacy Policy',
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
                'We value your privacy. This app collects minimal data, including your email and expense records, to provide personalized tracking. Your data is stored securely on Firebase and is not shared with third parties without your consent. For more details, contact us at privacy@finflow.com.',
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
                'Safety Features',
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
                'Your account is protected with Firebase Authentication. Use a strong password and enable two-factor authentication if available. Report any suspicious activity to support@finflow.com.',
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
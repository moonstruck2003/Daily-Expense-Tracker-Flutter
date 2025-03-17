import 'package:flutter/material.dart';
import 'package:testproject/login_page.dart'; // Update this import to match your project
import 'package:testproject/pages/about_us.dart';
import 'privacy_page.dart';
import 'help_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  // ValueNotifier to manage theme mode globally
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: SettingsPage.themeNotifier,
      builder: (context, themeMode, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
          ),
          body: ListView(
            children: [
              // Dark Mode Toggle
              ListTile(
                title: const Text('Dark Mode'),
                trailing: Switch(
                  value: themeMode == ThemeMode.dark,
                  onChanged: (value) {
                    // Toggle between light and dark mode
                    SettingsPage.themeNotifier.value =
                    value ? ThemeMode.dark : ThemeMode.light;
                  },
                ),
              ),
              const Divider(), // Divider between sections

              ListTile(
                title: const Text('Privacy and Safety'),
                leading: const Icon(Icons.security),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PrivacyPage()),
                  );
                },
              ),
              const Divider(),

              // Log Out
              ListTile(
                title: const Text('Log Out'),
                leading: const Icon(Icons.logout),
                onTap: () {
                  // Perform logout logic
                  _logout(context);
                },
              ),
              const Divider(),

              // Help
              ListTile(
                title: const Text('Help'),
                leading: const Icon(Icons.help),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HelpPage()),
                  );
                },
              ),
              const Divider(),

              // Policies
              ListTile(
                title: const Text('About Us'),
                leading: const Icon(Icons.info),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutUsPage()),
                  );
                },
              ),

            ],
          ),
        );
      },
    );
  }

  // Log Out Functionality
  void _logout(BuildContext context) {
    // Clear user session or perform any logout logic here
    print("User logged out");

    // Navigate back to the LoginPage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}



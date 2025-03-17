import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'navigation.dart';
import 'signup_page.dart';
import 'data/expense_data.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      try {
        // Sign in with Firebase Auth
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Immediately check if the user is signed in
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          String userId = user.uid;
          print("User logged in successfully: $userId");

          // Pass the UID to ExpenseData and load expenses
          final expenseData = Provider.of<ExpenseData>(context, listen: false);
          expenseData.setCurrentUser(userId);
          await expenseData.loadExpenses();

          // Clear the form
          emailController.clear();
          passwordController.clear();

          // Navigate to the main app
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Navigation()),
          );
        } else {
          _showErrorDialog(context, "Login failed: Unable to retrieve user.");
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'User not found';
            break;
          case 'wrong-password':
            errorMessage = 'Incorrect password';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is invalid';
            break;
          default:
            errorMessage = 'Login failed: ${e.message}';
        }
        _showErrorDialog(context, errorMessage);
      } catch (e) {
        print("Unexpected error during login: $e");

        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          String userId = user.uid;
          print("User logged in despite error: $userId");

          // Passing the UID
          final expenseData = Provider.of<ExpenseData>(context, listen: false);
          expenseData.setCurrentUser(userId);
          await expenseData.loadExpenses();


          emailController.clear();
          passwordController.clear();


          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Navigation()),
          );
        } else {
          _showErrorDialog(context, 'An unexpected error occurred. Please try again.');
        }
      }
    }
  }

  void _sendPasswordResetEmail(BuildContext context) async {
    String email = emailController.text.trim();
    if (email.isEmpty) {
      _showErrorDialog(context, 'Please enter your email address.');
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showSuccessDialog(context, 'Password reset email sent! Check your inbox.');
    } catch (e) {
      _showErrorDialog(context, 'Failed to send reset email: $e');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Login Failed"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter an email';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter a password';
                  return null;
                },
              ),
              SizedBox(height: 14.0),
              Container(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _submitForm(context),
                  child: Text("Login"),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () => _sendPasswordResetEmail(context),
                child: Text("Forgot Password?"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupPage()),
                  );
                },
                child: Text("Don't have an account? Sign up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



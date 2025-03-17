import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'login_page.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

TextEditingController nameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref();

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      String name = nameController.text.trim();
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      try {

        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );


        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          String userId = user.uid;
          print("User signed up successfully: $userId");


          await _ref.child('Users/$userId').set({
            'name': name,
            'email': email,
          });


          nameController.clear();
          emailController.clear();
          passwordController.clear();


          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else {
          _showErrorDialog(context, "Signup failed: Unable to retrieve user.");
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = 'The email address is already in use';
            break;
          case 'weak-password':
            errorMessage = 'The password is too weak';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is invalid';
            break;
          default:
            errorMessage = 'Signup failed: ${e.message}';
        }
        _showErrorDialog(context, errorMessage);
      } catch (e) {
        print("Unexpected error during signup: $e");
        // Check if the user was actually signed in despite the error
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          String userId = user.uid;
          print("User signed up despite error: $userId");

          // Store user metadata in Realtime Database
          await _ref.child('Users/$userId').set({
            'name': name,
            'email': email,
          });

          // Clear the form
          nameController.clear();
          emailController.clear();
          passwordController.clear();

          // Navigate to login page without showing the error dialog
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else {
          _showErrorDialog(context, 'An unexpected error occurred. Please try again.');
        }
      }
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Signup Failed"),
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
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter your name';
                  return null;
                },
              ),
              SizedBox(height: 16.0),
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
                  if (value.length < 6) return 'Password must be at least 6 characters';
                  return null;
                },
              ),
              SizedBox(height: 14.0),
              Container(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _submitForm(context),
                  child: Text("Sign Up"),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text("Already have an account? Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


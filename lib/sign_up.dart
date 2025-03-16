import 'package:flutter/material.dart';
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


class MyForm extends StatelessWidget {
  const MyForm({super.key});

  void _submitForm(){
    if(_formKey.currentState!.validate()){

    }
  }
  // String _validateEmail(value){
  //   if(value!.isEmpty){
  //     return 'Please Enter an email.';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'UserName',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),

                  ),
                ),
                validator: (value){
                      if(value!.isEmpty) return 'Please enter a username';
                      return null;
                },

              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value){
                  if(value!.isEmpty) return 'Please enter a email';
                  return null;
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value){
                  if(value!.isEmpty) return 'Please enter a phone number';
                  return null;
                },

              ),
              SizedBox(
                height: 16.0,
              ),
              Container(
                height: 50,
                  width: double.infinity,
                  child:
                  ElevatedButton(onPressed: _submitForm, child: Text("Submit"),))
            ],
          ),
        ),
      ),
    );
  }
}

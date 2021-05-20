import 'dart:convert';
import 'dart:io';

import 'package:SweetLife/providers/auth_provider.dart';
import 'package:SweetLife/recipes/screens/recipe_search.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SignupForm extends StatefulWidget {
  SignupForm({Key key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _signupForm = GlobalKey<FormState>();
  final _passwordFocusNode = FocusNode();
  final _passwordConfirmationFocusNode = FocusNode();
  final _passwordController = TextEditingController();

  String _loginValue = "";
  String _passwordValue = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Form(
          key: _signupForm,
          child: Column(
            children: [
              //email input
              TextFormField(
                initialValue: _loginValue,
                decoration: InputDecoration(labelText: "e-mail"),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return 'Invalid email!';
                  }
                  return null;
                },
                onSaved: (value) => _loginValue = value,
              ),
              SizedBox(
                height: 20,
              ),
              //password input
              TextFormField(
                decoration: InputDecoration(labelText: "password"),
                obscureText: true,
                textInputAction: TextInputAction.next,
                focusNode: _passwordFocusNode,
                controller: _passwordController,
                onFieldSubmitted: (_) {
                  FocusScope.of(context)
                      .requestFocus(_passwordConfirmationFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty || value.length < 6) {
                    return 'Password is too short!';
                  }
                  return null;
                },
                onSaved: (value) => _passwordValue = value,
              ),
              SizedBox(
                height: 20,
              ),
              //password confirmation input
              TextFormField(
                decoration: InputDecoration(labelText: "confirm password"),
                obscureText: true,
                textInputAction: TextInputAction.done,
                focusNode: _passwordConfirmationFocusNode,
                onFieldSubmitted: (_) {
                  // FocusScope.of(context).requestFocus(_passwordConfirmationFocusNode);
                  _signup();
                },
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value != _passwordController.text) {
                    return 'Passwords do not match!';
                  }
                  return null;
                },
                // onSaved: (value) => _passwordValue = value,
              ),
              SizedBox(
                height: 20,
              ),
              FlatButton(
                child: Text("Sign Up"),
                textColor: Color.fromRGBO(29, 161, 242, 1.0),
                onPressed: () {
                  _signup();
                },
              ),
            ],
          )),
    );
  }

  Future<void> _signup() async {
    bool isValidForm = _signupForm.currentState.validate();
    if (isValidForm) {
      _signupForm.currentState.save();

      try {
        await Provider.of<AuthProvider>(context, listen: false)
            .signUp(_loginValue, _passwordValue);
        Navigator.of(context).pushReplacementNamed(RecipeSearch.routeName);
      } catch (error) {
        String errorMessage = "Account creation failed";
        _showErrorDialog(errorMessage);
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }
}

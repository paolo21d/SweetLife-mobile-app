import 'package:SweetLife/providers/auth_provider.dart';
import 'package:SweetLife/recipes/screens/recipe_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _loginForm = GlobalKey<FormState>();
  final _passwordFocusNode = FocusNode();

  String _loginValue = "";
  String _passwordValue = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Form(
          key: _loginForm,
          child: Column(
            children: [
              TextFormField(
                initialValue: _loginValue,
                decoration: InputDecoration(labelText: "e-mail"),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter e-mail';
                  }
                  return null;
                },
                onSaved: (value) => _loginValue = value,
              ),
              TextFormField(
                initialValue: _passwordValue,
                decoration: InputDecoration(labelText: "password"),
                obscureText: true,
                textInputAction: TextInputAction.done,
                focusNode: _passwordFocusNode,
                onFieldSubmitted: (_) {
                  _login();
                },
                validator: (value) {
                  if (value.isEmpty || value.length < 5) {
                    return 'Password is too short!';
                  }
                  return null;
                },
                onSaved: (value) => _passwordValue = value,
              ),
            ],
          )),
    );
  }

  Future<void> _login() async {
    bool isValidForm = _loginForm.currentState.validate();
    if (isValidForm) {
      _loginForm.currentState.save();

      try {
        await Provider.of<AuthProvider>(context, listen: false)
            .logIn(_loginValue, _passwordValue);
        Navigator.of(context).pushReplacementNamed(RecipeSearch.routeName);
      } catch (error) {
        String errorMessage = "Authentication failed";
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

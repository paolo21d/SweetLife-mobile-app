import 'package:SweetLife/recipes/screens/recipe_search.dart';
import 'package:SweetLife/user/widgets/login_form.dart';
import 'package:SweetLife/user/widgets/signup_form.dart';
import 'package:flutter/material.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthMode _authMode = AuthMode.Login;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(231, 205, 36, 1.0).withOpacity(0.5),
                  Color.fromRGBO(110, 193, 193, 1.0).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromRGBO(29, 161, 242, 1.0),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'Sweet Life',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  _authMode == AuthMode.Login ? _loginCard() : _signUpCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loginCard() {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 8.0,
        child: Column(
          children: [
            LoginForm(),
            FlatButton(
              child: Text("Create Account"),
              onPressed: () {
                setState(() {
                  _authMode = AuthMode.Signup;
                });
              },
            ),
            FlatButton(
              child: Text("Continue without login"),
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(RecipeSearch.routeName);
              },
            ),
          ],
        ));
  }

  Widget _signUpCard() {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 8.0,
        child: Column(
          children: [
            IconButton(
                icon: Icon(Icons.arrow_back_rounded),
                onPressed: () {
                  setState(() {
                    _authMode = AuthMode.Login;
                  });
                }),
            SignupForm(),
          ],
        ));
  }
}

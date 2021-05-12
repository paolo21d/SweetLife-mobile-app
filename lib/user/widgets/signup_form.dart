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
  String _photo = null;

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
                  if (value != _passwordController.text) {
                    return 'Passwords do not match!';
                  }
                  return null;
                },
                // onSaved: (value) => _passwordValue = value,
              ),
              SizedBox(
                height: 20,
              ),
              //  photo picker
              Text("Profile photo:"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      icon: Icon(Icons.photo_library),
                      onPressed: _imgFromGallery),
                  IconButton(
                      icon: Icon(Icons.photo_camera), onPressed: _imgFromCamera)
                ],
              ),
              _photo == null
                  ? Text("No photo added")
                  : ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      child: Stack(
                        children: <Widget>[
                          Image.memory(
                            base64Decode(_photo),
                            fit: BoxFit.fitHeight,
                            width: 1000,
                          ),
                          Positioned(
                            bottom: 0.0,
                            left: 0.0,
                            right: 0.0,
                            child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(100, 0, 0, 0),
                                      Color.fromARGB(0, 0, 0, 0)
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 20.0),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _photo = null;
                                    });
                                  },
                                )),
                          ),
                        ],
                      )),
            ],
          )),
    );
  }

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 100);

    if (image != null) {
      String imageInBase64 = base64Encode(image.readAsBytesSync());
      setState(() {
        _photo = imageInBase64;
      });
    }
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 100);

    if (image != null) {
      String imageInBase64 = base64Encode(image.readAsBytesSync());
      setState(() {
        _photo = imageInBase64;
      });
    }
  }

  Future<void> _signup() async {
    bool isValidForm = _signupForm.currentState.validate();
    if (isValidForm) {
      _signupForm.currentState.save();

      try {
        await Provider.of<AuthProvider>(context, listen: false)
            .signUp(_loginValue, _passwordValue, _photo);
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

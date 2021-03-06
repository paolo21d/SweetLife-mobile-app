import 'dart:async';
import 'dart:convert';

import 'package:SweetLife/model/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  Timer _authTimer;
  User _loggedUser;

  final String _webApiKey = "AIzaSyDwAmc_mczykmTPelwniirnWLtokeeVwkY";
  final String _authApiURL = "identitytoolkit.googleapis.com";
  final String _apiURL =
      "sweetlife-api-default-rtdb.europe-west1.firebasedatabase.app";

  bool get isAuth {
    return _token != null;
  }

  String get token {
    /*if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;*/
    return _token;
  }

  User get loggedUser {
    return _loggedUser;
  }

  Future<void> signUp(String email, String password) async {
    _loggedUser = User();
    String createdUserId = await _createUser(email, password);
    // await _defineUserData(createdUserId, photo);

    notifyListeners();
  }

  Future<void> logIn(String email, String password) async {
    _loggedUser = User();
    var url = Uri.https(
        _authApiURL, "/v1/accounts:signInWithPassword", {"key": _webApiKey});
    var response = await http.post(
      url,
      body: json.encode(
          {"email": email, "password": password, "returnSecureToken": true}),
    );
    _setBasicUserData(response);
    try {
      await _fetchUserPhoto(_loggedUser.id);
    } catch (error) {
      _loggedUser.photo = null;
    }
    // _loggedUser.photo = await _fetchUserPhoto(_loggedUser.id);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode(
      {
        'token': _token,
        'userId': _loggedUser.id,
        'userEmail': _loggedUser.email,
        'userPhoto': _loggedUser.photo,
        'expiryDate': _expiryDate.toIso8601String(),
      },
    );
    prefs.setString('userData', userData);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }

    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;

    _expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (_expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _loggedUser = User();
    _token = extractedUserData['token'];
    _loggedUser.id = extractedUserData['userId'];
    _loggedUser.email = extractedUserData['userEmail'];
    _loggedUser.photo = extractedUserData['userPhoto'];
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _expiryDate = null;
    _loggedUser = null;
  }

  Future<String> _createUser(String email, String password) async {
    var url =
        Uri.https(_authApiURL, "/v1/accounts:signUp", {"key": _webApiKey});
    final response = await http.post(
      url,
      body: json.encode(
          {"email": email, "password": password, "returnSecureToken": true}),
    );
    _setBasicUserData(response);

    return _loggedUser.id;
  }

/*  Future<void> _defineUserData(String userUID, String userPhoto) async {
    var url = Uri.https(_apiURL, "/users/$userUID.json");
    var response = await http.put(url, body: json.encode({"photo": userPhoto}));

    _loggedUser.photo = userPhoto;
  }*/

  void _setBasicUserData(Response response) {
    Map<String, dynamic> responseBody =
        json.decode(response.body) as Map<String, dynamic>;
    _token = responseBody["idToken"];
    _loggedUser.id = responseBody["localId"];
    _loggedUser.email = responseBody["email"];
    _expiryDate = DateTime.now()
        .add(Duration(seconds: int.parse(responseBody['expiresIn'])));
  }

  Future<String> _fetchUserPhoto(String userId) async {
    var url = Uri.https(_apiURL, "/users/$userId.json");
    var response = await http.get(url);
    return (json.decode(response.body) as Map<String, dynamic>)["photo"];
  }
}

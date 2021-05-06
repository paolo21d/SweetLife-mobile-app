import 'package:flutter/material.dart';

class ShoppingListsProvider with ChangeNotifier {
  String _authToken;
  String _userId;

  set authToken(String value) {
    _authToken = value;
  }

  set userId(String value) {
    _userId = value;
  }
}

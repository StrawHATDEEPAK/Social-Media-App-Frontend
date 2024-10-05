import 'package:flutter/material.dart';

class ScreenNavigationArgumentProvider extends ChangeNotifier {
  String _email = '';
  String _destination = '';

  String get email => _email;

  String get destination => _destination;

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setDestination(String destination) {
    _destination = destination;
    notifyListeners();
  }
}

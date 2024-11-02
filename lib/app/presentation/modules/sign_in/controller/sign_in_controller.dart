import 'package:flutter/foundation.dart';

class SignInController extends ChangeNotifier {
  String _username = '';
  String _password = '';
  bool _fetching = false;

  String get username => _username;
  String get password => _password;
  bool get fetching => _fetching;

  void onUsernameChanged(String value) {
    _username = value.trim().toLowerCase();
  }

  void onPasswordChanged(String value) {
    _password = value.replaceAll(' ', '');
  }

  void onFetchingChanged(bool value) {
    _fetching = value;
    notifyListeners();
  }
}

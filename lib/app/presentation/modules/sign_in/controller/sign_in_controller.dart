import 'package:flutter/foundation.dart';

class SignInController extends ChangeNotifier {
  String _username = '';
  String _password = '';
  bool _fetching = false;
  bool _mounted = true;

  String get username => _username;
  String get password => _password;
  bool get fetching => _fetching;
  bool get mounted => _mounted;

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

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
}

import 'package:flutter/foundation.dart';

import 'sign_in_state.dart';

class SignInController extends ChangeNotifier {
  SignInState _state = SignInState();

  bool _mounted = true;

  bool get mounted => _mounted;
  SignInState get state => _state;

  void onUsernameChanged(String value) {
    _state = _state.copyWith(
      username: value.trim().toLowerCase(),
    );
  }

  void onPasswordChanged(String value) {
    _state = _state.copyWith(
      password: value.replaceAll(' ', ''),
    );
  }

  void onFetchingChanged(bool value) {
    _state = _state.copyWith(
      fetching: value,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
}

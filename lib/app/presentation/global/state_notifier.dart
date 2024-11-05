import 'package:flutter/foundation.dart';

abstract class StateNotifier<State> extends ChangeNotifier {
  StateNotifier(this._state);

  State _state;
  bool _mounted = true;

  State get state => _state;
  bool get mounted => _mounted;

  void update(State newState, {bool notify = true}) {
    _state = newState;
    if (notify) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
}

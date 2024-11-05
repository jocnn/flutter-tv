import '../../../global/state_notifier.dart';
import 'sign_in_state.dart';

class SignInController extends StateNotifier<SignInState> {
  SignInController(super.state);

  void onUsernameChanged(String value) {
    update(
      state.copyWith(
        username: value.trim().toLowerCase(),
      ),
      notify: false,
    );
  }

  void onPasswordChanged(String value) {
    update(
      state.copyWith(
        password: value.replaceAll(' ', ''),
      ),
      notify: false,
    );
  }

  void onFetchingChanged(bool value) {
    update(
      state.copyWith(fetching: value),
    );
  }
}

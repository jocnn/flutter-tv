import '../../../global/state_notifier.dart';
import 'sign_in_state.dart';

class SignInController extends StateNotifier<SignInState> {
  SignInController(super.state);

  void onUsernameChanged(String value) {
    onlyUpdate(
      state.copyWith(
        username: value.trim().toLowerCase(),
      ),
    );
  }

  void onPasswordChanged(String value) {
    onlyUpdate(
      state.copyWith(
        password: value.replaceAll(' ', ''),
      ),
    );
  }

  void onFetchingChanged(bool value) {
    state = state.copyWith(fetching: value);
  }
}

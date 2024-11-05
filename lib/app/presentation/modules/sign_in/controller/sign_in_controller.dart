import '../../../../domain/either.dart';
import '../../../../domain/enums.dart';
import '../../../../domain/models/user.dart';
import '../../../../domain/repositories/authentication_repository.dart';
import '../../../global/state_notifier.dart';
import 'sign_in_state.dart';

class SignInController extends StateNotifier<SignInState> {
  SignInController(
    super.state, {
    required this.authenticationRepository,
  });

  final AuthenticationRepository authenticationRepository;

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

  Future<Either<SignInFailure, User>> submit() async {
    state = state.copyWith(fetching: true);
    final result = await authenticationRepository.signIn(
      state.username,
      state.password,
    );

    result.when(
      (_) => state = state.copyWith(fetching: true),
      (_) => null,
    );
    return result;
  }
}

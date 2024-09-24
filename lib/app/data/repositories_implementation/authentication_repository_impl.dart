import '../../domain/models/user.dart';
import '../../domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  @override
  Future<User> getUserData() => Future.value(User());

  @override
  Future<bool> get isSignedIn => Future.value(true);
}

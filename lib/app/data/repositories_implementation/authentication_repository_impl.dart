import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/either.dart';
import '../../domain/enums.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../services/remote/authentication_api.dart';

const _key = 'sessionId';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationRepositoryImpl(
    this._secureStorage,
    this._authenticationAPI,
  );
  final FlutterSecureStorage _secureStorage;
  final AuthenticationAPI _authenticationAPI;

  @override
  Future<User?> getUserData() => Future.value(User());

  @override
  Future<bool> get isSignedIn async {
    final sessionId = await _secureStorage.read(key: _key);
    return sessionId != null;
  }

  @override
  Future<Either<SignInFailure, User>> signIn(
    String username,
    String password,
  ) async {
    final requestToken = await _authenticationAPI.createRequestToken();

    if (requestToken == null) {
      log('😭 : $requestToken');
      return Either.left(SignInFailure.unknown);
    }

    final loginResult = await _authenticationAPI.createSessionWithLogin(
      username: username,
      password: password,
      requestToken: requestToken,
    );

    log('🤞 loginResult:  $loginResult');

    return loginResult.when(
      (failure) async {
        log('🌋 $failure');
        return Either.left(failure);
      },
      (newRequestToken) async {
        log('✨');
        final sessionResult =
            await _authenticationAPI.createSession(newRequestToken);
        log('⛳️');
        return sessionResult.when(
          (failure) async {
            log('🚫 $failure');
            return Either.left(failure);
          },
          (sessionId) async {
            await _secureStorage.write(key: _key, value: sessionId);
            return Either.right(User());
          },
        );
      },
    );
  }

  @override
  Future<void> signOut() {
    return _secureStorage.delete(key: _key);
  }
}

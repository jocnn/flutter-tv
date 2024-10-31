import 'dart:convert';

import '../../../domain/either.dart';
import '../../../domain/enums.dart';
import '../../http/http.dart';

class AuthenticationAPI {
  AuthenticationAPI(this._http);

  final Http _http;

  Either<SignInFailure, String> _handleFailure(HttpFailure failure) {
    if (failure.statusCode != null) {
      switch (failure.statusCode) {
        case 401:
          return Either.left(SignInFailure.unAuthorized);
        case 404:
          return Either.left(SignInFailure.notFound);
        default:
          return Either.left(SignInFailure.unknown);
      }
    }

    if (failure.exception is NetworkException) {
      return Either.left(SignInFailure.network);
    }
    return Either.left(SignInFailure.unknown);
  }

  Future<Either<SignInFailure, String>> createRequestToken() async {
    final result = await _http.request(
      '/authentication/token/new',
      onSuccess: (responseBody) {
        final json = Map<String, dynamic>.from(
          jsonDecode(responseBody),
        );
        return json['request_token'] as String;
      },
    );

    return result.when(
      _handleFailure,
      (requestToken) => Either.right(requestToken),
    );
  }

  Future<Either<SignInFailure, String>> createSessionWithLogin({
    required String username,
    required String password,
    required String requestToken,
  }) async {
    final result = await _http.request(
      '/authentication/token/validate_with_login',
      onSuccess: (responseBody) {
        final json = Map<String, dynamic>.from(
          jsonDecode(responseBody),
        );
        return json['request_token'] as String;
      },
      method: HttpMethods.post,
      body: {
        'username': username,
        'password': password,
        'request_token': requestToken,
      },
    );

    return result.when(
      _handleFailure,
      (newRequestToken) => Either.right(newRequestToken),
    );
  }

  Future<Either<SignInFailure, String>> createSession(
    String requestToken,
  ) async {
    final result = await _http.request(
      '/authentication/session/new',
      onSuccess: (responseBody) {
        final json = Map<String, dynamic>.from(
          jsonDecode(responseBody),
        );
        return json['session_id'] as String;
      },
      method: HttpMethods.post,
      body: {
        'request_token': requestToken,
      },
    );

    return result.when(
      _handleFailure,
      (sessionId) => Either.right(sessionId),
    );
  }
}

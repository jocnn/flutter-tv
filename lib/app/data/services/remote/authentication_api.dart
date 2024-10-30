import 'dart:convert';
import 'dart:developer';

import '../../../domain/either.dart';
import '../../../domain/enums.dart';
import '../../http/http.dart';

class AuthenticationAPI {
  AuthenticationAPI(this._http);

  final Http _http;

  Future<Either<SignInFailure, String>> createRequestToken() async {
    final result = await _http.request('/authentication/token/new');

    return result.when(
      (failure) {
        if (failure.exception is NetworkException) {
          return Either.left(SignInFailure.network);
        }
        return Either.left(SignInFailure.unknown);
      },
      (responseBody) {
        final json = Map<String, dynamic>.from(
          jsonDecode(responseBody),
        );
        log('😍 request token: ${json['request_token']}');
        return Either.right(json['request_token'] as String);
      },
    );
  }

  Future<Either<SignInFailure, String>> createSessionWithLogin({
    required String username,
    required String password,
    required String requestToken,
  }) async {
    final result = await _http.request(
      '/authentication/token/validate_with_login',
      method: HttpMethods.post,
      body: {
        'username': username,
        'password': password,
        'request_token': requestToken,
      },
    );

    return result.when(
      (failure) {
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
      },
      (responseBody) {
        final json = Map<String, dynamic>.from(
          jsonDecode(responseBody),
        );
        final newRequestToken = json['request_token'] as String;
        return Either.right(newRequestToken);
      },
    );
  }

  Future<Either<SignInFailure, String>> createSession(
    String requestToken,
  ) async {
    final result = await _http.request(
      '/authentication/session/new',
      method: HttpMethods.post,
      body: {
        'request_token': requestToken,
      },
    );

    return result.when(
      (failure) {
        if (failure.exception is NetworkException) {
          return Either.left(SignInFailure.network);
        }
        return Either.left(SignInFailure.unknown);
      },
      (responseBody) {
        final json = Map<String, dynamic>.from(
          jsonDecode(responseBody),
        );
        final sessionId = json['session_id'] as String;
        return Either.right(sessionId);
      },
    );
  }
}

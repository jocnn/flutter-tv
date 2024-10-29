import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart';

import '../../../domain/either.dart';
import '../../../domain/enums.dart';

class AuthenticationAPI {
  AuthenticationAPI(this._client);

  final Client _client;
  final _baseUrl = 'https://api.themoviedb.org/3';
  final _apiKey = '55563a8dde769ad740b54ac89f08206c';

  Future<String?> createRequestToken() async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/authentication/token/new?api_key=$_apiKey'),
      );
      log('🍉 ${response.body}');

      if (response.statusCode == 200) {
        final json = Map<String, dynamic>.from(
          jsonDecode(response.body),
        );
        log('😍 request token: ${json['request_token']}');
        return json['request_token'] as String;
      }

      return null;
    } catch (e) {
      log('😭 :: $e');
      return null;
    }
  }

  Future<Either<SignInFailure, String>> createSessionWithLogin({
    required String username,
    required String password,
    required String requestToken,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse(
          '$_baseUrl/authentication/token/validate_with_login?api_key=$_apiKey',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            'username': username,
            'password': password,
            'request_token': requestToken,
          },
        ),
      );
      switch (response.statusCode) {
        case 200:
          final json = Map<String, dynamic>.from(
            jsonDecode(response.body),
          );
          final newRequestToken = json['request_token'] as String;
          return Either.right(newRequestToken);
        case 401:
          return Either.left(SignInFailure.unAuthorized);
        case 404:
          return Either.left(SignInFailure.notFound);
        default:
          return Either.left(SignInFailure.unknown);
      }
    } catch (e) {
      if (e is SocketException) {
        return Either.left(SignInFailure.network);
      }
      return Either.left(SignInFailure.unknown);
    }
  }

  Future<Either<SignInFailure, String>> createSession(
    String requestToken,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse(
          '$_baseUrl/authentication/session/new?api_key=$_apiKey',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            'request_token': requestToken,
          },
        ),
      );

      log('🐖');

      if (response.statusCode == 200) {
        final json = Map<String, dynamic>.from(
          jsonDecode(response.body),
        );

        final sessionId = json['session_id'] as String;
        return Either.right(sessionId);
      }
      log('☢️ ');
      return Either.left(SignInFailure.unknown);
    } catch (e) {
      if (e is SocketException) {
        return Either.left(SignInFailure.network);
      }
      return Either.left(SignInFailure.unknown);
    }
  }
}

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../../domain/either.dart';

enum HttpMethods {
  get,
  post,
  put,
  delete,
  patch,
}

class HttpFailure {
  HttpFailure({
    this.statusCode,
    this.exception,
  });

  final int? statusCode;
  final Object? exception;
}

class NetworkException {}

class Http {
  Http({
    required Client client,
    required String baseUrl,
    required String apiKey,
  })  : _client = client,
        _baseUrl = baseUrl,
        _apiKey = apiKey;

  final Client _client;
  final String _baseUrl;
  final String _apiKey;

  Future<Either<HttpFailure, R>> request<R>(
    String path, {
    required R Function(dynamic responseBody) onSuccess,
    HttpMethods method = HttpMethods.get,
    Map<String, String> headers = const {},
    Map<String, String> queryParams = const {},
    Map<String, dynamic> body = const {},
    bool useApiKey = true,
  }) async {
    Map<String, dynamic> logs = {};
    StackTrace? stackTrace;
    try {
      if (useApiKey) {
        queryParams = {
          ...queryParams,
          'api_key': _apiKey,
        };
      }

      Uri url = Uri.parse(
        path.startsWith('http') ? path : '$_baseUrl$path',
      );
      if (queryParams.isNotEmpty) {
        url = url.replace(queryParameters: queryParams);
      }

      headers = {
        'Content-Type': 'application/json',
        ...headers,
      };

      late final Response response;
      final bodyString = jsonEncode(body);
      logs = {
        '🔥': '🔥',
        'url': url.toString(),
        'method': method.name,
        'body': body,
      };

      switch (method) {
        case HttpMethods.get:
          response = await _client.get(
            url,
            headers: headers,
          );
        case HttpMethods.post:
          response = await _client.post(
            url,
            headers: headers,
            body: bodyString,
          );
        case HttpMethods.put:
          response = await _client.put(
            url,
            headers: headers,
            body: bodyString,
          );
        case HttpMethods.delete:
          response = await _client.delete(
            url,
            headers: headers,
            body: bodyString,
          );
        case HttpMethods.patch:
          response = await _client.patch(
            url,
            headers: headers,
            body: bodyString,
          );
      }

      final statusCode = response.statusCode;

      logs = {
        ...logs,
        'startTime': DateTime.now().toString(),
        'statusCode': statusCode,
        'responseBody': jsonDecode(response.body),
      };

      if (statusCode >= 200 && statusCode < 300) {
        return Either.right(
          onSuccess(response.body),
        );
      }

      return Either.left(
        HttpFailure(
          statusCode: statusCode,
        ),
      );
    } catch (e, s) {
      logs = {
        ...logs,
        'exception': e.runtimeType,
      };
      stackTrace = s;

      if (e is SocketException || e is ClientException) {
        logs = {
          ...logs,
          'exception': 'NetworkException',
        };

        return Either.left(HttpFailure(
          exception: NetworkException(),
        ));
      }

      return Either.left(
        HttpFailure(
          exception: e,
        ),
      );
    } finally {
      logs = {
        ...logs,
        'endTime': DateTime.now().toString(),
        '⛳️': '⛳️',
      };

      if (kDebugMode) {
        log(
          const JsonEncoder.withIndent(' ').convert(logs),
          stackTrace: stackTrace,
        );
        print('🤔');
      }
    }
  }
}

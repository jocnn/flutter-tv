import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'app/data/http/http.dart';
import 'app/data/repositories_implementation/account_repository_impl.dart';
import 'app/data/repositories_implementation/authentication_repository_impl.dart';
import 'app/data/repositories_implementation/connectivity_repository_imp.dart';
import 'app/data/services/local/session_service.dart';
import 'app/data/services/remote/account_api.dart';
import 'app/data/services/remote/authentication_api.dart';
import 'app/data/services/remote/internet_checker.dart';
import 'app/domain/repositories/account_repository.dart';
import 'app/domain/repositories/authentication_repository.dart';
import 'app/domain/repositories/connectivity_repository.dart';
import 'app/my_app.dart';

void main() {
  final http = Http(
    client: Client(),
    baseUrl: 'https://api.themoviedb.org/3',
    apiKey: '55563a8dde769ad740b54ac89f08206c',
  );
  final sessionService = SessionService(
    const FlutterSecureStorage(),
  );
  final accountAPI = AccountAPI(http);

  runApp(
    MultiProvider(
      providers: [
        Provider<AccountRepository>(
          create: (_) => AccountRepositoryImpl(
            accountAPI,
            sessionService,
          ),
        ),
        Provider<ConnectivityRepository>(
          create: (_) => ConnectivityRepositoryImp(
            Connectivity(),
            InternetChecker(),
          ),
        ),
        Provider<AuthenticationRepository>(
          create: (_) => AuthenticationRepositoryImpl(
            AuthenticationAPI(http),
            sessionService,
            accountAPI,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

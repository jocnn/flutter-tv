import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../domain/repositories/connectivity_repository.dart';
import '../services/remote/internet_checker.dart';

class ConnectivityRepImp implements ConnectivityRepository {
  final Connectivity _connectivity;
  final InternetChecker internetChecker;

  ConnectivityRepImp(this._connectivity, this.internetChecker);

  @override
  Future<bool> get hasInternet async {
    final List<ConnectivityResult> result =
        await _connectivity.checkConnectivity();
    debugPrint("🤔 Resultado conectividad: $result");

    if (result.contains(ConnectivityResult.none)) {
      return false;
    }
    return internetChecker.hasInternet();
  }
}

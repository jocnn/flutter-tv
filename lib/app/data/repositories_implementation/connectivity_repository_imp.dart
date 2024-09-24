import '../../domain/repositories/connectivity_repository.dart';

class ConnectivityRepImp implements ConnectivityRepository {
  @override
  Future<bool> get hasInternet => Future.value(true);
}

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectionChecker, this.connectivity);

  @override
  Future<bool> get isConnected async {
    if (GetStorage().read("only_wifi")) {
      List<ConnectivityResult> result = await connectivity.checkConnectivity();
      if (!result.contains(ConnectivityResult.wifi)) {
        return false;
      } else if (result.contains(ConnectivityResult.wifi)) {
        return await connectionChecker.hasConnection;
      } else {
        return false;
      }
    } else {
      List<ConnectivityResult> result = await connectivity.checkConnectivity();
      if (!result.contains(ConnectivityResult.none) &&
          !result.contains(ConnectivityResult.other)) {
        return connectionChecker.hasConnection;
      } else if (result == ConnectivityResult.none) {
        return false;
      } else {
        return false;
      }
    }
  }
}

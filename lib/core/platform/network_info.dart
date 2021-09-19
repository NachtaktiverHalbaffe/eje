import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_storage/get_storage.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final DataConnectionChecker connectionChecker;
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectionChecker, this.connectivity);

  @override
  Future<bool> get isConnected async {
    if (GetStorage().read("only_wifi")) {
      ConnectivityResult result = await connectivity.checkConnectivity();
      if (result != ConnectivityResult.wifi) {
        return false;
      } else if (result == ConnectivityResult.wifi) {
        return connectionChecker.hasConnection;
      } else {
        return false;
      }
    } else {
      ConnectivityResult result = await connectivity.checkConnectivity();
      if (result != ConnectivityResult.wifi) {
        return false;
      } else if (result == ConnectivityResult.wifi) {
        return connectionChecker.hasConnection;
      } else if (result != ConnectivityResult.mobile) {
        return false;
      } else if (result == ConnectivityResult.mobile) {
        return connectionChecker.hasConnection;
      } else if (result == ConnectivityResult.none) {
        return false;
      } else {
        return false;
      }
    }
  }
}

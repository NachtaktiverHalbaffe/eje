import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final DataConnectionChecker connectionChecker;
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectionChecker, this.connectivity);

  @override
  Future<bool> get isConnected async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool wifirestriction = prefs.getBool("only_wifi");
    if (wifirestriction) {
      ConnectivityResult result = await connectivity.checkConnectivity();
      if (result != ConnectivityResult.wifi) {
        return false;
      } else if (result == ConnectivityResult.wifi) {
        return connectionChecker.hasConnection;
      }
    } else
      return connectionChecker.hasConnection;
  }
}

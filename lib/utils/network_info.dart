import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    if (GetStorage().read("only_wifi")) {
      List<ConnectivityResult> result = await connectivity.checkConnectivity();
      if (!result.contains(ConnectivityResult.wifi)) {
        return false;
      } else if (result.contains(ConnectivityResult.wifi)) {
        return await InternetConnection().hasInternetAccess;
      } else {
        return false;
      }
    } else {
      List<ConnectivityResult> result = await connectivity.checkConnectivity();
      if (!result.contains(ConnectivityResult.none) &&
          !result.contains(ConnectivityResult.other)) {
        return InternetConnection().hasInternetAccess;
      } else if (result.contains(ConnectivityResult.none)) {
        return false;
      } else {
        return false;
      }
    }
  }
}

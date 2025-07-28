

import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> isConnected();
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl({required this.connectivity});


  @override
  Future<bool> isConnected() async {
  try {
    final List<ConnectivityResult> connectivityResults = await connectivity.checkConnectivity();

    // print('Connectivity results: $connectivityResults');

    final hasConnection = connectivityResults.any((result) =>
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile);

    return hasConnection;
  } catch (e) {
    // print('Error checking connectivity: $e');
    return false;
  }
}
}
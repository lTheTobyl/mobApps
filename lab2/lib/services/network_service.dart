import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  final Connectivity _connectivity = Connectivity();

  Future<bool> isConnected() async {
  var connectivityResult = await _connectivity.checkConnectivity();
  print("Стан з'єднання: $connectivityResult");
  return connectivityResult != ConnectivityResult.none;
  }
}
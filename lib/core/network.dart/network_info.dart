import 'package:connectivity/connectivity.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl extends NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    print("CHECKING CONNECTIVITY");
    final connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none)
      return false;
    else {
      /*    try {
        print("CHECKING IF PACKETS ARRIVE GOOD");
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          print("checked that it has connection");
          return true;
        } else {
          print("checked that it DOES NOT have connection");
          return false;
        }
      } on SocketException catch (e) {
        print("it cought some exception.... -> ${e.message}");
        return false;
      } */
      return true;
    }
  }
}


/* 
try {
  final result = await InternetAddress.lookup('google.com');
  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    print('connected');
  }
} on SocketException catch (_) {
  print('not connected');
}
 */
import 'package:get_together_app/core/network.dart/network_info.dart';
import 'package:mockito/mockito.dart';

class NetworkInfoMock extends Mock implements NetworkInfo {
  static final NetworkInfoMock _instance = NetworkInfoMock._internal();

  void setUpItHasConnection() {
    when(_instance.isConnected).thenAnswer((realInvocation) async => true);
  }

  void setUpNoConnection() {
    when(_instance.isConnected).thenAnswer((realInvocation) async => false);
  }

  factory NetworkInfoMock() => _instance;

  NetworkInfoMock._internal();
}

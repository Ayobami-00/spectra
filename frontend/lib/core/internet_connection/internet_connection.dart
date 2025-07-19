import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:rxdart/rxdart.dart';

abstract class InternetConnection {
  Future<bool> get isDeviceConnected;
  ValueStream<ConnectivityStatus> get onConnectivityChanged;
}

class InternetConnectionImpl implements InternetConnection {
  InternetConnectionImpl(this._connectivity);
  final Connectivity _connectivity;

  @override
  Future<bool> get isDeviceConnected => _connectivity.checkConnection();

  @override
  ValueStream<ConnectivityStatus> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;
}

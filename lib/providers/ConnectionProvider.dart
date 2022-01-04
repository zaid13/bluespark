

import 'package:flutter/material.dart';

class ConnectionProvider with ChangeNotifier {
  ConnectionProvider();

  Future<void> _checkIfBluetoothIsOn() async {}
  Future<void> _checkIfLocationServiceIsOn() async {}
  Future<void> _getALlBluetoothDevices() async {}
  Future<void> _getALlBluetoothServices() async {}
  Future<void> _IntializeBlueSparkService() async {}


}
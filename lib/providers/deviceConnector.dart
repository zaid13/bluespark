import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

  Future<void> disconnect(String deviceId, StreamSubscription<ConnectionStateUpdate> _connection) async {
    try {
      print('disconnecting to device: $deviceId');
      await _connection.cancel();
    } on Exception catch (e, _) {
      print("Error disconnecting from a device: $e");
    } finally {
      // // Since [_connection] subscription is terminated, the "disconnected" state cannot be received and propagated
      // _deviceConnectionController.add(
      //   ConnectionStateUpdate(
      //     deviceId: deviceId,
      //     connectionState: DeviceConnectionState.disconnected,
      //     failure: null,
      //   ),
      // );
    }
  }

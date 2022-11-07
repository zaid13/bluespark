
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:nearby_connections/nearby_connections.dart';

import '../util/functions.dart';



final Location location = Location();


Future<void> getLocation() async {


  try {

// For bluetooth permissions on Android 12+.
    bool d = await Nearby().checkBluetoothPermission().then((value) async {
      if(!value) {
        Nearby().askBluetoothPermission();
     //   restartApp();
      }

      return value;
    });
// asks for BLUETOOTH_ADVERTISE, BLUETOOTH_CONNECT, BLUETOOTH_SCAN permissions.

    if(!d) {
      Nearby().askBluetoothPermission();
   //   restartApp();

    }




  } on PlatformException {

  }
}
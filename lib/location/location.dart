
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

//


final Location location = Location();


Future<void> getLocation() async {
  if (defaultTargetPlatform == TargetPlatform.android){

    try {
// For bluetooth permissions on Android 12+.
    bool d = await Nearby().checkBluetoothPermission().then((value) async {
      if (!value)
        Nearby().askBluetoothPermission();

      return value;
    });
// asks for BLUETOOTH_ADVERTISE, BLUETOOTH_CONNECT, BLUETOOTH_SCAN permissions.

    if (!d)
      Nearby().askBluetoothPermission();
  } on PlatformException {

  }
}

 Future.delayed(Duration(milliseconds: 100),() async {
 await Permission.storage.request();
 await Permission.locationAlways.request();
 await Permission.location.request();
 await Permission.nearbyWifiDevices.request();
 await Permission.bluetoothAdvertise.request();
 await Permission.manageExternalStorage.request();
 await Permission.accessMediaLocation.request();
 await Permission.bluetoothConnect.request();
 await Permission.bluetooth.request();
 await Permission.bluetoothScan.request();});


}
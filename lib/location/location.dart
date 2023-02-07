
import 'package:flutter/services.dart';
// import 'package:location/location.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

//





Future<void> getLocation() async {


    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.nearbyWifiDevices






    ].request();





    await Permission.bluetooth.request().then((value)  {


      if(PermissionStatus.denied == value){
        Permission.bluetooth.request();
      }

    });
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.location.request();

        Permission.location.request();






}
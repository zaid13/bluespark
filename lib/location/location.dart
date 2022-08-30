
import 'package:flutter/services.dart';
import 'package:location/location.dart';



final Location location = Location();


Future<void> getLocation() async {

  try {
    final LocationData _locationResult = await location.getLocation();

  } on PlatformException {

  }
}
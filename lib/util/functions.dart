

import 'dart:async';

import 'package:flutter/services.dart';


void restartApp() async {
  FlutterRestart.restartApp();
}


class FlutterRestart {
  static const MethodChannel _channel =
  MethodChannel('flutter_restart');

//  static Future<String> get platformVersion async {
//    final String version = await _channel.invokeMethod('getPlatformVersion');
//    return version;
//  }
  static Future<bool> restartApp() async{
    final result = await _channel.invokeMethod('restartApp');
    return result;
  }
}


ASCII_TO_INT(name) {
  List<int> intList = [];

  //loop to each character in string
  for (int i = 0; i < name.length; i++) {
    intList.add(name.codeUnitAt(i));
  }
  return intList + [13];
}


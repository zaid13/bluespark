


import 'dart:async';
import 'dart:io';

import 'package:bluespark/util/config.dart';
import 'package:flutter/material.dart';

class SendProvider with ChangeNotifier {
  late Stream<List<int>>? subscribeStream;

  bool deviceAvailable =true;


  initalizeSendProvider(Stream <List<int>> sS ){
    subscribeStream  = sS;
    deviceAvailable= false;
  }

  listenToDevice(){
    deviceAvailable.
  }
  sendData(String data ){

  }



}



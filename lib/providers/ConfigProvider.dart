

import 'package:flutter/material.dart';

class ConfigProvider with ChangeNotifier {



  List<String> packets= [];
  Map<String,bool > receivedPackets = {};

  double PercentageOFVerifiedPackets = 0.0;



  freshMap(){

    packets  = [];
    PercentageOFVerifiedPackets = 0.0;
    receivedPackets = {};
    notifyListeners();

  }


  allPacketFound(){
    receivedPackets.forEach((key, value) {
      receivedPackets[key] = true;
    });
  }
  loadListWithCounter(value){


    String numberValue  = (value as String).trim().replaceFirst('<', '').replaceFirst('>', '');

    String expectedNumber = '<'+(int.parse(numberValue)+1).toString()+'>';

    if(int.parse(numberValue) ==255){
      expectedNumber = '<'+(0).toString()+'>';
    }


    packets = [expectedNumber] ;

    for (var i in packets){
      receivedPackets.addAll({i:false});
    }
    print('the latest lis is  $receivedPackets');


    return expectedNumber;
  }
  loadListWithResponses(value){


    packets = [value] ;

    for (var i in packets){
      receivedPackets.addAll({i:false});
    }
    print('the latest lis is  $receivedPackets');


    return value;
  }

  keyFound(String expectedNumber){
    print('Record found $expectedNumber');



    receivedPackets[expectedNumber] = true;


  }

   bool isKeyRecieved (String key){
    if( receivedPackets[key] ==null){
      print('the record for string $key    doesnt exitrs returning NULL');

      return false;}

    return  receivedPackets[key] as bool;

  }

  updatePercentageOFVerifiedPackets(verifiedPackets){
    int totalValues =33;



    print('verifiedPackets');
    print(verifiedPackets);
    print('totalValues');
    print(totalValues);

    PercentageOFVerifiedPackets =  (verifiedPackets/totalValues);

    notifyListeners();

}

  getPercentageOFVerifiedPackets(){
    return PercentageOFVerifiedPackets;


  }

}


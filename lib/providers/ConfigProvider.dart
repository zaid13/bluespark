
import 'dart:io';

import 'package:bluespark/util/config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigProvider with ChangeNotifier {


  List<bool> packetsRecived= [];
  List<String> packets= [];

  double PercentageOFVerifiedPackets = 0.0;



  freshMap(){
    packetsRecived =[];
    packets  = [];
    PercentageOFVerifiedPackets = 0.0;
    notifyListeners();

  }



  keyFound(String key){


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


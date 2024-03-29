import 'dart:convert';

import 'package:bluespark/util/config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bluespark/providers/SendProvider.dart';
import '../main.dart';
import '../models/BoxModel.dart';
import '../util/functions.dart';
import 'box_storage.dart';

class CommandProvider with ChangeNotifier {
  String time = "25";
  late Function fun;

  CommandProvider();
  String readOutput = "";
  String timeRemaining = "0";
  bool cancelledRequest = false;
  bool MovingToNextScreen = false;
  bool syncingDatra = false;
  int swipeToChangeIsEnable = 1;

  bool timeIsZeroReported = false;

  ScallerMapper scllerMapper = ScallerMapper();

  var ScallerMapperContex = null;
  setScallerMapperContext(context) {
    ScallerMapperContex = context;
  }

  nullScallerMapperContext() {
    ScallerMapperContex = null;
  }

  getData() async {
    final prefs = await SharedPreferences.getInstance();

    var data = prefs.getBool('isFirstTime');

    print("________________________________________________________________");
    print(data.toString());
    if (data == null) {
    } else if (data) {
      disable_all_messages();
    } else {
      disable_all_messages();
    }
  }






  setSwipeToChangeIsDisable() {
    if (swipeToChangeIsEnable == 1) {
      swipeToChangeIsEnable = 2;
      notifyListeners();
    }
  }

  disable_all_messages() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isFirstTime', true);

    swipeToChangeIsEnable = 0;
    notifyListeners();
  }

  isScallerSet() {
    scllerMapper.isScallerSet = true;
    notifyListeners();
  }

  isScaller() {
    scllerMapper.isScaller = true;
    notifyListeners();
  }

  isNotScaller() {
    scllerMapper.isScaller = false;
    notifyListeners();
  }

  getErrorString(errorKey) {
    return scallerMapperErrorTable[errorKey];
  }

  isMapperError() {
    if (!scllerMapper.MAP_ERROR_IS_OPEN) {
      scllerMapper.MAP_ERROR_IS_OPEN = true;
      notifyListeners();
    }
  }

  isScallerError() {
    if (!scllerMapper.SCALLER_ERROR_IS_OPEN) {
      scllerMapper.SCALLER_ERROR_IS_OPEN = true;
      notifyListeners();
    }
  }

  MAPPER_ERROR_CLOSED() {
    if (scllerMapper.MAP_ERROR_IS_OPEN) {
      scllerMapper.MAP_ERROR_IS_OPEN = false;
      notifyListeners();
    }
  }

  SCALLER_ERROR_CLOSED() {
    if (scllerMapper.SCALLER_ERROR_IS_OPEN) {
      scllerMapper.SCALLER_ERROR_IS_OPEN = false;
      notifyListeners();
    }
  }

  ScallerMapperUpdateSucessfully() {
    if (!scllerMapper.UpdateSucessfully) {
      scllerMapper.UpdateSucessfully = true;
      notifyListeners();
      print("*********");

      Future.delayed(const Duration(seconds: 1), () {
        scllerMapper.UpdateSucessfully = false;

        notifyListeners();
      });
    }
  }

  setScaller(newScallerValue) {
    if (scllerMapper.scallerSelected != newScallerValue) {
      scllerMapper.scallerSelected = newScallerValue;
      notifyListeners();
    }
  }

  setMapper(newMapperValue) {
    if (scllerMapper.mapperSelected != newMapperValue) {
      scllerMapper.mapperSelected = newMapperValue;
      notifyListeners();
    }
  }

  set_RESPONSE_Scaller(newScallerValue) {
    if (scllerMapper.RESPONSE_scallerSelected != newScallerValue) {
      scllerMapper.RESPONSE_scallerSelected = newScallerValue;

      notifyListeners();
      ScallerMapperUpdateSucessfully();
    }
  }

  set_RESPONSE_Mapper(newMapperValue) {
    if (scllerMapper.RESPONSE_mapperSelected != newMapperValue) {
      scllerMapper.RESPONSE_mapperSelected = newMapperValue;
      notifyListeners();
      ScallerMapperUpdateSucessfully();
    }
  }

  isRequesting() {
    if (!scllerMapper.isRequesting) {
      scllerMapper.isRequesting = true;
      notifyListeners();
    }
  }

  isNotRequesting() {
    if (scllerMapper.isRequesting) {
      scllerMapper.isRequesting = false;
      notifyListeners();
    }
  }

  startMovingTonextScreen() {
    // if(!MovingToNextScreen){
    MovingToNextScreen = true;
    // }

    notifyListeners();
  }

  stopMovingTonextScreen() {
    if (MovingToNextScreen) {
      MovingToNextScreen = false;
    }
    notifyListeners();
  }

  stopSendingRequests() {
    timeRemaining = "0";
    cancelledRequest = true;

    notifyListeners();
  }

  bool setTime(String newTime) {
    print('logs from setTime function');
    print(newTime + '  -' + timeRemaining + '-');
    print(isNumeric(newTime));

    print(timeRemaining == '0');



    if(isNumeric(newTime)){
      print(sc);

      if(sc == screen_state.welcome){
        BoxStorage.connectedToBox(macAddressSent);
      }
      if (sc == screen_state.pinscreen) {
        print('move to welcome screen');

        Navigator.pop(NavigationService.navigatorKey.currentContext!);



        sc = screen_state.welcome;
        BoxStorage.storeBox(true);
      }
    }


    if ((isNumeric(newTime) && timeRemaining != newTime) ||
        (isNumeric(newTime) && timeRemaining == '0')) {


      print("new TIME:$newTime---");

      timeRemaining = newTime;
      notifyListeners();

      print(getIntTime());

      print(timeIsZeroReported);

      if (timeIsZeroReported && getIntTime() > 0) {
        print("APP SHOULD RESTART ");
        timeIsZeroReported = false;

        if (ScallerMapperContex != null) {
          Navigator.pop(ScallerMapperContex);
        }

        //  restartApp();
      }

      if (getIntTime() == 0) {
        timeIsZeroReported = true;
        print("tiem is zero ");
        return true;
      }
    }
    return false;
  }

  getIntTime() {
    return int.parse(timeRemaining);
  }

  getTime() {
    return timeRemaining;
  }

  setReadOutput(newPOutput) {
    readOutput = newPOutput;
    notifyListeners();
  }

  setSyncOn() {
    scllerMapper.syncIsOn = true;
    notifyListeners();
  }

  setSyncOff() {
    scllerMapper.syncIsOn = false;
    notifyListeners();
  }
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

class ScallerMapper {
  bool disableTimer = true;
  bool isRequesting = false;
  bool isScaller = true;
  bool isScallerSet = false;
  bool UpdateSucessfully = false;
  bool MAP_ERROR_IS_OPEN = false;
  bool SCALLER_ERROR_IS_OPEN = false;

  bool syncIsOn = false;

  String mapperSelected = "A";
  String scallerSelected = "3";

  String RESPONSE_mapperSelected = "2";
  String RESPONSE_scallerSelected = "3";
}

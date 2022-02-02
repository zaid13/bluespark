

import 'package:flutter/material.dart';

class CommandProvider with ChangeNotifier {
  CommandProvider();
  String readOutput="";
  String timeRemaining = "31";
  bool cancelledRequest = false;
  bool MovingToNextScreen = false;


  startMovingTonextScreen(){
    // if(!MovingToNextScreen){
      MovingToNextScreen = true;
    // }

    notifyListeners();

  }
  stopMovingTonextScreen(){

    if(MovingToNextScreen){
      MovingToNextScreen = false;
    }
    notifyListeners();

  }



  decreasetimeRemaining(){
    int intTimeReaamiaining = int.parse(timeRemaining);
    if(intTimeReaamiaining>0){
      intTimeReaamiaining++;
    }
    timeRemaining = intTimeReaamiaining.toString();
    notifyListeners();

  }

  stopSendingRequests (){
    timeRemaining = "0";
    cancelledRequest = true;


    notifyListeners();
  }
  setTime(String newTime ){
    print("setting nerw time");
    print(newTime);

        timeRemaining = newTime;
    notifyListeners();
  }
  getTime(){
    return timeRemaining;
  }
  setReadOutput(newPOutput){
    readOutput = newPOutput;
    notifyListeners();
  }
  restartListening(){
    timeRemaining = "31";
    cancelledRequest = false;

    notifyListeners();
  }

  // write(){}
  // Future<void> _getDeviceType() async {}
  // Future<void> _getMap() async {}
  // Future<void> _getScaller() async {}
  // Future<void> _getWUT() async {}
  // Future<void> _IntializeBlueSparkService() async {}
  //
  //


}
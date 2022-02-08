import 'package:flutter/material.dart';

class CommandProvider with ChangeNotifier {


  CommandProvider();
  String readOutput = "";
  String timeRemaining = "31";
  bool cancelledRequest = false;
  bool MovingToNextScreen = false;


  ScallerMapper scllerMapper = ScallerMapper();




  setScaller(newScallerValue){

    if(scllerMapper.scallerSelected!=newScallerValue){
      scllerMapper.scallerSelected=newScallerValue;
      notifyListeners();
    }

  }
  setMapper(newMapperValue){

    if(scllerMapper.mapperSelected!=newMapperValue){
      scllerMapper.mapperSelected=newMapperValue;
      notifyListeners();
    }

  }

  isRequesting(){
    if(!scllerMapper.isRequesting){
      scllerMapper.isRequesting=true;
      notifyListeners();
    }

  }
  isNotRequesting(){

    if(scllerMapper.isRequesting){
      scllerMapper.isRequesting=false;
      notifyListeners();
    }

  }

  ///////////////////////
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

  decreasetimeRemaining() {
    int intTimeReaamiaining = int.parse(timeRemaining);
    if (intTimeReaamiaining > 0) {
      intTimeReaamiaining++;
    }
    timeRemaining = intTimeReaamiaining.toString();
    notifyListeners();
  }

  stopSendingRequests() {
    timeRemaining = "0";
    cancelledRequest = true;

    notifyListeners();
  }

  bool setTime(String newTime) {
    if (isNumeric(newTime)) {
      print("new TIME:${newTime}---");

      timeRemaining = newTime;
      notifyListeners();
      if (getIntTime() == 0) {
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

  restartListening() {
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

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}


class ScallerMapper{

  bool isRequesting = false;
  bool onlyScaller = false;

  String mapperSelected = "A";
  String scallerSelected = "3";




}
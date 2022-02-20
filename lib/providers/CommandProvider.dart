import 'dart:io';

import 'package:bluespark/util/config.dart';
import 'package:flutter/material.dart';

class CommandProvider with ChangeNotifier {


  CommandProvider();
  String readOutput = "";
  String timeRemaining = "0";
  bool cancelledRequest = false;
  bool MovingToNextScreen = false;
  bool swipeToChangeIsEnable = true;


  ScallerMapper scllerMapper = ScallerMapper();



  setSwipeToChangeIsEnable(){
    swipeToChangeIsEnable = true;
    notifyListeners();
  }

   setSwipeToChangeIsDisable(){
     swipeToChangeIsEnable = false;
     notifyListeners();
  }
  isScallerSet(){

    scllerMapper.isScallerSet = true;
    notifyListeners();
  }

  isScaller(){
    scllerMapper. isScaller = true;
    notifyListeners();
  }

  isNotScaller(){
    scllerMapper. isScaller = false;
    notifyListeners();
  }

  getErrorString(errorKey){


    return scallerMapperErrorTable[errorKey];
  }

  isMapperError(){

    if(!scllerMapper.MAP_ERROR_IS_OPEN){
      scllerMapper.MAP_ERROR_IS_OPEN = true;
      notifyListeners();
    }

  }

  isScallerError(){

    if(!scllerMapper.SCALLER_ERROR_IS_OPEN){
      scllerMapper.SCALLER_ERROR_IS_OPEN = true;
      notifyListeners();
    }

  }

  MAPPER_ERROR_CLOSED(){

    if(scllerMapper.MAP_ERROR_IS_OPEN){
      scllerMapper.MAP_ERROR_IS_OPEN = false;
      notifyListeners();
    }
  }
  SCALLER_ERROR_CLOSED(){

    if(scllerMapper.SCALLER_ERROR_IS_OPEN){
      scllerMapper.SCALLER_ERROR_IS_OPEN = false;
      notifyListeners();
    }
  }



  ScallerMapperUpdateSucessfully(){

    if(!scllerMapper.UpdateSucessfully){
      scllerMapper.UpdateSucessfully = true;
      notifyListeners();
      print("*********");

     Future.delayed(Duration(seconds:1),(){

       scllerMapper.UpdateSucessfully = false;

       notifyListeners();

     });


    }}

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
  set_RESPONSE_Scaller(newScallerValue){

    if(scllerMapper.RESPONSE_scallerSelected!=newScallerValue){
      scllerMapper.RESPONSE_scallerSelected=newScallerValue;

      notifyListeners();
      ScallerMapperUpdateSucessfully();
    }

  }
  set_RESPONSE_Mapper(newMapperValue){

    if(scllerMapper.RESPONSE_mapperSelected!=newMapperValue){
      scllerMapper.RESPONSE_mapperSelected=newMapperValue;
      notifyListeners();
      ScallerMapperUpdateSucessfully();
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

  // decreasetimeRemaining() {
  //   int intTimeReaamiaining = int.parse(timeRemaining);
  //   if (intTimeReaamiaining > 0) {
  //     intTimeReaamiaining++;
  //   }
  //   timeRemaining = intTimeReaamiaining.toString();
  //   notifyListeners();
  // }

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
  //
  // restartListening() {
  //   timeRemaining = "31";
  //   cancelledRequest = false;
  //
  //   notifyListeners();
  // }

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
  bool isScaller = true;
  bool isScallerSet = false;
  bool UpdateSucessfully = false;
  bool MAP_ERROR_IS_OPEN = false;
  bool SCALLER_ERROR_IS_OPEN = false;

  String mapperSelected = "A";
  String scallerSelected = "3";


  String RESPONSE_mapperSelected = "2";
  String RESPONSE_scallerSelected = "3";




}
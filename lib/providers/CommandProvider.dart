import 'dart:io';

import 'package:bluespark/util/config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommandProvider with ChangeNotifier {

  String time = "25";
  late Function fun ;



  CommandProvider();
  String readOutput = "";
  String timeRemaining = "0";
  bool cancelledRequest = false;
  bool MovingToNextScreen = false;
  bool syncingDatra = false;
  int swipeToChangeIsEnable = 1;






  ScallerMapper scllerMapper = ScallerMapper();

  getData() async {
    final prefs = await SharedPreferences.getInstance();

    var data = await prefs.getBool('isFirstTime');

    print("________________________________________________________________");
    print(data.toString());
    if(data==null){

    }
    else if(data){
      disable_all_messages();
    }
    else{
      disable_all_messages();
    }

  }
  //
  // setSwipeToChangeIsEnable(){
  //   swipeToChangeIsEnable = 1;
  //   notifyListeners();
  // }

   setSwipeToChangeIsDisable(){
    if(swipeToChangeIsEnable == 1){
      swipeToChangeIsEnable = 2;
      notifyListeners();
    }

  }
  disable_all_messages() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isFirstTime',true);


    swipeToChangeIsEnable = 0;
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
    print('logs from setTime function');
    print(newTime + '  -' + timeRemaining+'-');
    if (isNumeric(newTime) &&  timeRemaining != newTime ) {

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


  setSyncOn(){
    scllerMapper. syncIsOn = true;
    notifyListeners();
  }
  setSyncOff(){
    scllerMapper. syncIsOn = false;
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
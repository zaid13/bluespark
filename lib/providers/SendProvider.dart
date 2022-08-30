import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import '../src/utils.dart';
import '../util/functions.dart';
import 'CommandProvider.dart';

class SendProvider with ChangeNotifier {
  late Stream<List<int>>? subscribeStream;
  late Function  writeCharacteristicWithoutResponse;
  late QualifiedCharacteristic characteristic;

  StreamController<String> dataFromDeviceStream = StreamController<String>();


  List<int> PrevDump = [];

  bool deviceAvailable = false;

  initalizeSendProvider(Stream<List<int>> sS,Function  ValwriteCharacteristicWithoutResponse , QualifiedCharacteristic valcharacteristic ) {
    subscribeStream = sS;
    deviceAvailable = false;
    writeCharacteristicWithoutResponse =ValwriteCharacteristicWithoutResponse;
    characteristic = valcharacteristic;
  }

  listenToDevice() {

    Stream stream = dataFromDeviceStream.stream;
    stream.listen((event) {
      print(' listenToDevice Send Provider :$event');
    });


  }

  sendData(String data) async {
    print('SENDING DATA:$data FROM SEND PROVIDER');
    if(deviceAvailable) {
      writeCharacteristicWithoutResponse(characteristic, ASCII_TO_INT(data));
    }
    else{
      deviceAvailable = false;
      notifyListeners();
  await    Future.delayed(const Duration(milliseconds: 500),(){
        writeCharacteristicWithoutResponse(characteristic, ASCII_TO_INT(data));
      });

    }
  }

  listenTOWelcomeScreen( CommandProvider commandProvider , Function moveTOScallerMapperManager) {
    subscribeStream?.listen((result) {

      List<String> resultStringList = String.fromCharCodes(result).split("\n");


      int i=0;
      resultStringList.forEach((resultString) {

        print('SEND ${i++} result $result');
        print('SEND resultString $resultString');
        print('SEND RegEx $regExForSendTokenCount');


        if( resultString.length>1 && RegExp(regExForSendTokenCount).hasMatch(resultString.trim()) ){
          callibrateSendTokenId(resultString);
        }



      });

      handleTimerForWelcomeScreen(commandProvider,moveTOScallerMapperManager,result);


    });
  }

  handleTimerForWelcomeScreen(CommandProvider commandProvider , Function moveTOScallerMapperManager , result){

    commandProvider.setReadOutput(result.toString());
    String resultString = String.fromCharCodes(result).split("\n")[0];
    dataFromDeviceStream.add(resultString);

    // print('readOutput CONVERTED    ${resultString}');

    print('resultString SEND PROVDER ');
    print(resultString);
    print('result');
    print(result);
    print(result.first);
    print(result.last);
    print(result.first == 35 &&
        result.last == 13 );

    if (result.first == 35 &&
        result.last == 10 &&
        resultString.replaceAll("#WUT_", "").replaceAll("#", "") !=
            commandProvider.getTime()) {
      print('Complete ');
      print(result);
      setTime(resultString, commandProvider, moveTOScallerMapperManager);
    } else if ((result.first == 35 &&
        result.last != 10 &&    result.last!=13 &&
        resultString.replaceAll("#WUT_", "").replaceAll("#", "") !=
            commandProvider.getTime())) {
      print('Complete 2 ');
      PrevDump = result;
      // print("FOUND FIRST PA RT -------------------------------_____=-$result.last");

    } else if ((result.first != 35 &&
        result.last == 10 &&
        resultString.replaceAll("#WUT_", "").replaceAll("#", "") !=
            commandProvider.getTime())) {
      // print(PrevDump);
      // print(resultString);

      PrevDump += result;
      result = [];
      print("FOUND SECOND PART -------------------------------_____=-");
      print(PrevDump);
      print(String.fromCharCodes(PrevDump).split("\n")[0].split('^')[0]);
      setTime(String.fromCharCodes(PrevDump).split("\n")[0].split('^')[0],
          commandProvider, moveTOScallerMapperManager);
    } else if (result.first == 35 &&
        result.last == 13
    // &&
    // resultString.replaceAll("#WUT_", "").replaceAll("#", "") !=
    //     commandProvider.getTime()
    ) {
      print('Complete ');
      print(result);
      setTime(resultString, commandProvider, moveTOScallerMapperManager);
    } else if ((result.first == 35 &&
        result.last != 13 &&
        resultString.replaceAll("#WUT_", "").replaceAll("#", "") !=
            commandProvider.getTime())) {
      print('Complete 2 ');
      PrevDump = result;
      // print("FOUND FIRST PA RT -------------------------------_____=-$result.last");

    } else if ((result.first != 35 &&
        result.last == 13 &&
        resultString.replaceAll("#WUT_", "").replaceAll("#", "") !=
            commandProvider.getTime())) {
      // print(PrevDump);
      // print(resultString);

      PrevDump += result;
      result = [];
      print("FOUND SECOND PART -------------------------------_____=-");
      print(PrevDump);
      print(String.fromCharCodes(PrevDump).split("\n")[0].split('^')[0]);
      setTime(String.fromCharCodes(PrevDump).split("\n")[0].split('^')[0],
          commandProvider, moveTOScallerMapperManager);
    }
  }

  callibrateSendTokenId(resultString){
    print('LOGS FROM SEND PROVIDER TICKET : $resultString');
    deviceAvailable = true;
    notifyListeners();
  }

  setTime(resultString, commandProvider, Function moveTOScallerMapperManager) async {
    print('setTime');
    print(resultString);

    if (resultString.startsWith('#DEV_')) {
      print('WE JUST GOT DEV RES:$resultString');
      if (100 <
          int.parse(resultString.replaceAll("#DEV_", "").replaceAll("^", ""))) {
        commandProvider.isScaller();
        commandProvider.isScallerSet();
      } else if (100 >=
          int.parse(resultString.replaceAll("#DEV_", "").replaceAll("^", ""))) {
        commandProvider.isNotScaller();
        commandProvider.isScallerSet();
      }
    }

    if (commandProvider
        .setTime(resultString.replaceAll("#WUT_", "").replaceAll("^", ""))) {
      print(
          'time is up moving to scaller mapper scaller is ${commandProvider.scllerMapper.isScallerSet} ');

      //move to next screen

      print('commandProvider.scllerMapper.isScallerSet');
      print(commandProvider.scllerMapper.isScallerSet);
      print('commandProvider.scllerMapper.disableTimer');
      print(commandProvider.scllerMapper.disableTimer);

      if (commandProvider.scllerMapper.isScallerSet &&
          commandProvider.scllerMapper.disableTimer) {
        moveTOScallerMapperManager();
      }
    }
  }




}

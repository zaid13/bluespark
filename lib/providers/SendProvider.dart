import 'dart:async';
import 'dart:convert';

import 'package:bluespark/providers/box_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import '../main.dart';
import '../screens/welcome/pin_popUp.dart';
import '../src/utils.dart';
import '../util/config.dart';
import '../util/functions.dart';
import 'CommandProvider.dart';


enum screen_state { first, pinscreen , welcome }
screen_state sc = screen_state.first;
String lastPasswordSent = '';
String macAddressSent = '';
String nickName = '';


class SendProvider with ChangeNotifier {
  late Stream<List<int>>? subscribeStream;
  late Function  writeCharacteristicWithoutResponse;
  late Function  readCharacteristic;
  late QualifiedCharacteristic characteristic;

  StreamController<String> dataFromDeviceStream = StreamController<String>();


  List<int> PrevDump = [];
  List<int> PrevDump_inner = [];


  bool deviceAvailable = false;





  initalizeSendProvider(Future<List<int>> Function(QualifiedCharacteristic characteristic) readCharecteristic,Stream<List<int>> sS,Function  ValwriteCharacteristicWithoutResponse , QualifiedCharacteristic valcharacteristic ) {
    subscribeStream = sS;
    deviceAvailable = false;
    writeCharacteristicWithoutResponse =ValwriteCharacteristicWithoutResponse;
    readCharacteristic = readCharecteristic;
    characteristic = valcharacteristic;
  }

  listenToDevice() {

    Stream stream = dataFromDeviceStream.stream;
    stream.listen((event) {
      print('  :$event');
    });


  }

  readDate() async {
    var readResult  = await    readCharacteristic(characteristic);

  List<String> resultStringList = String.fromCharCodes(readResult).split("\n");

  print('resultStringList');
  print(resultStringList);

  return resultStringList;
  }
  sendData(String data) async {
    print('SENDING DATA:$data FROM SEND PROVIDER de vice is $deviceAvailable');

    int time = DateTime.now().millisecond;


    if(true) {
    print("MS TOOK: ${DateTime.now().millisecond-time}");
      writeCharacteristicWithoutResponse(characteristic, ASCII_TO_INT(data));
    }
    else{
      deviceAvailable = false;
      // notifyListeners();
  await    Future.delayed(const Duration(milliseconds: delay_time_V_small),(){
    print("MS TOOK: ${DateTime.now().millisecond-time}");

    writeCharacteristicWithoutResponse(characteristic, ASCII_TO_INT(data));
      });

    }
  }

  listenTOWelcomeScreen( CommandProvider commandProvider , Function moveTOScallerMapperManager) {
      subscribeStream?.listen((result) {



       String constructedString = String.fromCharCodes(result).replaceAll('>', '>\n');
       List<String> resultStringList =  constructedString .split("\n");
print('resultStringList');
print(resultStringList);

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


  PushScreeenChangeStatus(){


    if(sc!=screen_state.pinscreen){
      sc =screen_state.pinscreen;


      Navigator.push(NavigationService.navigatorKey.currentContext!,
          MaterialPageRoute(builder: (ctx) => PinCodeVerificationScreen()));
    }

    print(NavigationService.navigatorKey.currentContext);

  }
  ifStringContainsPasswordString_MoveToPinScreen(resultString)  {
    if(resultString.contains(resPasswordString) && (sc!=screen_state.pinscreen  )){



      Future.delayed(Duration(milliseconds: 10),() async {
        print("move to next screen");
        if(  await BoxStorage.checkIfboxDataIsAvailable(macAddressSent)){
          PushScreeenChangeStatus();
          print("BOX DATA FOUND ");

         String pin =  await BoxStorage.getPasswordPin(macAddressSent);
          print("BOX DATA FOUND for $macAddressSent ");

          DateTime _now = DateTime.now();
          await sendData(passwordString+pin);
          Duration dur = _now.difference(DateTime.now());
          print("seconds: ${dur.inSeconds} ${dur.inMilliseconds}");




        }
        else{
          PushScreeenChangeStatus();
        }
      });


    }
  }

  handleTimerForWelcomeScreen(CommandProvider commandProvider , Function moveTOScallerMapperManager , result){

    commandProvider.setReadOutput(result.toString());


    String resultString = String.fromCharCodes(result).split("\n")[0];


    String constructedString = String.fromCharCodes(result).replaceAll('>', '>\n');
    List<String> constructedresultStringList =  constructedString .split("\n");



    dataFromDeviceStream.add(resultString);



    print('resultString SEND PROVDER ');
    print(resultString);
    print('result');
    print(result);
    print(result.first);
    print(result.last);


    print('constructedresultStringList');
    print(constructedresultStringList);
    print('constructedresultStringList LENGTH');
    print(constructedresultStringList.length);


    if(constructedresultStringList.length>1){

      for (String i in constructedresultStringList){
        i = i.trim();
        result = AsciiEncoder().convert(i);
        resultString = i;



        if(i.contains("<")==false && i.isNotEmpty){

          print('inner loop ');
          print(result);
          print(resultString);
          print('PrevDump');
          print(PrevDump);
          print('PrevDump_inner');
          print(PrevDump_inner);

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
            print("FOUND SECOND PA RT -------------------------------_____=-");
            print(PrevDump);
            print(String.fromCharCodes(PrevDump).split("\n")[0].split('^')[0]);
            setTime(String.fromCharCodes(PrevDump).split("\n")[0].split('^')[0],
                commandProvider, moveTOScallerMapperManager);


          } else if (result.first == 35 &&
              result.last == 13) {
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
              result.last == 13
          )   ) {

            if(sc== screen_state.first   ){
              PrevDump += result;
              result = [];
              print("FOUND SECOND PART FOR THE FIRST STATE  -------------------------------_____=-");



            }

            if( resultString.replaceAll("#WUT_", "").replaceAll("#", "") !=
                commandProvider.getTime()){

              List<int> intList = [];

              for( var  t in result){
                intList.add(t);
              }
              PrevDump += intList;
              result = [];
              print("FOUND SECOND PART -------------------------------_____=-");
              print(PrevDump);
              print(String.fromCharCodes(PrevDump).split("\n")[0]);
              setTime(String.fromCharCodes(PrevDump).split("\n")[0],
                  commandProvider, moveTOScallerMapperManager);
            }




          }

          if(result.first==35 && result.last==94){
            setTime(String.fromCharCodes(result),
                commandProvider, moveTOScallerMapperManager);
          }
          else if (result.first==35 && result.last!=94) {
            PrevDump_inner = result;
          }
          else if(result.first!=35 && result.last==94){

            result =  PrevDump_inner+result ;
            setTime(String.fromCharCodes(result),
                commandProvider, moveTOScallerMapperManager);


          }


        }

      }



    }else{
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
        print("FOUND SECOND PA RT -------------------------------_____=-");
        print(PrevDump);
        print(String.fromCharCodes(PrevDump).split("\n")[0].split('^')[0]);
        setTime(String.fromCharCodes(PrevDump).split("\n")[0].split('^')[0],
            commandProvider, moveTOScallerMapperManager);


      } else if (result.first == 35 &&
          result.last == 13) {
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
          result.last == 13
      )   ) {

        if(sc== screen_state.first   ){
          PrevDump += result;
          result = [];
          print("FOUND SECOND PART FOR THE FIRST STATE  -------------------------------_____=-");



        }

        if( resultString.replaceAll("#WUT_", "").replaceAll("#", "") !=
            commandProvider.getTime()){

          List<int> intList = [];

          for( var  t in result){
            intList.add(t);
          }
          PrevDump += intList;
          result = [];
          print("FOUND SECOND PART -------------------------------_____=-");
          print(PrevDump);
          print(String.fromCharCodes(PrevDump).split("\n")[0]);
          setTime(String.fromCharCodes(PrevDump).split("\n")[0],
              commandProvider, moveTOScallerMapperManager);
        }




      }
    }





  }

  callibrateSendTokenId(resultString){
    print('LOGS FROM SEND PROVIDER TICKET : $resultString');
    deviceAvailable = true;
    notifyListeners();
  }

  setTime(String resultString,CommandProvider commandProvider, Function moveTOScallerMapperManager  ,  ) async {


    ifStringContainsPasswordString_MoveToPinScreen(resultString);


    print('setTime');
    print(resultString);
    resultString = resultString.trim();

    if (resultString.startsWith('#DEV_') && resultString.endsWith('^') ) {
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
        .setTime(resultString.replaceAll("#WUT_", "").replaceAll("^", ""), )) {
      print(
          'time is up moving to scaller mapper scaller is ${commandProvider.scllerMapper.isScallerSet} ');

      //move to next screen

      print('commandProvider.scllerMapper.isScallerSet');
      print(commandProvider.scllerMapper.isScallerSet);
      print('commandProvider.scllerMapper.disableTimer');
      print(commandProvider.scllerMapper.disableTimer);

      if (commandProvider.scllerMapper.isScallerSet &&
          commandProvider.scllerMapper.disableTimer) {


      await  moveTOScallerMapperManager();


      }

      if(!commandProvider.scllerMapper.isScallerSet){
        await sendData(GetDviceType);
        await sendData(endTimerMSG);

      }


    }
  }




}

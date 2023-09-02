

import 'dart:convert';

import 'package:bluespark/util/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/BoxModel.dart';
import 'SendProvider.dart';

class BoxStorage{
  static String boxkey = 'boxes';


  static Future<bool> checkIfboxDataIsAvailable(boxId) async {
    final prefs = await SharedPreferences.getInstance();

    List<String>? maybeString= prefs.getStringList('boxes');

    if(maybeString==null){
      return false;
    };
    for (var i in maybeString ){
      Map<String, dynamic> box_model = jsonDecode(i);
      Box_Model bx_model =Box_Model.fromJson(box_model);
      print('mac address');
      print(i);
      print(boxId);

      if(bx_model.mac_address==boxId){
          return true;



      }
    }
    return false;


  }

  static Future<Box_Model?> getBox(boxId)async{
    List<Box_Model> boxList =  await getBoxes();

    for (var i in boxList ){
      if(i.mac_address==boxId){
        return i;
      }
    }
    return null;


  }

  static  Future<String> getPasswordPin(boxId)async{
    Box_Model? bm =  await getBox(boxId);


    return bm!.password_pin;

  }

  static storeBox(bool isConnected) async {

    if( await checkIfboxDataIsAvailable(macAddressSent)){ return ;};

    Box_Model box = Box_Model(nick_name: nickName, mac_address: macAddressSent, password_pin: lastPasswordSent, isConnected: true);

    /////////////////////================
    print(box.toString());
    /////////////////////================

    nickName  = '';
    macAddressSent  = '';
    lastPasswordSent  = '';

    final prefs = await SharedPreferences.getInstance();

    String boxString = jsonEncode(box.toJson());

    List<Box_Model> maybeBoxStringList  = await getBoxes();

    List<String> listOfString = [];

    for (var i in maybeBoxStringList){
      if(i.isConnected){
        i.isConnected = false;
      }
      listOfString.add(jsonEncode(i));
    }

    if(maybeBoxStringList==null){
      print('null');
      prefs.setStringList(boxkey, [boxString]);
    }else{
      print('NOT null');



      prefs.setStringList(boxkey,  listOfString+[boxString]);
    }

  }

  static disconnect_allBoxes() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> listOfString = [];



    List<Box_Model> maybeBoxStringList  = await  getBoxes();
    for (var i in maybeBoxStringList){
      if(i.isConnected){
        i.isConnected = false;
      }
      listOfString.add(jsonEncode(i));

    }

    prefs.setStringList(boxkey,  listOfString);



  }

  static Future<List<Box_Model>> getBoxes()async{

    final prefs = await SharedPreferences.getInstance();

    List<String>? maybeBoxStringList  = prefs.getStringList(boxkey );

    if(maybeBoxStringList==null){
      return [];
    }else{
      List<Box_Model> boxList = [];
      for( var i in maybeBoxStringList ){
        boxList.add(Box_Model.fromJson(jsonDecode(i)));

      }


      return boxList;
    }
  }

  static deleteAllEntries () async{
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(boxkey);
  }

  static connectedToBox(boxId) async {

    final prefs = await SharedPreferences.getInstance();


    List<Box_Model> maybeBoxStringList  = await getBoxes();

    List<String> listOfString = [];

    for (var i in maybeBoxStringList){
      if(boxId==i.mac_address){
        i.isConnected = true;
      }
      listOfString.add(jsonEncode(i));
    }

    prefs.setStringList(boxkey,listOfString);

  }

  static updateBoxWithId(String boxId,String nickName) async{

    final prefs = await SharedPreferences.getInstance();

    List<String>? maybeBoxStringList  = prefs.getStringList(boxkey );

    List<String> boxList = [];

    if(maybeBoxStringList!=null){
      for( var i in maybeBoxStringList ){
        Box_Model box = Box_Model.fromJson(jsonDecode(i));


        if(box.mac_address== boxId){
          box.nick_name = nickName;
        }
        boxList.add(jsonEncode(box));

      }
      prefs.setStringList(boxkey,boxList);

    }

    return boxList;



  }

  static deleteBoxWithId(String boxId) async{

    final prefs = await SharedPreferences.getInstance();

    List<String>? maybeBoxStringList  = prefs.getStringList(boxkey );

    List<String> boxList = [];

    if(maybeBoxStringList!=null){
      for( var i in maybeBoxStringList ){
        Box_Model box = Box_Model.fromJson(jsonDecode(i));


        if(box.mac_address!= boxId){
          boxList.add(jsonEncode(box));
        }


      }
      prefs.setStringList(boxkey,boxList);

    }

    return boxList;



  }









}
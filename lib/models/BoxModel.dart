

import 'dart:core';
import 'dart:convert';
import 'dart:core';

class Box_Model{

  Box_Model({required this.nick_name, required this.mac_address, required this.password_pin,required this.isConnected});

  late String password_pin;
  late String nick_name;
  late String mac_address;
  late bool isConnected;


  factory Box_Model.fromJson( Map<String, dynamic> parsedJson) {

  return new Box_Model(
      nick_name: parsedJson['nick_name'], mac_address: parsedJson['mac_address'],
      password_pin: parsedJson['password_pin'],isConnected: parsedJson['isConnected']);
  }

  Map<String, dynamic> toJson() {
  return {
  "nick_name": this.nick_name,
  "mac_address": this.mac_address ,
  "password_pin": this.password_pin,
    "isConnected":this.isConnected
  };
  }
  @override
  String toString() {
    // TODO: implement toString
    return 'mac_address: '+mac_address +'nick_name:' +nick_name +"isConnected :" +isConnected.toString();
  }

}
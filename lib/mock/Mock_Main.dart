import 'dart:math';

import 'package:flutter/material.dart';

import '../models/BoxModel.dart';
import '../providers/SendProvider.dart';
import '../providers/box_storage.dart';

class Mock_Main extends StatefulWidget {
  const Mock_Main({Key? key}) : super(key: key);

  @override
  State<Mock_Main> createState() => _Mock_MainState();
}

class _Mock_MainState extends State<Mock_Main> {
  @override
  Widget build(BuildContext context) {
    getTile(name, callback) {
      return GestureDetector(
        onTap: () {
          print('object');
          callback();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Colors.red,
            child: Text(
              name,
              style: TextStyle(fontSize: 40, color: Colors.black26),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              height: 100,

            ),



            getTile('save date', () {
              print('save date');
              lastPasswordSent = '1234';
              macAddressSent = '0x0000000000006';
              nickName = 'HELLCAT';

              BoxStorage.storeBox(false);
            }),
            getTile('get date', () async {
              List<Box_Model> all_boxes = await BoxStorage.getBoxes();
              print('get date');
              print(all_boxes);
            }),
            getTile('check if contain date', () async {
              print('check if contain date');

              bool isAvailable =
                  await BoxStorage.checkIfboxDataIsAvailable('0x000000000000');
              print(isAvailable);
            }),
            getTile('check if NOT contain date', () async {
              print('check if NOT contain date');
                  await BoxStorage.deleteBoxWithId('1111');
             
            }),
            getTile('delete  date', () {
              BoxStorage.deleteBoxWithId('0x0000000000006');
            }),
            getTile('connect  box', () {
              BoxStorage.connectedToBox('04:A3:16:A3:E8:DA');
            }),
            getTile('update box', () {
              BoxStorage. updateBoxWithId('04:A3:16:A3:E8:DA','FORD');
            }),
          ],
        ),
      ),
    );
  }
}

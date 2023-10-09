

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_haptic/haptic.dart';

class TestingScreen extends StatefulWidget {
  const TestingScreen({Key? key}) : super(key: key);

  @override
  _TestingScreenState createState() => _TestingScreenState();
}

class _TestingScreenState extends State<TestingScreen> {


  Widget getTile(int num , Function callBack ){

    return GestureDetector(
      onTap: (){
        callBack();
      },
      child: Container(
        color: Colors.grey,

        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text("Button $num"),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          getTile(1,(){
            Haptic.onSelection();


          }),
          getTile(2,(){
            Feedback.forTap(context);


          }),
          getTile(3,(){

            HapticFeedback.vibrate();

          }),
          getTile(4,(){
            Clipboard.setData(ClipboardData(text: 'TEXT'));


          }),
          getTile(5,(){
            HapticFeedback.heavyImpact();
          }),
          getTile(6,(){
            HapticFeedback.vibrate();
          }),
     getTile(7,(){
            HapticFeedback.selectionClick();
          }),
     getTile(8,(){
            HapticFeedback.mediumImpact();
          }),
     getTile(9,(){
            HapticFeedback.lightImpact();
          }),


        ],
      ),
    );
  }
}

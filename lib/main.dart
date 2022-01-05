
import 'package:blutooth/MainScreen.dart';
import 'package:blutooth/Welcome1.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',

      home: Welcome1(),
    );
  }
}


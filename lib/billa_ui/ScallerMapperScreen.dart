import 'package:bluespark/billa_ui/ui_strings.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:math';
import 'package:horizontal_picker/horizontal_picker.dart';

class ScallerMapperScreen extends StatefulWidget {
  const ScallerMapperScreen({Key? key}) : super(key: key);

  @override
  _Slider1State createState() => _Slider1State();
}

class _Slider1State extends State<ScallerMapperScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List scallerList = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];
  List mapperList = [
    "A",
    "B",
    "C",
    "D",
    "E",
  ];

  toggleDrawer() async {
    if (_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState?.openEndDrawer();
    } else {
      _scaffoldKey.currentState?.openDrawer();
    }
  }

  var Mapperselected = 2;
  var Scallerselected = 2;
  FixedExtentScrollController MapperfixedExtentScrollController =
      new FixedExtentScrollController(initialItem: 2);

  FixedExtentScrollController ScallerfixedExtentScrollController =
      new FixedExtentScrollController(initialItem: 2);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: blackColor,
        endDrawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: blueColor.withOpacity(0.1).withOpacity(
                0.9), //or any other color you want. e.g Colors.blue.withOpacity(0.5)
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.horizontal(left: Radius.circular(20.0)),
            child: Drawer(
              elevation: 16.0,
              child: Container(
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              toggleDrawer();
                            },
                            child: Icon(
                              Icons.table_rows_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 100,
                    ),
                    ListTile(
                      title: Container(
                        alignment: Alignment.centerRight,
                        child: new Text(
                          "Step Guide",
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Divider(
                      height: 0.1,
                    ),
                    ListTile(
                      title: Container(
                        alignment: Alignment.centerRight,
                        child: new Text(
                          "User Guide",
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Container(
                        alignment: Alignment.centerRight,
                        child: new Text(
                          "Using the Bypass Plug",
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Container(
                        alignment: Alignment.centerRight,
                        child: new Text(
                          "Safety Information",
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Container(
                        alignment: Alignment.centerRight,
                        child: new Text(
                          "App Information",
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Container(
                        alignment: Alignment.centerRight,
                        child: new Text(
                          "Contact BLUESPARK",
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),

                        // style: TextStyle(color: Colors.white),)
                      ),
                    ),
                    Container(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        toggleDrawer();
                      },
                      child: Container(
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 30,
                          child: Icon(
                            Icons.close,
                            size: 55,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                    Text(
                      'Close',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // appBar:AppBar(backgroundColor: blackColor, elevation: 0.0,),

        body: Container(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: blueColor,
                            borderRadius:
                                new BorderRadius.all(Radius.circular(50.0))),
                        child: Row(
                          children: [
                            Container(
                              width: 15,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                  left: 50, right: 20, top: 5, bottom: 5),
                              child: Text(
                                'Change Confirmed',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                          child: Row(
                        children: [
                          Stack(
                            children: [
                              Container(
                                color: blackColor,
                                height: 60,
                                width: 50,
                              ),
                              Icon(
                                Icons.check_circle,
                                color: greenColor,
                                size: 60,
                              ),
                            ],
                          ),
                        ],
                      ))
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      _scaffoldKey.currentState!.openEndDrawer();
                    },
                    child: const Icon(
                      Icons.table_rows_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30, left: 30, top: 10),
              child: Container(
                decoration: BoxDecoration(
                    color: blueColor,
                    borderRadius: new BorderRadius.all(Radius.circular(50.0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      "Swipe to change",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                new BorderRadius.all(Radius.circular(10.0))),
                        child: Image.asset(
                          'images/img.png',
                          height: 40,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  mapperWidget(),
                  ScallerWidget(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: greenColor,
                          borderRadius:
                              new BorderRadius.all(Radius.circular(10.0))),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10, left: 10),
                        child: Text(
                          "Done",
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 30,
                              color: blackColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        )),
      ),
    );
  }

  mapperWidget() {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Map Select",
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 10,
          ),
          Container(
            width: 55,
            height: 55,
            decoration: new BoxDecoration(
                color: greenColor,
                borderRadius: new BorderRadius.all(Radius.circular(10.0))),
            child: Center(
              child: Text(
                mapperList[Mapperselected].toString(),
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 45,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            height: 100,
            width: 500,
            child: RotatedBox(
                quarterTurns: 3,
                child: ListWheelScrollView(
                  onSelectedItemChanged: (x) {
                    setState(() {
                      Mapperselected = x;
                    });
                  },
                  controller: MapperfixedExtentScrollController,
                  children: mapperList.map((mp) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 5,
                          // width:(selected-(mapperList.indexOf(month))).abs()==1? 110:  (selected-(mapperList.indexOf(month))).abs()==0? 120:90,

                          decoration: BoxDecoration(
                              color: (Mapperselected - (mapperList.indexOf(mp)))
                                          .abs() ==
                                      1
                                  ? lightBlueColor
                                  : (Mapperselected - (mapperList.indexOf(mp)))
                                              .abs() ==
                                          0
                                      ? blueColor
                                      : Colors.white,
                              borderRadius:
                                  new BorderRadius.all(Radius.circular(10.0))),
                          child: RotatedBox(
                            quarterTurns: -3,
                            child: Center(
                              child: Text(
                                mp,
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 30,
                                    color: (Mapperselected -
                                                    (mapperList.indexOf(mp)))
                                                .abs() ==
                                            1
                                        ? Colors.black
                                        : Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )),
                    );
                  }).toList(),
                  itemExtent: 50,
                )),
          ),
        ],
      ),
    );
  }

  ScallerWidget() {
    return Container(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Scaler Select",
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 10,
          ),
          Container(
            width: 55,
            height: 55,
            decoration: new BoxDecoration(
                color: greenColor,
                borderRadius: new BorderRadius.all(Radius.circular(10.0))),
            child: Center(
              child: Text(
                scallerList[Scallerselected].toString(),
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 45,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            height: 100,
            width: 500,
            child: RotatedBox(
                quarterTurns: 3,
                child: ListWheelScrollView(
    itemExtent: 50,



    onSelectedItemChanged: (x) {
                    setState(() {
                      Scallerselected = x;
                    });
                  },
                  controller: ScallerfixedExtentScrollController,
                  children: scallerList.map((mp) {
                    print(mp);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 5,
                          // width:(selected-(scallerList.indexOf(month))).abs()==1? 110:  (selected-(scallerList.indexOf(month))).abs()==0? 120:90,

                          decoration: BoxDecoration(
                              color:
                                  (Scallerselected - (scallerList.indexOf(mp))).abs() == 1
                                      ? lightBlueColor
                                      : (Scallerselected - (scallerList.indexOf(mp))).abs() == 0
                                          ? blueColor
                                          : Colors.white,
                              borderRadius:
                                  new BorderRadius.all(Radius.circular(10.0))),
                          child: RotatedBox(
                            quarterTurns: -3,
                            child: Center(
                              child: Text(
                                mp,
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 30,
                                    color: (Scallerselected -
                                                    (scallerList.indexOf(mp)))
                                                .abs() ==
                                            1
                                        ? Colors.black
                                        : Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )),
                    );
                  }).toList(),
                  // itemExtent: 50,
                )),
          ),
        ],
      ),
    );
  }
}


import 'package:bluespark/billa_ui/ui_strings.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:math';

class Slider1 extends StatefulWidget {
  const Slider1({Key? key}) : super(key: key);

  @override
  _Slider1State createState() => _Slider1State();
}

class _Slider1State extends State<Slider1> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List map = [ '__','u',"A","B","C","D","E",];

  toggleDrawer() async {
    if (_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState?.openEndDrawer();
    } else {
      _scaffoldKey.currentState?.openDrawer();
    }
  }
  var selected =5;
  FixedExtentScrollController fixedExtentScrollController =
  new FixedExtentScrollController(initialItem: 5);

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

                            decoration: new BoxDecoration(
                                color:blueColor,
                                borderRadius: new BorderRadius.all( Radius.circular(50.0))
                            ),
                            child: Row(
                              children: [
                                Container(width: 15,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 50,right: 20,top:5,bottom: 5),
                                  child: Text('Change Confirmed',

                                    style: TextStyle(fontFamily: 'Montserrat',fontSize: 22,color: Colors.white,fontWeight:FontWeight.bold),),
                                ),
                              ],
                            ),
                          ),
                          Positioned(

                              child: Row(
                                children: [

                                  Stack(
                                    children: [
                                      Container(color: blackColor,
                                        height: 60,width: 50,),
                                      Icon(Icons.check_circle,color:greenColor,size: 60,),
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
                        child: Icon(
                          Icons.table_rows_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(right: 30,left:30,top:10),

                  child: Container(

                    decoration: new BoxDecoration(
                        color:blueColor,
                        borderRadius: new BorderRadius.all( Radius.circular(50.0))
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,

                      children: [
                        Text("Swipe to change",

                          style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,color: Colors.white,fontWeight:FontWeight.bold),),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: new BoxDecoration(
                                color:Colors.white,
                                borderRadius: new BorderRadius.all( Radius.circular(10.0))

                            ),
                            child:Image.asset('images/img.png',height: 40,),
                          ),
                        )
                      ],
                    ),
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Map Select",

                    style: TextStyle(fontFamily: 'Montserrat',fontSize: 30,color: Colors.white,fontWeight:FontWeight.bold),),
                ),

                Text(selected.toString(),

                  style: TextStyle(fontFamily: 'Montserrat',fontSize: 30,color: Colors.white,fontWeight:FontWeight.bold),),


        Expanded(
          child: RotatedBox(
              quarterTurns: -1,

              child: ListWheelScrollView(
                onSelectedItemChanged: (x) {
                  setState(() {
                    selected = x;
                  });
                },
                controller: fixedExtentScrollController,
                children:  map.map((month) {
                  return Container(
                    height: 5,
                    width:(selected-(map.indexOf(month))).abs()==1? 110:  (selected-(map.indexOf(month))).abs()==0? 120:90,

                    decoration: new BoxDecoration(
                        color:map.indexOf(month)<=1?Colors.transparent:(selected-(map.indexOf(month))).abs()==1?lightBlueColor:  (selected-(map.indexOf(month))).abs()==0?  blueColor:Colors.white,
                        borderRadius: new BorderRadius.all( Radius.circular(10.0))
                    ),

                  );
                }).toList(),
                itemExtent: 60,
              )),
        ),




                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(

                    decoration: new BoxDecoration(
                        color:greenColor,
                        borderRadius: new BorderRadius.all( Radius.circular(10.0))
                    ),
                    child:    Padding(
                      padding: const EdgeInsets.only(right: 10,left:10),
                      child: Text("Done",

                        style: TextStyle(fontFamily: 'Montserrat',fontSize: 30,color: blackColor,fontWeight:FontWeight.bold),),
                    ),
                  ),
                )

              ],
            )),
      ),
    );
  }
}

class ListWheelScrollViewX extends StatelessWidget {
  final Widget Function(BuildContext, int) builder;
  final Axis scrollDirection;
  final FixedExtentScrollController controller;
  final double itemExtent;
  final double diameterRatio;
  final void Function(int) onSelectedItemChanged;
  const ListWheelScrollViewX({

    required this.builder,
    required this.itemExtent,
    required this.controller,
    required this.onSelectedItemChanged,
    this.scrollDirection = Axis.vertical,
    this.diameterRatio = 100000,
  }) ;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: scrollDirection == Axis.horizontal ? 3 : 0,
      child: ListWheelScrollView.useDelegate(
        onSelectedItemChanged: onSelectedItemChanged,
        controller: controller,
        itemExtent: itemExtent,
        diameterRatio: diameterRatio,
        physics: FixedExtentScrollPhysics(),
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            return RotatedBox(
              quarterTurns: scrollDirection == Axis.horizontal ? 1 : 0,
              child: builder(context, index),
            );
          },
        ),
      ),
    );
  }
}
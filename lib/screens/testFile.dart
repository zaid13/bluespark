//
//
// import 'dart:async';
// import 'dart:io';
// import 'package:bluespark/providers/CommandProvider.dart';
// import 'package:flutter/gestures.dart';
// import 'package:rounded_loading_button/rounded_loading_button.dart';
// import 'package:url_launcher/url_launcher.dart';
//
//
// import 'package:bluespark/billa_ui/ui_strings.dart';
// import 'package:bluespark/src/ble/ble_device_connector.dart';
// import 'package:bluespark/src/ble/ble_device_interactor.dart';
// import 'package:bluespark/src/ble/ble_scanner.dart';
// import 'package:bluespark/src/ui/device_detail/device_interaction_tab.dart';
// import 'package:bluespark/src/ui/device_list.dart';
// import 'package:bluespark/util/config.dart';
// import 'package:bluespark/util/functions.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
// import 'package:provider/provider.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';
// import 'dart:math';
// import 'package:horizontal_picker/horizontal_picker.dart';
// import 'package:awesome_dialog/awesome_dialog.dart';
//
//
//
// class ScallerMapperManagerTEST extends StatelessWidget {
//   const ScallerMapperManagerTEST() ;
//
//
//
//
//
//   @override
//   Widget build(BuildContext context) => ScallerMapperScreen();
//
// // @override
// // Widget build(BuildContext context) => Consumer<BleDeviceInteractor>(
// //     builder: (context, interactor, _) =>  Consumer3<BleDeviceConnector, ConnectionStateUpdate, BleDeviceInteractor>(
// // builder: (_, deviceConnector.dart, connectionStateUpdate, serviceDiscoverer,
// // __) => Welcome1(
// //       characteristic: characteristic,
// //       readCharacteristic: interactor.readCharacteristic,
// //       writeWithResponse: interactor.writeCharacterisiticWithResponse,
// //       writeWithoutResponse:
// //       interactor.writeCharacterisiticWithoutResponse,
// //       subscribeToCharacteristic: interactor.subScribeToCharacteristic,
// //
// //   viewModel:    DeviceInteractionViewModel(
// //       deviceId:  bleScanner.btfound.id,
// //       connectionStatus: connectionStateUpdate.connectionState,
// //       deviceConnector.dart: deviceConnector.dart,
// //       discoverServices: () =>
// //           serviceDiscoverer.discoverServices( bleScanner.btfound.id)),
// //     )));
// }
//
// class ScallerMapperScreen extends StatefulWidget {
//    ScallerMapperScreen();
//
//
//
//
//   @override
//   _Slider1State createState() => _Slider1State();
// }
//
// class _Slider1State extends State<ScallerMapperScreen> {
//   GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   List scallerList = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];
//   List mapperList = [
//     "A",
//     "B",
//     "C",
//     "D",
//     "E",
//   ];
//   late StreamSubscription<List<int>>? subscribeStream;
//   // String maperResponse = "1";
//   // String scallerResponse = "31";
//
//   // String readOutput="";
//   // String writeOutput="";
//   // String subscribeOutput="";
//   // bool showSuccessMessage = false;
//   final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
//
//   // String subscitioResonse =Z"NO RESPONSE";
//
//   // bool errorMessageIsOpen = false;
//
//
//
//
//
//   @override
//   void dispose() {
//     subscribeStream?.cancel();
//     super.dispose();
//   }
//
//   toggleDrawer() async {
//     if (_scaffoldKey.currentState!.isDrawerOpen) {
//       _scaffoldKey.currentState?.openEndDrawer();
//     } else {
//       _scaffoldKey.currentState?.openDrawer();
//     }
//   }
//
//   // var Mapperselected = 2;
//   // var Scallerselected = 2;
//   FixedExtentScrollController MapperfixedExtentScrollController =
//   new FixedExtentScrollController(initialItem: 2);
//
//   FixedExtentScrollController ScallerfixedExtentScrollController =
//   new FixedExtentScrollController(initialItem: 2);
//
//
//
//
//   readtime() async {
//     // print('2');
//     // subscribeCharacteristic();
//     //
//     // // while(int.parse(maperResponse)>0){
//     // await coommunicatewithDevice('201');
//     // // sleep(Duration(seconds:1));
//     // // print("readtime whilw");
//     //
//     // // }
//   }
//
//   //
//   // Future<void> subscribeCharacteristic() async {
//   //   subscribeStream =
//   //       widget.subscribeToCharacteristic(widget.characteristic).listen((event) {
//   //         setState(() {
//   //           subscribeOutput = event.toString();
//   //         });
//   //       });
//   //   setState(() {
//   //     subscribeOutput = 'Notification set';
//   //   });
//   // }
//
//   // Future<void> readCharacteristic() async {
//   //
//   //   final result = await widget.readCharacteristic(widget.characteristic);
//   //   print("read ${result}");
//   //
//   //
//   //   setState(() {
//   //     readOutput  = result.toString();
//   //     String resultString = String.fromCharCodes(result);
//   //     print(resultString);
//   //
//   //     if(resultString.startsWith("#MAP_")    ){
//   //
//   //         maperResponse = resultString.replaceAll("#MAP_", "").replaceAll("#", "");
//   //         setState(() {
//   //           // showSuccessMessage = true;
//   //         });
//   //
//   //     }
//   //     else   if(resultString.startsWith("#SCA_")    )
//   //
//   //     {
//   //       scallerResponse = resultString.replaceAll("#SCA_", "").replaceAll("#", "").split("\n")[0];
//   //
//   //       // setState(() {
//   //       //   showSuccessMessage = true;
//   //       // });
//   //       // Future.delayed(Duration(seconds: 2), (){
//   //       //   setState(() {
//   //       //     showSuccessMessage = false;
//   //       //   });
//   //
//   //       // });
//   //     }
//   //     else{
//   //       // AwesomeDialog(
//   //       //   context: context,
//   //       //   dialogType: DialogType.ERROR,
//   //       //   animType: AnimType.BOTTOMSLIDE,
//   //       //   title: 'Load Too High',
//   //       //   desc: resultString+" Reduce Load to change  "+resultString.split(" ").last.replaceAll("^", "")??"",
//   //       //   btnCancelOnPress: () {},
//   //       //   btnOkOnPress: () {},
//   //       // )..show();
//   //     }
//   //
//   //
//   //
//   //   });
//   // }
//
//
//
//   //  subscribeCharacteristicStream()  {
//   //   // subscribeStream =
//   //      widget.subscribeToCharacteristic(widget.characteristic).listen((result) {
//   //        // setState(() {
//   //          subscitioResonse = result.toString();
//   //        // });
//   //
//   //
//   //        print("read ${result}");
//   //
//   //
//   //
//   //        // setState(() {
//   //          readOutput  = result.toString();
//   //          String resultString = String.fromCharCodes(result);
//   //          print(resultString);
//   //
//   //          if(resultString.startsWith("#MAP_")    ){
//   //
//   //            maperResponse = resultString.replaceAll("#MAP_", "").replaceAll("#", "");
//   //
//   //          }
//   //          else   if(resultString.startsWith("#SCA_")    )
//   //
//   //          {
//   //            scallerResponse = resultString.replaceAll("#SCA_", "").replaceAll("#", "").split("\n")[0];
//   //
//   //            // setState(() {
//   //            //   showSuccessMessage = true;
//   //            // });
//   //            // Future.delayed(Duration(seconds: 2), (){
//   //            //   setState(() {
//   //            //     showSuccessMessage = false;
//   //            //   });
//   //
//   //            // });
//   //          } else   if(resultString.startsWith("#WUT_")){}
//   //          else if (resultString.startsWith("^") && !errorMessageIsOpen ) {
//   //
//   //            // setState(() {
//   //              errorMessageIsOpen = true;
//   //            // });
//   //            print('resultString');
//   //            print(resultString);
//   //            AwesomeDialog(
//   //              context: context,
//   //              dialogType: DialogType.ERROR,
//   //              animType: AnimType.BOTTOMSLIDE,
//   //              title: 'Load Too High',
//   //              desc: resultString,
//   //              btnCancelOnPress: () {
//   //                setState(() {
//   //                  errorMessageIsOpen = false;
//   //                });
//   //              },
//   //              btnOkOnPress: () {
//   //                setState(() {
//   //                  errorMessageIsOpen = false;
//   //                });
//   //
//   //              },
//   //            ).show();
//   //          }
//   //
//   //
//   //        // });
//   //
//   //      });
//   //   // // setState(() {
//   //   subscitioResonse = 'Notification set';
//   //   // });
//   // }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//
//
//     return SafeArea(
//       child: Scaffold(
//         key: _scaffoldKey,
//         backgroundColor: blackColor,
//         endDrawer: Theme(
//           data: Theme.of(context).copyWith(
//             canvasColor: blueColor.withOpacity(0.1).withOpacity(
//                 0.9), //or any other color you want. e.g Colors.blue.withOpacity(0.5)
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.horizontal(left: Radius.circular(20.0)),
//             child: Drawer(
//               elevation: 16.0,
//               child: Container(
//                 color: Colors.transparent,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
//                     Container(
//                       height: 50,
//                     ),
//
//
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             toggleDrawer();
//                           },
//                           child: Icon(
//                             Icons.table_rows_rounded,
//                             color: Colors.white,
//                             size: 40,
//                           ),
//                         ),
//                         Container(width: 10,)
//                       ],
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Image.asset('images/main_screen/logo.png',),
//                       ),
//                     ),
//                     Container(
//                       height: 100,
//                     ),
//                     ListTile(
//                       onTap: (){
//
//
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) => _buildAboutDialog(context,"Setup Guide",_buildSetupText()),
//                         );
//                       },
//                       title: Container(
//                         alignment: Alignment.centerRight,
//                         child: new Text(
//                           "Setup Guide",
//                           style: TextStyle(
//                               fontFamily: 'Montserrat',
//                               fontSize: 20,
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                     Divider(
//                       height: 0.1,
//                     ),
//                     ListTile(
//                       onTap: (){
//
//
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) => _buildAboutDialog(context,"User Guide",_buildUserGuideText()),
//                         );
//                       },
//                       title: Container(
//                         alignment: Alignment.centerRight,
//                         child: new Text(
//                           "User Guide",
//                           style: TextStyle(
//                               fontFamily: 'Montserrat',
//                               fontSize: 20,
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                     ListTile(
//                       onTap: (){
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) => _buildAboutDialog(context,"Using the Bypass Plug",_buildUsingtheBypassPlugText()),
//                         );
//                       },
//                       title: Container(
//                         alignment: Alignment.centerRight,
//                         child: new Text(
//                           "Using the Bypass Plug",
//                           style: TextStyle(
//                               fontFamily: 'Montserrat',
//                               fontSize: 20,
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                     ListTile(
//                       onTap: (){
//
//
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) => _buildAboutDialog(context,"Safety Information",_buildSafetyInformationText()),
//                         );
//                       },
//                       title: Container(
//                         alignment: Alignment.centerRight,
//                         child: new Text(
//                           "Safety Information",
//                           style: TextStyle(
//                               fontFamily: 'Montserrat',
//                               fontSize: 20,
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                     ListTile(
//                       onTap: (){
//
//
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) => _buildAboutDialog(context,"App Information",_buildAppInformationText()),
//                         );
//
//                       },
//                       title: Container(
//                         alignment: Alignment.centerRight,
//                         child: new Text(
//                           "App Information",
//                           style: TextStyle(
//                               fontFamily: 'Montserrat',
//                               fontSize: 18,
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                     ListTile(
//                       onTap: (){
//
//
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) => _buildAboutDialog(context,"Contact BLUESPARK",_buildContactBluesparkText()),
//                         );
//                       },
//
//                       title: Container(
//                         alignment: Alignment.centerRight,
//                         child: new Text(
//                           "Contact BLUESPARK",
//                           style: TextStyle(
//                               fontFamily: 'Montserrat',
//                               fontSize: 18,
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold),
//                         ),
//
//                         // style: TextStyle(color: Colors.white),)
//                       ),
//                     ),
//                     Container(
//                       height: 30,
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         toggleDrawer();
//                       },
//                       child: Container(
//                         child: CircleAvatar(
//                           backgroundColor: Colors.white,
//                           radius: 30,
//                           child: Icon(
//                             Icons.close,
//                             size: 55,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       height: 10,
//                     ),
//                     Text(
//                       'Close',
//                       style: TextStyle(
//                           fontFamily: 'Montserrat',
//                           fontSize: 25,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         appBar:AppBar(backgroundColor: blackColor, elevation: 0.0,actions: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 GestureDetector(
//                     onTap: (){
//                       print('swsw');
//                       _scaffoldKey.     currentState!.openEndDrawer();
//                     },
//                     child: Icon(Icons.table_rows_rounded,color: Colors.white,size: 35,)),
//               ],
//             ),
//           ),
//         ],),
//         body: Container(
//             child: ListView(
//               children: [
//
//
//
//
//                 Center(child: Image.asset('images/main_screen/logo.png',width: MediaQuery.of(context).size.width*0.7,)),
//
//                 // Center(
//                 //   child: Text(
//                 //     "Status: ${widget.viewModel.connectionStatus}",
//                 //     style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,color: DeviceConnectionState.connected==widget.viewModel.connectionStatus?Colors.green:Colors.red,fontWeight:FontWeight.bold),),
//                 // ),
//                 // showSuccessMessage todo
//
//                 context.watch<CommandProvider>().scllerMapper.UpdateSucessfully?    Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       Stack(
//                         alignment: Alignment.centerLeft,
//                         children: [
//                           Container(
//                             decoration: BoxDecoration(
//                                 color: blueColor,
//                                 borderRadius:
//                                 new BorderRadius.all(Radius.circular(50.0))),
//                             child: Row(
//                               children: [
//                                 Container(
//                                   width: 15,
//                                 ),
//                                 const Padding(
//                                   padding: EdgeInsets.only(
//                                       left: 50, right: 20, top: 5, bottom: 5),
//                                   child: Text(
//                                     'Change Confirmed',
//                                     style: TextStyle(
//                                         fontFamily: 'Montserrat',
//                                         fontSize: 22,
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Positioned(
//                               child: Row(
//                                 children: [
//                                   Stack(
//                                     children: [
//                                       Container(
//                                         color: blackColor,
//                                         height: 60,
//                                         width: 50,
//                                       ),
//                                       Icon(
//                                         Icons.check_circle,
//                                         color: greenColor,
//                                         size: 60,
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ))
//                         ],
//                       ),
//
//                     ],
//                   ),
//                 ):Container(),
//
//
//
//                 context.watch<CommandProvider>().swipeToChangeIsEnable==0?Container():  Padding(
//                   padding: const EdgeInsets.only(right: 30, left: 30, top: 10),
//                   child: Container(
//                     alignment:Alignment.center,
//                     width: MediaQuery.of(context).size.width*0.9,
//                     decoration: BoxDecoration(
//                         color: blueColor,
//                         borderRadius: new BorderRadius.all(Radius.circular(50.0))),
//                     child: Row(
//                       mainAxisAlignment:      context.watch<CommandProvider>().swipeToChangeIsEnable==1?  MainAxisAlignment.spaceAround: MainAxisAlignment.center,
//                       children: [
//                         context.watch<CommandProvider>().swipeToChangeIsEnable==1?    Text(
//                           "Swipe to change",
//                           style: TextStyle(
//                               fontFamily: 'Montserrat',
//                               fontSize: 20,
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold),
//                         ):Text(
//                           'Click "Done" to update settings',
//                           style: TextStyle(
//                               fontFamily: 'Montserrat',
//                               fontSize: 18,
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         context.watch<CommandProvider>().swipeToChangeIsEnable==1?     Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Container(
//                             decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius:
//                                 new BorderRadius.all(Radius.circular(10.0))),
//                             child: Image.asset(
//                               'images/img.png',
//                               height: 40,
//                             ),
//                           ),
//                         ):Container( height: 40,)
//                       ],
//                     ),
//                   ),
//                 ),
//
//
//
//
//
//               ],
//             )),
//
//       ),
//     );
//   }
//
//   mapperWidget() {
//     return Container(
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               "Map Select: "+   mapperList[int.parse(context.watch<CommandProvider>().scllerMapper.RESPONSE_mapperSelected)-1 ] ,
//               style: TextStyle(
//                   fontFamily: 'Montserrat',
//                   fontSize: 30,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold),
//             ),
//           ),
//           Container(
//             height: 10,
//           ),
//           Container(
//             width: 55,
//             height: 55,
//             decoration: new BoxDecoration(
//                 color: greenColor,
//                 borderRadius: new BorderRadius.all(Radius.circular(10.0))),
//             child: Center(
//               child: Text(
//                 context.watch<CommandProvider>().scllerMapper.mapperSelected,
//                 style: TextStyle(
//                     fontFamily: 'Montserrat',
//                     fontSize: 45,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//           Container(
//             height: 100,
//             width: 500,
//             child: RotatedBox(
//                 quarterTurns: 3,
//                 child: ListWheelScrollView(
//                   onSelectedItemChanged: (x) {
//                     context.read<CommandProvider>().setMapper(mapperList[x]);
//
//                   },
//                   controller: MapperfixedExtentScrollController,
//                   children: mapperList.map((mp) {
//                     return Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Container(
//                           height: 5,
//                           // width:(selected-(mapperList.indexOf(month))).abs()==1? 110:  (selected-(mapperList.indexOf(month))).abs()==0? 120:90,
//
//                           decoration: BoxDecoration(
//                               color: (mapsArray.keys.toList().indexOf( context.read<CommandProvider>().scllerMapper.mapperSelected) - (mapperList.indexOf(mp)))
//                                   .abs() ==
//                                   1
//                                   ? lightBlueColor
//                                   : (mapsArray.keys.toList().indexOf( context.read<CommandProvider>().scllerMapper.mapperSelected) - (mapperList.indexOf(mp)))
//                                   .abs() ==
//                                   0
//                                   ? blueColor
//                                   :Colors.white,
//                               borderRadius:
//                               new BorderRadius.all(Radius.circular(10.0))),
//                           child: RotatedBox(
//                             quarterTurns: -3,
//                             child: Center(
//                               child: Text(
//                                 mp,
//                                 style: TextStyle(
//                                     fontFamily: 'Montserrat',
//                                     fontSize: 30,
//                                     color: (mapsArray.keys.toList().indexOf( context.read<CommandProvider>().scllerMapper.mapperSelected) - (mapperList.indexOf(mp)))
//                                         .abs() ==
//                                         1
//                                         ? Colors.black
//                                         : (mapsArray.keys.toList().indexOf( context.read<CommandProvider>().scllerMapper.mapperSelected) - (mapperList.indexOf(mp)))
//                                         .abs() ==
//                                         0
//                                         ? Colors.white
//                                         :Colors.black,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           )),
//                     );
//                   }).toList(),
//                   itemExtent: 50,
//                 )),
//           ),
//         ],
//       ),
//     );
//   }
//
//   ScallerWidget() {
//     return Container(
//       child: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Text(
//               "Scaler Select: "+context.watch<CommandProvider>().scllerMapper.RESPONSE_scallerSelected,
//               style: TextStyle(
//                   fontFamily: 'Montserrat',
//                   fontSize: 30,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold),
//             ),
//           ),
//           Container(
//             height: 10,
//           ),
//           Container(
//             width: 55,
//             height: 55,
//             decoration: new BoxDecoration(
//                 color: greenColor,
//                 borderRadius: new BorderRadius.all(Radius.circular(10.0))),
//             child: Center(
//               child: Text(
//                 context.watch<CommandProvider>().scllerMapper.scallerSelected,
//                 style: TextStyle(
//                     fontFamily: 'Montserrat',
//                     fontSize: 45,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//           Container(
//             height: 100,
//             width: 500,
//             child: RotatedBox(
//                 quarterTurns: 3,
//                 child: ListWheelScrollView(
//                   itemExtent: 50,
//
//
//
//                   onSelectedItemChanged: (x) {
//
//                     context.read<CommandProvider>().setScaller(scallerList[x]);
//
//                   },
//                   controller: ScallerfixedExtentScrollController,
//                   children: scallerList.map((mp) {
//
//                     return Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Container(
//                           height: 5,
//                           // width:(selected-(scallerList.indexOf(month))).abs()==1? 110:  (selected-(scallerList.indexOf(month))).abs()==0? 120:90,
//
//                           decoration: BoxDecoration(
//                               color:
//                               ( int.parse(context.watch<CommandProvider>().scllerMapper.scallerSelected) - (scallerList.indexOf(mp))).abs() == 1
//                                   ? lightBlueColor
//                                   : (int.parse( context.watch<CommandProvider>().scllerMapper.scallerSelected)  - (scallerList.indexOf(mp))).abs() == 0
//                                   ? blueColor
//                                   : Colors.white,
//                               borderRadius:
//                               new BorderRadius.all(Radius.circular(10.0))),
//                           child: RotatedBox(
//                             quarterTurns: -3,
//                             child: Center(
//                               child: Text(
//                                 mp,
//                                 style: TextStyle(
//                                     fontFamily: 'Montserrat',
//                                     fontSize: 30,
//                                     color: ( int.parse(context.watch<CommandProvider>().scllerMapper.scallerSelected) - (scallerList.indexOf(mp))).abs() == 1
//                                         ? Colors.black
//                                         : (int.parse( context.watch<CommandProvider>().scllerMapper.scallerSelected)  - (scallerList.indexOf(mp))).abs() == 0
//                                         ? Colors.white
//                                         : Colors.black,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           )),
//                     );
//                   }).toList(),
//                   // itemExtent: 50,
//                 )),
//           ),
//         ],
//       ),
//     );
//   }
//
//
// }
//
//
//
// void _launchURL(_url) async {
//   if (!await launch(_url)) throw 'Could not launch $_url';
// }
//
// Widget _buildAboutDialog(BuildContext context,String heading,widget ) {
//   return AlertDialog(
//     title:  Text(heading),
//     content: SingleChildScrollView(
//       child: new Column(
//
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//          widget,
//
//         ],
//       ),
//     ),
//     actions: <Widget>[
//       new FlatButton(
//         onPressed: () {
//           Navigator.of(context).pop();
//         },
//         textColor: Theme.of(context).primaryColor,
//         child: const Text('Okay, got it!'),
//       ),
//     ],
//   );
// }
//
// Widget _buildSetupText() {
//   return new RichText(
//     text: new TextSpan(
//       text: 'Please fit Your Tuning box as outlined in the installation instructions.\n\n',
//       style: const TextStyle(color: Colors.black87),
//       children: <TextSpan>[
//         const TextSpan(text: 'Install the app from the Google Play or Apple App Store.\n\n'),
//         new TextSpan(
//           text: 'Switch on your vehicle’s ignition and open the app. The app will request location data to use Bluetooth Low Energy, please allow this.\n\n',
//
//         ),
//         const TextSpan(
//           text: 'The app will now search for your tuning box. This will appear in the list as “TUNINGBOX”. If the app does not do so automatically please select this option.\n\n',
//         ),
//         new TextSpan(
//           text: 'The app should now connect and allow control of your tuning box.\n\n',
//
//         ),
//         const TextSpan(text: '.'),
//       ],
//     ),
//   );
// }
// Widget _buildUserGuideText() {
//   return SingleChildScrollView(
//     child: new RichText(
//       text: new TextSpan(
//         text: 'This application allows the user to control their tuning box remotely, and easily switch settings.\n\n',
//         style: const TextStyle(color: Colors.black87),
//         children: <TextSpan>[
//           const TextSpan(text: 'When the tuning box powers up it will always read its hardware settings first. If a unit is (for example) set to map C on the unit hardware, then at start up the unit will load and run map C. This setting can be changed via Bluetooth, but once the engine is turned off and the ECU powers down, the tuning box will revert to its hardware setting.\n\n'),
//           const TextSpan(text: 'Cold Start Delay\n\n',style:  const TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 15),),
//           const TextSpan(text: 'When activated, the cold start delay feature uses a count-down timer to allow the engine to warm up, prior to tune being applied.\n\n'),
//
//           const TextSpan(text: 'The countdown starts from the moment that throttle is applied (not simply when the engine is started). This allows users in cold climates to warm their engine at idle then have the countdown start when the vehicle is driven away.\n\n'),
//           new TextSpan(
//             text: 'A slight disadvantage of the cold start delay feature is that it activates every time the ECU powers up, regardless of whether the engine is actually warm. Typically the ECU takes a few minutes to power down but the engine can remain relatively warm for hours. If for example the user stops for fuel for 10 mins after 1 hour of driving, Cold Start Delay will not be needed.\n\n',
//
//           ),
//           const TextSpan(
//             text: 'To get around this, the app displays the cold start countdown time, but allows the user to skip the cold start delay at the push of a button. We do not recommend skipping the cold start feature on a cold engine.\n\n',
//           ),
//           new TextSpan(
//             text: 'For adjustment guides for each unit type please ',
//
//           ),
//           new TextSpan(
//             text: 'click here',
//             style: const TextStyle(color: Colors.indigo,fontWeight: FontWeight.bold,fontSize:18),
//             recognizer: new TapGestureRecognizer()..onTap = () =>  _launchURL('https://bluesparkautomotive.com/info-faq/instructions', ),
//           )
//
//         ],
//       ),
//     ),
//   );
// }
// Widget _buildUsingtheBypassPlugText() {
//   return SingleChildScrollView(
//     child: new RichText(
//       text: new TextSpan(
//         text: 'The included bypass plug can be used to return your vehicle to factory condition semi-permanently without the time or difficulty required in removing the entire wiring loom. With the bypass plug fitted, the unit wiring loom is simply an extension lead and the vehicle is returned to stock condition.\n\n',
//         style: const TextStyle(color: Colors.black87),
//         children: <TextSpan>[
//           const TextSpan(text: 'When returning the vehicle to a franchised dealer, we would recommend removing the wiring loom entirely.\n\n'),
//
//         ],
//       ),
//     ),
//   );
// }
// Widget _buildSafetyInformationText() {
//   return SingleChildScrollView(
//     child: new RichText(
//       text: new TextSpan(
//         text: 'Never use a mobile phone whilst driving. Ensure that whenever you use this application with your vehicle that you stop in a safe, secure location.\n\n',
//         style: const TextStyle(color: Colors.black87),
//         children: <TextSpan>[
//           const TextSpan(text: 'It is your responsibility to ensure that you obey all applicable laws while operating your vehicle.\n\n'),
//
//         ],
//       ),
//     ),
//   );
// }
// Widget _buildAppInformationText() {
//   return SingleChildScrollView(
//     child: new RichText(
//       text: new TextSpan(
//         text: 'App version 1.1\n\n',
//         style: const TextStyle(color: Colors.black87),
//         children: <TextSpan>[
//
//         ],
//       ),
//     ),
//   );
// }
// Widget _buildContactBluesparkText() {
//   return SingleChildScrollView(
//     child: new RichText(
//       text: new TextSpan(
//         text: '',
//         style: const TextStyle(color: Colors.black87),
//         children: <TextSpan>[
//           const TextSpan(text: 'Telephone:\n\n' ,        style: const TextStyle(color: Colors.black87,fontWeight: FontWeight.bold),),
//           new TextSpan(
//             text: '+ 44 (0) 191 385 9005\n\n',
//             style: const TextStyle(color: Colors.black87),
//             recognizer: new TapGestureRecognizer()..onTap = () =>  _launchURL('tel:+44(0) 191 385 9005', ),
//           ),
//
//           const TextSpan(text: 'General Enquiries:\n\n' ,        style: const TextStyle(color: Colors.black87,fontWeight: FontWeight.bold),),
//           new TextSpan(
//             text: 'sales@bluesparkautomotive.com\n\n',
//             style: const TextStyle(color: Colors.black87),
//             recognizer: new TapGestureRecognizer()..onTap = () =>  _launchURL('mailto:sales@bluesparkautomotive.com', ),
//           ),
//
//
//           const TextSpan(text: 'Address:\n\n' ,        style: const TextStyle(color: Colors.black87,fontWeight: FontWeight.bold),),
//           const TextSpan(text: '''
// Bluespark Automotive
// Unit 23A Dubmire Industrial Estate Fence Houses
// Houghton-le-Spring
// Tyne and Wear
// DH4 5RJ
// U.K.\n\n''' ,        style: const TextStyle(color: Colors.black87),),
//         ],
//       ),
//     ),
//   );
// }

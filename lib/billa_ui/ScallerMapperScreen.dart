import 'dart:async';
import 'dart:io';
import 'package:rounded_loading_button/rounded_loading_button.dart';


import 'package:bluespark/billa_ui/ui_strings.dart';
import 'package:bluespark/src/ble/ble_device_connector.dart';
import 'package:bluespark/src/ble/ble_device_interactor.dart';
import 'package:bluespark/src/ble/ble_scanner.dart';
import 'package:bluespark/src/ui/device_detail/device_interaction_tab.dart';
import 'package:bluespark/src/ui/device_list.dart';
import 'package:bluespark/util/config.dart';
import 'package:bluespark/util/functions.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:math';
import 'package:horizontal_picker/horizontal_picker.dart';
import 'package:awesome_dialog/awesome_dialog.dart';



class ScallerMapperManager extends StatelessWidget {
  const ScallerMapperManager({
    required this.characteristic,
    Key? key,
  }) : super(key: key);
  final QualifiedCharacteristic characteristic;



  @override
  Widget build(BuildContext context) => Consumer2<BleScanner, BleScannerState?>(
    builder: (_, bleScanner, bleScannerState, __)
    => bleScanner.btfound==null? DeviceList(
      scannerState: bleScannerState ?? const BleScannerState(
        discoveredDevices: [],
        scanIsInProgress: false,
      ),
      startScan: bleScanner.startScan,
      stopScan: bleScanner.stopScan,
    ):Consumer<BleDeviceInteractor>(
        builder: (context, interactor, _) =>  Consumer3<BleDeviceConnector, ConnectionStateUpdate, BleDeviceInteractor>(
            builder: (_, deviceConnector, connectionStateUpdate, serviceDiscoverer,
                __) => ScallerMapperScreen(
              characteristic: characteristic,
              readCharacteristic: interactor.readCharacteristic,
              writeWithResponse: interactor.writeCharacterisiticWithResponse,
              writeWithoutResponse:
              interactor.writeCharacterisiticWithoutResponse,
              subscribeToCharacteristic: interactor.subScribeToCharacteristic,

              viewModel:    DeviceInteractionViewModel(
                  deviceId:  bleScanner.btfound.id,
                  connectionStatus: connectionStateUpdate.connectionState,
                  deviceConnector: deviceConnector,
                  discoverServices: () =>
                      serviceDiscoverer.discoverServices( bleScanner.btfound.id)),
            ))),
  );

// @override
// Widget build(BuildContext context) => Consumer<BleDeviceInteractor>(
//     builder: (context, interactor, _) =>  Consumer3<BleDeviceConnector, ConnectionStateUpdate, BleDeviceInteractor>(
// builder: (_, deviceConnector, connectionStateUpdate, serviceDiscoverer,
// __) => Welcome1(
//       characteristic: characteristic,
//       readCharacteristic: interactor.readCharacteristic,
//       writeWithResponse: interactor.writeCharacterisiticWithResponse,
//       writeWithoutResponse:
//       interactor.writeCharacterisiticWithoutResponse,
//       subscribeToCharacteristic: interactor.subScribeToCharacteristic,
//
//   viewModel:    DeviceInteractionViewModel(
//       deviceId:  bleScanner.btfound.id,
//       connectionStatus: connectionStateUpdate.connectionState,
//       deviceConnector: deviceConnector,
//       discoverServices: () =>
//           serviceDiscoverer.discoverServices( bleScanner.btfound.id)),
//     )));
}

class ScallerMapperScreen extends StatefulWidget {
  const ScallerMapperScreen(
  {
    required this.characteristic,
    required this.readCharacteristic,
    required this.writeWithResponse,
    required this.writeWithoutResponse,
    required this.subscribeToCharacteristic,
    required this.viewModel,
}
      );





  final DeviceInteractionViewModel viewModel;


  final QualifiedCharacteristic characteristic;
  final Future<List<int>> Function(QualifiedCharacteristic characteristic)
  readCharacteristic;
  final Future<void> Function(
      QualifiedCharacteristic characteristic, List<int> value)
  writeWithResponse;

  final Stream<List<int>> Function(QualifiedCharacteristic characteristic)
  subscribeToCharacteristic;

  final Future<void> Function(
      QualifiedCharacteristic characteristic, List<int> value)
  writeWithoutResponse;

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
  late StreamSubscription<List<int>>? subscribeStream;
  String maperResponse = "1";
  String scallerResponse = "31";

  String readOutput="";
  String writeOutput="";
  String subscribeOutput="";
  bool showSuccessMessage = false;
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  String subscitioResonse ="NO RESPONSE";

  bool errorMessageIsOpen = false;

  @override
  void initState() {
    super.initState();
    subscribeCharacteristicStream();
    print(widget.viewModel.connectionStatus);

    if(DeviceConnectionState.disconnected ==widget.viewModel.connectionStatus ){
      restartApp();

    }


  }


  @override
  void dispose() {
    subscribeStream?.cancel();
    super.dispose();
  }

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




  readtime() async {
    // print('2');
    // subscribeCharacteristic();
    //
    // // while(int.parse(maperResponse)>0){
    // await coommunicatewithDevice('201');
    // // sleep(Duration(seconds:1));
    // // print("readtime whilw");
    //
    // // }
  }


  Future<void> subscribeCharacteristic() async {
    subscribeStream =
        widget.subscribeToCharacteristic(widget.characteristic).listen((event) {
          setState(() {
            subscribeOutput = event.toString();
          });
        });
    setState(() {
      subscribeOutput = 'Notification set';
    });
  }

  Future<void> readCharacteristic() async {

    final result = await widget.readCharacteristic(widget.characteristic);
    print("read ${result}");


    setState(() {
      readOutput  = result.toString();
      String resultString = String.fromCharCodes(result);
      print(resultString);

      if(resultString.startsWith("#MAP_")    ){

          maperResponse = resultString.replaceAll("#MAP_", "").replaceAll("#", "");
          setState(() {
            // showSuccessMessage = true;
          });

      }
      else   if(resultString.startsWith("#SCA_")    )

      {
        scallerResponse = resultString.replaceAll("#SCA_", "").replaceAll("#", "").split("\n")[0];

        // setState(() {
        //   showSuccessMessage = true;
        // });
        // Future.delayed(Duration(seconds: 2), (){
        //   setState(() {
        //     showSuccessMessage = false;
        //   });

        // });
      }
      else{
        // AwesomeDialog(
        //   context: context,
        //   dialogType: DialogType.ERROR,
        //   animType: AnimType.BOTTOMSLIDE,
        //   title: 'Load Too High',
        //   desc: resultString+" Reduce Load to change  "+resultString.split(" ").last.replaceAll("^", "")??"",
        //   btnCancelOnPress: () {},
        //   btnOkOnPress: () {},
        // )..show();
      }



    });
  }

  List<int> _parseInput(msg) {


    var lst = msg
        .split(',')
        .map(
      int.parse,
    )
        .toList();
    List<int> ints = List<int>.from(lst);


    return ints;
  }

  Future<void> writeCharacteristicWithResponse(msg) async {
    await widget.writeWithResponse(widget.characteristic, _parseInput(msg));
    setState(() {
      writeOutput = 'Ok';
    });
  }


  Future<void> writeCharacteristicWithoutResponse(msg) async {
    print(widget.characteristic);
    print('5');
    await widget.writeWithoutResponse(widget.characteristic, _parseInput(msg)).then((value){
      print('v');

    });
    setState(() {
      writeOutput = 'Done';
    });
  }

  coommunicatewithDevice(msg) async {


    await writeCharacteristicWithoutResponse(msg);
return "okay";


  }

  setScallerMapper() async {

    try {
setState(() {
  _btnController.start();
});

        coommunicatewithDevice(mapsArray[ mapperList[Mapperselected].toString()]).then((d){
          print(d);
          sleep(Duration(milliseconds:400));
           // readCharacteristic().then((value) {
           //   // sleep(Duration(milliseconds:300));
    coommunicatewithDevice(scalerArray[ int.parse(scallerList[Scallerselected])]).then((d){});
           //   //   print(d);
           //   //   // sleep(Duration(milliseconds:300));
           //   //   readCharacteristic();
           //   // });
           // });
        });


// sleep(Duration(seconds:1));
//     await   coommunicatewithDevice(scalerArray[ int.parse(scallerList[Scallerselected])]);
//         sleep(Duration(seconds:1));
//         print("8484848");

        // await readCharacteristic();
print("848ddd 4848");

    } catch (e) {
      print(e);
      // setState(() {
      //   // _btnController.error();
      //
      // });

    }
    setState(() {
      _btnController.stop();

    });

  }

   subscribeCharacteristicStream()  {
    // subscribeStream =
       widget.subscribeToCharacteristic(widget.characteristic).listen((result) {
         // setState(() {
           subscitioResonse = result.toString();
         // });


         print("read ${result}");



         // setState(() {
           readOutput  = result.toString();
           String resultString = String.fromCharCodes(result);
           print(resultString);

           if(resultString.startsWith("#MAP_")    ){

             maperResponse = resultString.replaceAll("#MAP_", "").replaceAll("#", "");

           }
           else   if(resultString.startsWith("#SCA_")    )

           {
             scallerResponse = resultString.replaceAll("#SCA_", "").replaceAll("#", "").split("\n")[0];

             // setState(() {
             //   showSuccessMessage = true;
             // });
             // Future.delayed(Duration(seconds: 2), (){
             //   setState(() {
             //     showSuccessMessage = false;
             //   });

             // });
           } else   if(resultString.startsWith("#WUT_")){}
           else if (resultString.startsWith("^") && !errorMessageIsOpen ) {

             // setState(() {
               errorMessageIsOpen = true;
             // });
             print('resultString');
             print(resultString);
             AwesomeDialog(
               context: context,
               dialogType: DialogType.ERROR,
               animType: AnimType.BOTTOMSLIDE,
               title: 'Load Too High',
               desc: resultString,
               btnCancelOnPress: () {
                 setState(() {
                   errorMessageIsOpen = false;
                 });
               },
               btnOkOnPress: () {
                 setState(() {
                   errorMessageIsOpen = false;
                 });

               },
             ).show();
           }


         // });

       });
    // // setState(() {
    subscitioResonse = 'Notification set';
    // });
  }
  @override
  Widget build(BuildContext context) {
    print(widget.viewModel.connectionStatus );
    if(DeviceConnectionState.disconnected ==widget.viewModel.connectionStatus ){
      restartApp();

    }

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


       Text(subscitioResonse,

              style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,color: DeviceConnectionState.connected==widget.viewModel.connectionStatus?Colors.green:Colors.red,fontWeight:FontWeight.bold),),

            Text(
              "Status: ${widget.viewModel.connectionStatus}",
              style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,color: DeviceConnectionState.connected==widget.viewModel.connectionStatus?Colors.green:Colors.red,fontWeight:FontWeight.bold),),
            showSuccessMessage?    Padding(
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
            ):Container(),
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
                    doneButton()

                  ],
                ),
              ),

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
              "Map Select"+mapsArray.keys.elementAt(int.parse(maperResponse)<0?0:int.parse(maperResponse)-1),
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
           Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Scaler Select"+scallerResponse.toString(),
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

  doneButton(){

    return  RoundedLoadingButton(
      color: greenColor,
        child:Container(
          decoration: BoxDecoration(

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
        controller: _btnController,
        onPressed: setScallerMapper,

    );


  }
}


import 'dart:async';

import 'package:bluespark/providers/CommandProvider.dart';
import 'package:bluespark/src/ble/ble_device_connector.dart';
import 'package:bluespark/src/ble/ble_device_interactor.dart';
import 'package:bluespark/src/ble/ble_scanner.dart';
import 'package:bluespark/src/ui/device_detail/device_interaction_tab.dart';
import 'package:bluespark/src/ui/device_list.dart';
import 'package:bluespark/util/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:io';

import 'ScallerMapperScreen.dart';



class WelcomeStateManager extends StatelessWidget {
  const WelcomeStateManager({
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
                __) => Welcome1(
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


class Welcome1 extends StatefulWidget {
  const Welcome1({
    required this.characteristic,
    required this.readCharacteristic,
    required this.writeWithResponse,
    required this.writeWithoutResponse,
    required this.subscribeToCharacteristic,
    required this.viewModel,
    Key? key,

  }) : super(key: key);


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
  _Welcome1State createState() => _Welcome1State();
}

class _Welcome1State extends State<Welcome1> {
   String readOutput="";
   String writeOutput="";
   String subscribeOutput="";
   String timeRemaining = "31";

   int ctr =0;



  late StreamSubscription<List<int>>? subscribeStream;

   @override
   void initState() {
     super.initState();

     print(widget.viewModel.connectionStatus);

     if(DeviceConnectionState.disconnected ==widget.viewModel.connectionStatus ){
       restartApp();

     }

     Future.delayed(Duration(seconds:1),(){
       autoCallTimer();
     });
     subscribeCharacteristic();

   }



  @override
  void dispose() {
    subscribeStream?.cancel();
    super.dispose();
  }


   readtime() async {
     print('2');
     // subscribeCharacteristic();

     // while(int.parse(timeRemaining)>0){
     await coommunicatewithDevice('201');
      // sleep(Duration(seconds:1));
      // print("readtime whilw");

    // }
   }

   autoCallTimer() async {


     for (int i =0 ; int.parse(timeRemaining)>0 ; i++){
       print("trying ${i}");
       await readtime();
       sleep(Duration(milliseconds:300));

     }

   }
  Stream subscribeCharacteristicStream() async* {
     // subscribeStream =
    yield   widget.subscribeToCharacteristic(widget.characteristic).listen((result) {
      setState(() {
      readOutput  = result.toString();
      String resultString = String.fromCharCodes(result);

      if(resultString.startsWith("#WUT_")    ){
        timeRemaining = resultString.replaceAll("#WUT_", "").replaceAll("#", "");

      }
      else if ((int.parse(timeRemaining) )!=1){
        timeRemaining = (int.parse(timeRemaining) -1).toString();
      }


      });
         });
     // // setState(() {
     subscribeOutput = 'Notification set';
     // });
   }

  Future<void> subscribeCharacteristic() async {
    subscribeStream =
        widget.subscribeToCharacteristic(widget.characteristic).listen((result) {
          setState(() {
            readOutput  = result.toString();
            String resultString = String.fromCharCodes(result).split("\n")[0];

            if(resultString.startsWith("#WUT_")    ){
              timeRemaining = resultString.replaceAll("#WUT_", "").replaceAll("#", "");

            }
            // else if ((int.parse(timeRemaining) )!=1){
            //   timeRemaining = (int.parse(timeRemaining) -1).toString();
            // }


          });
        });
    // setState(() {
      subscribeOutput = 'Notification set';
    // });
  }

  Future<void> readCharacteristic() async {

    final result = await widget.readCharacteristic(widget.characteristic);
    print("write ${result}");


    // setState(() {
      readOutput  = result.toString();
      String resultString = String.fromCharCodes(result);

      if(resultString.startsWith("#WUT_")    ){
        timeRemaining = resultString.replaceAll("#WUT_", "").replaceAll("#", "");

      }
      else if ((int.parse(timeRemaining) )!=1){
        timeRemaining = (int.parse(timeRemaining) -1).toString();
      }


    // });
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
    // setState(() {
      writeOutput = 'Ok';
    // });
  }


  Future<void> writeCharacteristicWithoutResponse(msg) async {
    print(widget.characteristic);
    print('5');
    await widget.writeWithoutResponse(widget.characteristic, _parseInput(msg)).then((value){
      print('v');

    });
    // setState(() {
      writeOutput = 'Done';
    // });
  }

  coommunicatewithDevice(msg) async {
    print('3');

   await writeCharacteristicWithoutResponse(msg).then((value){

     print("write ${msg}");

     // readCharacteristic();
    });
    print('4');


  }
   Stream getStreamofTime() async* {
     int n =4;
     int i = 0;
     while (i < n) {
       yield i;
       print("_________");
       print(i);
       print(n);
       i++;
       // await  readtime();
       await Future.delayed(Duration(seconds: 2));
     }
   }

  @override
  Widget build(BuildContext context) {
     print(widget.viewModel.connectionStatus );
    if(DeviceConnectionState.disconnected ==widget.viewModel.connectionStatus ){
      restartApp();

    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,

        body: Stack(

          children: [
            Column(

              children: [




                Text(
                  "Status: ${widget.viewModel.connectionStatus}",
          style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,color: DeviceConnectionState.connected==widget.viewModel.connectionStatus?Colors.green:Colors.red,fontWeight:FontWeight.bold),),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text("Welcome",

                      style: TextStyle(fontFamily: 'Montserrat',fontSize: 45,color: Colors.white,fontWeight:FontWeight.bold),),
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text("readOutput   "+readOutput,

                      style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,color: Colors.white,fontWeight:FontWeight.bold),),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text( "writeOutput   "+writeOutput,

                      style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,color: Colors.white,fontWeight:FontWeight.bold),),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text( "subscribeOutput   "+subscribeOutput,

                      style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,color: Colors.white,fontWeight:FontWeight.bold),),
                  ),
                ),


              ],


            ),
            SlidingUpPanel(
                maxHeight:MediaQuery.of(context).size.height *0.65,
                minHeight: MediaQuery.of(context).size.height *0.65,
                color: Colors.blue,
                panel: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 230,
                      height: 40,
                      child:Text('Cold Start Delay',

                        style: TextStyle(fontFamily: 'Montserrat',fontSize: 30,color: Colors.white,fontWeight:FontWeight.bold),),

                      // style: TextStyle(fontSize: 20.0,color: Colors.white),)
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.circle,color: Colors.green,size: 20,),
                        Container(width: 5,),
                        Text('ACTIVE',
                          style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,color: Colors.white,fontWeight:FontWeight.bold),),
                      ],
                    ),
                    Stack(
                        children: <Widget>[
                          Image.asset('images/Welcome/Ellipse.png'),
                          Container(
                              height: 340,
                              child: Center(child: StreamBuilder(
                                stream: getStreamofTime(),
                                builder: (context, snapshot) {
                                  // if(snapshot.hasData){
                                    return Text("00:"+timeRemaining,style: TextStyle(color:Colors.white,fontSize: 30),);
                                  // }
                                  return Text("00:"+timeRemaining,style: TextStyle(color:Colors.white,fontSize: 30),);

                                }
                              ))),
                          Container(
                              height: 390,
                              child: Center(child: Text("Remaining",style: TextStyle(color:Colors.white,fontSize: 20),))),
                        ]
                    ),


                    Center(
                      child: Container(

                        decoration: new BoxDecoration(
                            color: Colors.black,
                            borderRadius: new BorderRadius.all( Radius.circular(10.0))
                        ),
                        height: 40,
                        child: FlatButton(
                          child: Text('CHECK TIMER AGAIN', style: TextStyle(fontSize: 20.0),),
                          textColor: Colors.white,
                          onPressed: () async {
                            ctr =0;
                            print('1');
                            setState(() {
                              timeRemaining = "31";
                            });
                            for (int i =0 ; int.parse(timeRemaining)>0 ; i++){
print("trying ${i}");
await readtime();
sleep(Duration(milliseconds:300));

                            }

                            // while(ctr<5){


      // Future.delayed(Duration(seconds: ctr+1),(){
      //   print(ctr);
      //   ctr++;
      //   readtime();
      //   sleep(Duration(seconds:4));
      // });
      //                                   }

                            // coommunicatewithDevice("205");
                            // Navigator.push(context,  (MaterialPageRoute<void>(
                            //   builder: (BuildContext context) => const ScallerMapperScreen(),)));

                          },
                        ),
                      ),
                    ),
                    Container(height: 10,),
                    Center(
                      child: Container(

                        decoration: new BoxDecoration(
                            color: Colors.black,
                            borderRadius: new BorderRadius.all( Radius.circular(10.0))
                        ),
                        height: 40,
                        child: FlatButton(
                          child: Text('SKIP TO SCALLER MAPPER', style: TextStyle(fontSize: 20.0),),
                          textColor: Colors.white,
                          onPressed: () async {
                            setState(() {
                              timeRemaining = "0";
                            });

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ScallerMapperManager(
                                    characteristic:widget.characteristic,
                                  ),
                                ));
                          },
                        ),
                      ),
                    ),
                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}

// status=8 clientIf=9 device=04:A3:16:A3:E8:DA
// D/BluetoothGatt( 5899): setCharacteristicNotification() - uuid: 0000ffe1-0000-1000-8000-00805f9b34fb enable: false
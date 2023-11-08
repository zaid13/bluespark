import 'dart:async';

import 'package:bluespark/screens/welcome/WelcomeScreen.dart';
import 'package:bluespark/src/ble/ble_device_connector.dart';
import 'package:bluespark/src/ble/ble_device_interactor.dart';
import 'package:bluespark/src/ble/ble_scanner.dart';
import 'package:bluespark/src/ui/device_detail/device_interaction_tab.dart';
import 'package:bluespark/src/ui/device_list.dart';
// import 'package:bluespark/variables/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';

import '../util/config.dart';




class SpalshScreenStateManager extends StatelessWidget {
  const SpalshScreenStateManager({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer2<BleScanner, BleScannerState?>(
    builder: (_, bleScanner, bleScannerState, __)
    {
      print(bleScanner.btfound);
      print('bleScanner.btfound');
      return bleScanner.btfound==null? DeviceList(
        scannerState: bleScannerState ?? const BleScannerState(
          discoveredDevices: [],
          scanIsInProgress: false,
        ),
        startScan: bleScanner.startScan,
        stopScan: bleScanner.stopScan,
      ):Consumer<BleDeviceConnector>(
          builder: (_, deviceConnector, __) =>


              Consumer3<BleDeviceConnector, ConnectionStateUpdate, BleDeviceInteractor>(
                  builder: (_, deviceConnector, connectionStateUpdate, serviceDiscoverer,
                      __) {
                 return   SpalshScreen(
                      scannerState: bleScannerState ?? const BleScannerState(
                        discoveredDevices: [],
                        scanIsInProgress: false,
                      ),
                      startScan: bleScanner.startScan,
                      stopScan: bleScanner.stopScan,
                      device: bleScanner.btfound,
                      disconnect: deviceConnector.disconnect,


                      viewModel:    DeviceInteractionViewModel(
                          deviceId:  bleScanner.btfound.id,
                          connectionStatus: connectionStateUpdate.connectionState,
                          deviceConnector: deviceConnector,
                          discoverServices: () =>
                              serviceDiscoverer.discoverServices( bleScanner.btfound.id)),


                      deviceConnector: deviceConnector,


                    );
                  }



              )



      );
    },

  );
}

class SpalshScreen extends StatefulWidget {

  const SpalshScreen(
      {required this.scannerState,
        required this.startScan,
        required this.stopScan,

        required this.device,
        required this.disconnect,


        required this.viewModel,

        required this.deviceConnector,


      });

  final BleScannerState scannerState;
  final void Function(List<Uuid>) startScan;
  final VoidCallback stopScan;

  final DiscoveredDevice device;
  final void Function(String deviceId) disconnect;

  final DeviceInteractionViewModel viewModel;

  final BleDeviceConnector deviceConnector;

  @override
  _SpalshScreenState createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen> {
  late TextEditingController _uuidController;



  startConnectingService(){
    Future.delayed(const Duration(seconds: delay_time_small), () async {





      print('checking device ');
      bool btfound = false;
      List<DiscoveredDevice> discoveredDevices=[];





      deviceId = widget.device.id;

      print(widget.device.name);
      btfound = true;

      print('1');
      await  widget.viewModel.connect().then((value) {
        print('2 ');
        isconnecting = false;
      });
      print('3');

      while(push) {
        await Future.delayed(const Duration(seconds: delay_time_small), () async {
          print(widget.viewModel.connectionStatus);
          print('widget.viewModel.connectionStatus');

          try{
            if (widget.viewModel.connectionStatus ==
                DeviceConnectionState.connected) {
              print("APP IS FULLY CONNECTED ");
              print(widget.viewModel.connectionStatus);
              print('widget.viewModel.connectionStatus pushval = $push');

              List<DiscoveredService> discoveredSevices =
                  await widget.viewModel.discoverServices();

              for (DiscoveredService i in discoveredSevices) {
                print('characteristicIds : ${i.characteristicIds}');

                for (var t in i.characteristics) {}
              }

              if (push) {
                push = false;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WelcomeStateManager(
                            characteristic: QualifiedCharacteristic(
                              characteristicId: discoveredSevices
                                  .last.characteristics.last.characteristicId,
                              serviceId: discoveredSevices.last.serviceId,
                              deviceId: deviceId,
                            ),
                          )),
                );
              }
            }
          }
          catch (e){
            print(e.toString());
          }
        });
      }

      // if(!btfound)
      //  {
      //    print("DEVICE NOT FOUND MOVING TO LIST ");
      //    Navigator.push(
      //        context,
      //        MaterialPageRoute(
      //          builder: (context) =>DeviceList(
      //            scannerState: widget.scannerState,
      //            startScan: widget.startScan,
      //            stopScan: widget.stopScan,
      //          ),
      //        ));
      //  }


    });
  }

  void _startScanning() {
    final text = _uuidController.text;
    widget.startScan(text.isEmpty ? [] : [Uuid.parse(_uuidController.text)]);
  }
  String deviceId = "";



  @override
  void dispose() {
    if(deviceId!="") {
      widget.disconnect(deviceId);
    }
    super.dispose();

  }
  @override
  void initState() {
    print('init state called ');
    super.initState();
    _uuidController = TextEditingController()
      ..addListener(() => setState(() {}));
    !widget.scannerState.scanIsInProgress &&
        _isValidUuidInput()
        ? _startScanning() : null;


   print( widget.viewModel.connectionStatus);



    // widget.deviceConnector.dart.stateForRestart.listen((event) {
    //   print("DEVIE STREAM WOKRING FINE ${event}");
    // });



  Future.delayed(Duration(milliseconds: delay_time_V_small),(){startConnectingService();});

  }


  bool _isValidUuidInput() {
    final uuidText = _uuidController.text;
    if (uuidText.isEmpty) {
      return true;
    } else {
      try {
        Uuid.parse(uuidText);
        return true;
      } on Exception {
        return false;
      }
    }
  }


  bool push = true;
  @override
  Widget build(BuildContext context) {
    return SplashWidget();
  }
}

class SplashWidget extends StatelessWidget {
  const SplashWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('images/main_screen/logo.png'),
                  Container(
                    height: 10,
                  ),
                  const Text(
                    "Loading...",
                    style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,color:Colors.white,fontWeight:FontWeight.bold),),

                ],
              )),


        ],
      ),
    );
  }
}


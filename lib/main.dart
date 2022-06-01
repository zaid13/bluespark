
import 'package:bluespark/providers/CommandProvider.dart';
import 'package:bluespark/providers/ConnectionProvider.dart';
import 'package:bluespark/src/ble/ble_device_connector.dart';
import 'package:bluespark/src/ble/ble_device_interactor.dart';
import 'package:bluespark/src/ble/ble_scanner.dart';
import 'package:bluespark/src/ble/ble_status_monitor.dart';
import 'package:bluespark/src/ui/ble_status_screen.dart';
import 'package:bluespark/src/ui/device_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

import 'billa_ui/SplashScreen.dart';
import 'billa_ui/ScallerMapperScreen.dart';
import 'billa_ui/WelcomeScreen.dart';
import 'billa_ui/testFile.dart';
import 'location/location.dart';
import 'src/ble/ble_logger.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
const _themeColor = Colors.lightGreen;


Future<void> main() async {



  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.toggle(enable:true);
  await   getLocation().then((value) {


    final _bleLogger = BleLogger();
    final _ble = FlutterReactiveBle();
    final _scanner = BleScanner(ble: _ble, logMessage: _bleLogger.addToLog);
    final _monitor = BleStatusMonitor(_ble);
    final _connector = BleDeviceConnector(
      ble: _ble,
      logMessage: _bleLogger.addToLog,
    );
    final _serviceDiscoverer = BleDeviceInteractor(
      bleDiscoverServices: _ble.discoverServices,
      readCharacteristic: _ble.readCharacteristic,
      writeWithResponse: _ble.writeCharacteristicWithResponse,
      writeWithOutResponse: _ble.writeCharacteristicWithoutResponse,
      subscribeToCharacteristic: _ble.subscribeToCharacteristic,
      logMessage: _bleLogger.addToLog,
    );
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CommandProvider()),

          Provider.value(value: _scanner),
          Provider.value(value: _monitor),
          
          Provider.value(value: _connector),
          Provider.value(value: _serviceDiscoverer),
          Provider.value(value: _bleLogger),
          StreamProvider<BleScannerState?>(
            create: (_) => _scanner.state,
            initialData: const BleScannerState(
              discoveredDevices: [],
              scanIsInProgress: false,
            ),
          ),
          StreamProvider<BleStatus?>(
            create: (_) => _monitor.state,
            initialData: BleStatus.unknown,
          ),
          StreamProvider<ConnectionStateUpdate>(
            create: (_) => _connector.state,
            initialData: const ConnectionStateUpdate(
              deviceId: 'Unknown device',
              connectionState: DeviceConnectionState.disconnected,
              failure: null,
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Reactive BLE example',
          color: _themeColor,
          theme: ThemeData(primarySwatch: _themeColor),
          home: const HomeScreen(),
        ),
      ),
    );

  });

}

class HomeScreen extends StatelessWidget {


  callApi() async {
    print('jgjfjf');
    var client = new http.Client();
    var VehicleDesciption = '3';
    try {
      var tt = await client.get(Uri.http('bluesparkautomotive.com','mapfiles/1A3C.bsk'));

      List<String> ls = (tt.body).split('\n');
      int counter =0;
      List Mastrerls_SIZE21= [];
      NumberFormat formatter = new NumberFormat("00");

      for (String i in ls) {
        counter++;
        if(counter==2){
          print('000000000593485945894058943589048530');
          VehicleDesciption = i.split(',')[0];

   if( int.parse(VehicleDesciption)>16){
     VehicleDesciption =   int.parse(VehicleDesciption).toRadixString(16).toString();
   }
    if( int.parse(VehicleDesciption)<10){
      VehicleDesciption  =  (VehicleDesciption.padLeft(2,'0'));
    }
    else{
      VehicleDesciption  = int.parse (VehicleDesciption).toRadixString(16).toString();


    }

          print(i);
        }
        if(counter>4 && counter<26){
          // print(i);
          var subStr = i.split(',');
          var NewLsit = [];
           for (var j in subStr ){
             print(j.split(',')[0]);
             if(int.parse(j.replaceFirst('\r', '').replaceFirst('\'', ''))>16){
               NewLsit.add(int.parse(j.replaceFirst('\r', '')).toRadixString(16));

             }
             else if(int.parse(j.replaceFirst('\r', '').replaceFirst('\'', ''))<10){

               NewLsit.add((formatter.format( int.parse(j.replaceFirst('\r', '')))).toString());

             }
             else{

               NewLsit.add((int.parse(j.replaceFirst('\r', '')).toRadixString(16)).toString().padLeft(2,'0'));

             }

           }

          Mastrerls_SIZE21.add(NewLsit);
        }
      }


      print(Mastrerls_SIZE21);

      for(int i= 0 ; i< 30 ; i++){
        List result = getDataforNumber(Mastrerls_SIZE21,i);
        print(result);
      }




    }
    finally {
    client.close();
    }

  }
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<BleStatus?>(
        builder: (_, status, __) {



          if (status == BleStatus.ready) {



            return       SpalshScreenStateManager();
            return      DeviceListScreen1(); //SpalshScreenStateManager();

          } else {
            return BleStatusScreen(status: status ?? BleStatus.unknown);
          }
        },
      );
}
getDataforNumber(Mastrerls_SIZE21,int number){
  List lst = [];

  for (int i = 7*(number%3) ; i<(7*(number%3))+7; i++ ){
    // print((number/3).toInt());
    // print(i);
    lst.add(Mastrerls_SIZE21[i][(number/3).toInt()]);
  }
return  lst;

}

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bluespark/providers/CommandProvider.dart';
import 'package:bluespark/providers/ConfigProvider.dart';


import 'package:bluespark/providers/SendProvider.dart';
import 'package:bluespark/screens/TestingScreen.dart';
import 'package:bluespark/src/ble/ble_device_connector.dart';
import 'package:bluespark/src/ble/ble_device_interactor.dart';
import 'package:bluespark/src/ble/ble_scanner.dart';
import 'package:bluespark/src/ble/ble_status_monitor.dart';
import 'package:bluespark/src/ui/ble_status_screen.dart';
import 'package:bluespark/src/ui/device_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:location/location.dart';

import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

import 'screens/SplashScreen.dart';
import 'location/location.dart';
import 'src/ble/ble_logger.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
const _themeColor = Colors.lightGreen;


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.toggle(enable:true);





     getLocation().then((value) async {

    final LocationData _locationResult = await location.getLocation();



  });

  runApp(Phoenix(child: MyApp()));


}
final Location location = Location();
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
// launchPopUpIfRequired(){
//
//      AwesomeDialog(
//       context: context,
//       dialogType: DialogType.INFO,
//       animType: AnimType.BOTTOMSLIDE,
//       title: 'location permissions',
//       desc: 'Bluespark Connect uses location data permissions to allow Bluetooth Low Energy scanning only. It does not collect or otherwise store location data.',
//   // btnCancelOnPress: () {
//   //
//   // },
//   btnOkOnPress: () {},
//   ).show().then((value) {
//   context.read<CommandProvider>().MAPPER_ERROR_CLOSED();
//   });
//
// }



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

    return  MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CommandProvider()),
        ChangeNotifierProvider(create: (_) => ConfigProvider()),
        ChangeNotifierProvider(create: (_) => SendProvider()),


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
        debugShowCheckedModeBanner: false,
        title: 'Flutter Reactive BLE example',
        color: _themeColor,
        theme: ThemeData(primarySwatch: _themeColor),
        home: const HomeScreen(),
      ),
    );
  }
}


class HomeScreen extends StatelessWidget {


  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<BleStatus?>(
        builder: (_, status, __) {




          if (status == BleStatus.ready) {



            return       const SpalshScreenStateManager();
            return      const DeviceListScreen1(); //SpalshScreenStateManager();

          } else {
            return BleStatusScreen(status: status ?? BleStatus.unknown);
          }
        },
      );
}
// getDataforNumber(Mastrerls_SIZE21,int number){
//   List lst = [];
//
//   for (int i = 7*(number%3) ; i<(7*(number%3))+7; i++ ){
//     // print((number/3).toInt());
//     // print(i);
//     lst.add(Mastrerls_SIZE21[i][(number/3).toInt()]);
//   }
// return  lst;
//
// }
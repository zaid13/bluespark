import 'dart:async';

import 'package:bluespark/providers/CommandProvider.dart';
import 'package:bluespark/src/ble/ble_device_connector.dart';
import 'package:bluespark/src/ble/ble_device_interactor.dart';
import 'package:bluespark/src/ble/ble_scanner.dart';
import 'package:bluespark/src/ui/device_detail/device_interaction_tab.dart';
import 'package:bluespark/src/ui/device_list.dart';
import 'package:bluespark/util/config.dart';
import 'package:bluespark/util/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';


import '../providers/SendProvider.dart';
import 'ScallerMapperScreen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class WelcomeStateManager extends StatelessWidget {
  const WelcomeStateManager({
    required this.characteristic,
    Key? key,
  }) : super(key: key);
  final QualifiedCharacteristic characteristic;

  @override
  Widget build(BuildContext context) => Consumer2<BleScanner, BleScannerState?>(
        builder: (_, bleScanner, bleScannerState, __) => bleScanner.btfound ==
                null
            ? DeviceList(
                scannerState: bleScannerState ??
                    const BleScannerState(
                      discoveredDevices: [],
                      scanIsInProgress: false,
                    ),
                startScan: bleScanner.startScan,
                stopScan: bleScanner.stopScan,
              )
            : Consumer<BleDeviceInteractor>(
                builder: (context, interactor, _) => Consumer3<
                        BleDeviceConnector,
                        ConnectionStateUpdate,
                        BleDeviceInteractor>(
                    builder: (_, deviceConnector, connectionStateUpdate,
                            serviceDiscoverer, __) =>
                        Welcome1(
                          characteristic: characteristic,
                          readCharacteristic: interactor.readCharacteristic,
                          writeWithResponse:
                              interactor.writeCharacterisiticWithResponse,
                          writeWithoutResponse:
                              interactor.writeCharacterisiticWithoutResponse,
                          subscribeToCharacteristic:
                              interactor.subScribeToCharacteristic,
                          viewModel: DeviceInteractionViewModel(
                              deviceId: bleScanner.btfound.id,
                              connectionStatus:
                                  connectionStateUpdate.connectionState,
                              deviceConnector: deviceConnector,
                              discoverServices: () => serviceDiscoverer
                                  .discoverServices(bleScanner.btfound.id)),
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
  // String readOutput="";
  String writeOutput = "";
  String subscribeOutput = "";
  // String timeRemaining = "31";
  //
  // // int ctr =0;
  // bool cancelledRequest = false;


  late StreamSubscription<List<int>>? subscribeStream;
  List<int> PrevDump = [];
  @override
  void initState() {
    super.initState();

    print(widget.viewModel.connectionStatus);

    if (DeviceConnectionState.disconnected ==
        widget.viewModel.connectionStatus) {
      restartApp();
    }

    // subscribeCharacteristic();



    context.read<SendProvider>().initalizeSendProvider(
        widget.subscribeToCharacteristic(widget.characteristic) , widget.writeWithoutResponse, widget.characteristic);
    // subscribeCharacteristic();

    CommandProvider commandProvider =  context.read<CommandProvider>();

    context.read<SendProvider>().listenTOWelcomeScreen(commandProvider,(){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScallerMapperManager(
                characteristic: widget.characteristic,
                isScaler:
                context.read<CommandProvider>().scllerMapper.isScaller),
          )).then((value) {});
    } );

    context.read<SendProvider>().sendData(GetDviceType);



    //
    // Future.delayed(Duration(seconds: 1), () async {
    //   await readDeviceType();
    //
    // });
  }

  @override
  void didChangeDependencies() {

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    subscribeStream?.cancel();
    super.dispose();
  }


  Future<void> readCharacteristic() async {
    final result = await widget.readCharacteristic(widget.characteristic);
    print("write $result");
  }

  setTime(resultString) async {
    print('setTime');
    print(resultString);

    if (resultString.startsWith('#DEV_')) {
      print('WE JUST GOT DEV RES:$resultString');
      if (100 <
          int.parse(resultString.replaceAll("#DEV_", "").replaceAll("^", ""))) {
        context.read<CommandProvider>().isScaller();
        context.read<CommandProvider>().isScallerSet();
      } else if (100 >=
          int.parse(resultString.replaceAll("#DEV_", "").replaceAll("^", ""))) {
        context.read<CommandProvider>().isNotScaller();
        context.read<CommandProvider>().isScallerSet();
      }
    }

    if (context
        .read<CommandProvider>()
        .setTime(resultString.replaceAll("#WUT_", "").replaceAll("^", ""))) {
      print(
          'time is up moving to scaller mapper scaller is ${context.read<CommandProvider>().scllerMapper.isScallerSet} ');

      //move to next screen

      if (context.read<CommandProvider>().scllerMapper.isScallerSet &&
          context.read<CommandProvider>().scllerMapper.disableTimer) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScallerMapperManager(
                  characteristic: widget.characteristic,
                  isScaler:
                      context.read<CommandProvider>().scllerMapper.isScaller),
            )).then((value) {});
      }
    }
  }

  Future<void> subscribeCharacteristic() async {
    context.read<CommandProvider>().getData();

    subscribeStream = widget
        .subscribeToCharacteristic(widget.characteristic)
        .listen((result) {
      // print('readOutput   ${result}');

      // setState(() {
      context.read<CommandProvider>().setReadOutput(result.toString());
      String resultString = String.fromCharCodes(result).split("\n")[0];
      // print('readOutput CONVERTED    ${resultString}');

      print('resultString');
      print(resultString);
      print('result');
      print(result);
      print(result.first);
      print(result.last);

      if (result.first == 35 &&
          result.last == 10 &&
          resultString.replaceAll("#WUT_", "").replaceAll("#", "") !=
              context.read<CommandProvider>().getTime()) {
        print('Complete ');
        print(result);
        setTime(resultString);
      } else if ((result.first == 35 &&
          result.last != 10 &&
          resultString.replaceAll("#WUT_", "").replaceAll("#", "") !=
              context.read<CommandProvider>().getTime())) {
        print('Complete 2 ');
        PrevDump = result;
        // print("FOUND FIRST PA RT -------------------------------_____=-$result.last");

      } else if ((result.first != 35 &&
          result.last == 10 &&
          resultString.replaceAll("#WUT_", "").replaceAll("#", "") !=
              context.read<CommandProvider>().getTime())) {
        // print(PrevDump);
        // print(resultString);

        PrevDump += result;
        result = [];
        print("FOUND SECOND PART -------------------------------_____=-");
        print(PrevDump);
        print(String.fromCharCodes(PrevDump).split("\n")[0].split('^')[0]);
        setTime(String.fromCharCodes(PrevDump).split("\n")[0].split('^')[0]);
      } else if (result.first == 35 &&
          result.last == 13 &&
          resultString.replaceAll("#WUT_", "").replaceAll("#", "") !=
              context.read<CommandProvider>().getTime()) {
        print('Complete ');
        print(result);
        setTime(resultString);
      } else if ((result.first == 35 &&
          result.last != 13 &&
          resultString.replaceAll("#WUT_", "").replaceAll("#", "") !=
              context.read<CommandProvider>().getTime())) {
        print('Complete 2 ');
        PrevDump = result;
        // print("FOUND FIRST PA RT -------------------------------_____=-$result.last");

      } else if ((result.first != 35 &&
          result.last == 13 &&
          resultString.replaceAll("#WUT_", "").replaceAll("#", "") !=
              context.read<CommandProvider>().getTime())) {
        // print(PrevDump);
        // print(resultString);

        PrevDump += result;
        result = [];
        print("FOUND SECOND PART -------------------------------_____=-");
        print(PrevDump);
        print(String.fromCharCodes(PrevDump).split("\n")[0].split('^')[0]);
        setTime(String.fromCharCodes(PrevDump).split("\n")[0].split('^')[0]);
      }
    });

  }


  Future<void> writeCharacteristicWithoutResponse(msg) async {
    // print(widget.characteristic);
    print('5');
    print(ASCII_TO_INT(msg));
    await widget
        .writeWithoutResponse(widget.characteristic, ASCII_TO_INT(msg))
        .then((value) {
      print('v');
    });
    // setState(() {
    writeOutput = 'Done';
    // });
  }

  // coommunicatewithDevice(msg) async {
  //   // print('3');
  //
  //   await writeCharacteristicWithoutResponse(msg).then((value) {
  //     // print("write ${msg}");
  //
  //     // readCharacteristic();
  //   });
  //   // print('4');
  // }

  // readtime() async {
  //   sleep(Duration(milliseconds: 400));
  //   await coommunicatewithDevice('201');
  // }
  //
  // readDeviceType() async {
  //   await coommunicatewithDevice(GetDviceType);
  // }


  bool isCalledOnce = true;

  futureCall() async {
    if (isCalledOnce) {
      isCalledOnce = false;
      await Future.delayed(const Duration(seconds: 1), () {});
    }

    return 1;
  }

  @override
  Widget build(BuildContext context) {

    if (DeviceConnectionState.disconnected ==
        widget.viewModel.connectionStatus) {
      restartApp();
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: FutureBuilder(
            future: futureCall(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Column(
                    children: [

                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "Welcome",
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
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.75 < 500
                            ? 600
                            : MediaQuery.of(context).size.height * 0.75,
                        child: ModalProgressHUD(
                            inAsyncCall: context
                                .watch<CommandProvider>()
                                .MovingToNextScreen,
                            child: Container(
                              height: MediaQuery.of(context).size.height *
                                          0.75 <
                                      500
                                  ? 600
                                  : MediaQuery.of(context).size.height * 0.75,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.blue,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: 230,
                                    height: 40,
                                    child: const Text(
                                      'Cold Start Delay',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 30,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),

                                    // style: TextStyle(fontSize: 20.0,color: Colors.white),)
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.circle,
                                        color: Colors.green,
                                        size: 20,
                                      ),
                                      Container(
                                        width: 5,
                                      ),
                                      const Text(
                                        'ACTIVE',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 350,
                                    child: Container(
                                        width: 300,
                                        height: 300,
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.black87),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              processNumber(),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 60),
                                            ),
                                            const Text(
                                              "Remaining",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 30),
                                            ),
                                          ],
                                        )),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      print('skip is spressed ');

                                      context
                                          .read<CommandProvider>()
                                          .scllerMapper
                                          .disableTimer = false;

                                      context
                                          .read<CommandProvider>()
                                          .startMovingTonextScreen();
                                      context
                                          .read<CommandProvider>()
                                          .stopSendingRequests();

                                      await writeCharacteristicWithoutResponse(
                                              endTimerMSG)
                                          .then((value) {
                                        // setState(() {
                                        //   // commandProvider.stopSendingRequests();  todo
                                        //   // commandProvider.cancelledRequest = true;
                                        //   //
                                        //   // commandProvider.   timeRemaining = "0";
                                        // });

                                        print('going to map scaler screen ');

                                        //   Future.delayed(Duration(milliseconds:100),() async {

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ScallerMapperManager(
                                                      characteristic:
                                                          widget.characteristic,
                                                      isScaler: context
                                                          .read<
                                                              CommandProvider>()
                                                          .scllerMapper
                                                          .isScaller),
                                            )).then((value) {
                                          context
                                              .read<CommandProvider>()
                                              .scllerMapper
                                              .disableTimer = true;
                                        });
                                        //   });

                                        context
                                            .read<CommandProvider>()
                                            .stopMovingTonextScreen();

                                        print("write }");

                                        // readCharacteristic();
                                      });
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      // height: `50`,
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 40, vertical: 15),
                                        child: Text(
                                          'Skip Cold Start Delay',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 30,
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                );
              }

              return Stack(
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
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
                ],
              );
            }),
      ),
    );
  }

  processNumber() {
    if (isNumeric(context
        .watch<CommandProvider>()
        .getTime()
        .toString()
        .replaceAll(" ", "")
        .replaceAll("\n", ""))) {
      int i = int.parse(context
          .watch<CommandProvider>()
          .getTime()
          .toString()
          .replaceAll(" ", "")
          .replaceAll("\n", ""));
      String min = '00';

      int intmin = (i / 60).truncate();
      int intsec = (i % 60).truncate();

      String strmin = "00";
      String strsec = "00";

      if (intmin > 0 && intmin < 10) //0 --- 9
      {
        strmin = intmin.toString().padLeft(2, "0");
      }
      if (intsec > 0 && intsec < 10) //0 --- 9
      {
        strsec = intsec.toString().padLeft(2, "0");
      }
      if (intsec >= 10 && intsec < 60) {
        strsec = intsec.toString();
      }
      if ((strmin + ':' + strsec) == "00:00") {
        return "--:--";
      }

      return strmin + ':' + strsec;
    }
  }
}
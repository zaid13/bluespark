import 'dart:async';
import 'dart:io';
import 'package:bluespark/providers/CommandProvider.dart';
import 'package:bluespark/providers/SendProvider.dart';
import 'package:bluespark/screens/tunningbox/change_tunning_box.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_haptic/haptic.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'package:bluespark/screens/ui_strings.dart';
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
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

import 'configPage.dart';

class ScallerMapperManager extends StatelessWidget {
  const ScallerMapperManager(
      {required this.characteristic, Key? key, required this.isScaler})
      : super(key: key);
  final QualifiedCharacteristic characteristic;
  final bool isScaler;

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
                        ScallerMapperScreen(
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
                          isScaler: isScaler,
                        ))),
      );


}

class ScallerMapperScreen extends StatefulWidget {
  const ScallerMapperScreen(
      {required this.characteristic,
      required this.readCharacteristic,
      required this.writeWithResponse,
      required this.writeWithoutResponse,
      required this.subscribeToCharacteristic,
      required this.viewModel,
      required this.isScaler});

  final bool isScaler;

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List scallerList = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];
  List mapperList = [
    '0',
    "A",
    "B",
    "C",
    "D",
    "E",
  ];
  late StreamSubscription<List<int>>? subscribeStream;
  // String maperResponse = "1";
  // String scallerResponse = "31";

  // String readOutput="";
  // String writeOutput="";
  // String subscribeOutput="";
  // bool showSuccessMessage = false;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  // String subscitioResonse =Z"NO RESPONSE";

  // bool errorMessageIsOpen = false;

  @override
  void initState() {
    super.initState();
    print('init is caling');

    // context.read<CommandProvider>().  setSyncOn();

    subscribeCharacteristic();

    InitsetScallerMapper();

    print(widget.viewModel.connectionStatus);

    if (DeviceConnectionState.disconnected ==
        widget.viewModel.connectionStatus) {
      restartApp();
    }
    // MapperfixedExtentScrollController =
    // new FixedExtentScrollController(initialItem: mapsArray.keys.toList().indexOf( context.read<CommandProvider>().scllerMapper.RESPONSE_mapperSelected));
    // ScallerfixedExtentScrollController =
    // new FixedExtentScrollController(initialItem: int.parse( context.read<CommandProvider>().scllerMapper.RESPONSE_scallerSelected));

    Future.delayed(const Duration(seconds: 5), () {
      context.read<CommandProvider>().setSwipeToChangeIsDisable();

      Future.delayed(const Duration(seconds: 5), () {
        context.read<CommandProvider>().disable_all_messages();
      });
    });
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

  // var Mapperselected = 2;
  // var Scallerselected = 2;
  FixedExtentScrollController MapperfixedExtentScrollController =
      FixedExtentScrollController(initialItem: 2);

  FixedExtentScrollController ScallerfixedExtentScrollController =
      FixedExtentScrollController(initialItem: 2);

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

  ASCII_TO_INT(name) {
    List<int> intList = [];

    //loop to each character in string
    for (int i = 0; i < name.length; i++) {
      intList.add(name.codeUnitAt(i));
    }
    return intList + [13];
  }

  Future<void> writeCharacteristicWithoutResponse(msg) async {
    print(widget.characteristic);
    print('5');
    await widget
        .writeWithoutResponse(widget.characteristic, ASCII_TO_INT(msg))
        .then((value) {
      print('v');
    });
    // setState(() {
    //   writeOutput = 'Done';
    // });
  }

  InitsetScallerMapper() async {
    try {
      // context.read<SendProvider>().sendData(GetMapperCode);
      // context.read<SendProvider>().sendData(GetScallerCode);

      context.read<SendProvider>().sendData(GetMapperCode).then((d) {
        print(d);
        sleep(const Duration(milliseconds: 500));
        context.read<SendProvider>().sendData(GetScallerCode).then((d) async {

       await Future.delayed(Duration(seconds: 1),(){
          var mapvalue = mapperList[int.parse(context
              .read<CommandProvider>()
              .scllerMapper
              .RESPONSE_mapperSelected)];
          print('Yyyyyyyyy :$mapvalue');

          context.read<CommandProvider>().setMapper(mapvalue);

          Future.delayed(const Duration(milliseconds: 400), () {
            if (widget.isScaler) {
              context.read<CommandProvider>().setScaller(context
                  .read<CommandProvider>()
                  .scllerMapper
                  .RESPONSE_scallerSelected);
            }

            if (widget.isScaler) {
              print(
                  'animate the SCALLER to ${int.parse(context.read<CommandProvider>().scllerMapper.RESPONSE_scallerSelected)}');


              MapperfixedExtentScrollController.animateToItem(
                int.parse(context
                    .read<CommandProvider>()
                    .scllerMapper
                    .RESPONSE_mapperSelected),
                duration: const Duration(milliseconds: 100),
                curve: Curves.fastOutSlowIn,
              ).then((value) {
                ScallerfixedExtentScrollController.animateToItem(
                  int.parse(context
                      .read<CommandProvider>()
                      .scllerMapper
                      .RESPONSE_scallerSelected),
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.fastOutSlowIn,
                );
              });


            }else{
              MapperfixedExtentScrollController.animateToItem(
                int.parse(context
                    .read<CommandProvider>()
                    .scllerMapper
                    .RESPONSE_mapperSelected),
                duration: const Duration(milliseconds: 100),
                curve: Curves.fastOutSlowIn,
              );
            }
          });


        });

        });
      });
    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));

      print(e);
      print('ERROR 900');
    }

  }

  setScallerMapper() async {
    try {
      setState(() {
        _btnController.start();
      });

      // context.read<SendProvider>().sendData(
      //     mapsArray[context.read<CommandProvider>().scllerMapper.mapperSelected]
      //         .toString());

      context.read<SendProvider>().sendData(mapsArray[
                  context.read<CommandProvider>().scllerMapper.mapperSelected]
              .toString())
          .then((d) {
        print(d);
        if (widget.isScaler) {
          sleep(const Duration(milliseconds: 400));
          // context.read<SendProvider>().sendData(scalerArray[int.parse(
          //     context.read<CommandProvider>().scllerMapper.scallerSelected)]);

          context.read<SendProvider>().sendData(scalerArray[int.parse(context
                  .read<CommandProvider>()
                  .scllerMapper
                  .scallerSelected)])
              .then((d) {});
        }
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      _btnController.stop();
    });
  }

  List<int> PrevDump = [];

  scanAndRespond(String intactString) async {
    print("intactString");
    print(intactString);
    context.read<CommandProvider>().setSyncOff();

    if (intactString.startsWith("#SCA_") &&
        context.read<CommandProvider>().scllerMapper.RESPONSE_scallerSelected !=
            intactString.replaceAll("#SCA_", '').replaceAll("^", '') &&
        widget.isScaler) {
      print("intactString        1111");

      context.read<CommandProvider>().set_RESPONSE_Scaller(
          intactString.replaceAll("#SCA_", '').replaceAll("^", ''));
      context.read<CommandProvider>().ScallerMapperUpdateSucessfully();
      context.read<CommandProvider>().setSyncOff();
    } else if (intactString.startsWith("#MAP_") &&
        context.read<CommandProvider>().scllerMapper.RESPONSE_mapperSelected !=
            intactString.replaceAll("#MAP_", '').replaceAll("^", '')) {
      context.read<CommandProvider>().set_RESPONSE_Mapper(
          intactString.replaceAll("#MAP_", '').replaceAll("^", ''));
      context.read<CommandProvider>().ScallerMapperUpdateSucessfully();
      context.read<CommandProvider>().setSyncOff();
    } else if ((intactString.startsWith("#ERR_01") &&
        !context.read<CommandProvider>().scllerMapper.MAP_ERROR_IS_OPEN)) {
      print("intactString        33333");

      context.read<CommandProvider>().isMapperError();
      print("777777");
      await AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Map Not Set',
        desc: context.read<CommandProvider>().getErrorString('#ERR_01#'),
        // btnCancelOnPress: () {
        //
        // },
        btnOkOnPress: () {},
      ).show().then((value) {
        context.read<CommandProvider>().MAPPER_ERROR_CLOSED();
      });
    } else if ((intactString.startsWith("#ERR_02") &&
        !context.read<CommandProvider>().scllerMapper.SCALLER_ERROR_IS_OPEN)) {
      //&& context.read<CommandProvider>().scllerMapper.ERROR==0
      print("8888888``");

      context.read<CommandProvider>().isScallerError();
      await AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Scaler Not Set',
        desc: context.read<CommandProvider>().getErrorString('#ERR_02#'),
        // btnCancelOnPress: () {
        //
        // },
        btnOkOnPress: () {
          // context.read<CommandProvider>().ERROR_CLOSED();
        },
      ).show().then((value) {
        context.read<CommandProvider>().SCALLER_ERROR_CLOSED();
      });
    }
  }

  Future<void> subscribeCharacteristic() async {
    subscribeStream = widget
        .subscribeToCharacteristic(widget.characteristic)
        .listen((result) {
      // print('readOutput   ${result}');

      // setState(() {
      context.read<CommandProvider>().setReadOutput(result.toString());
      String resultString = String.fromCharCodes(result).split("\n")[0];
      print('resulteadOutput CONVERTED    $resultString');

      print('resultString');
      print(resultString);
      print('result');
      print(result);

      if(result.length>1 && result.first==13 && resultString.length>1){
        result = result.sublist(1,result.length-1);
        resultString = resultString.substring(1,resultString.length-1);

      }
      if (resultString == "201") {
        // context.read<CommandProvider>().   stopSendingRequests();

      } else if (result.first == 35 && result.last == 13) {
        scanAndRespond(resultString);

        // setTime(resultString);
      } else if ((result.first == 35 && result.last != 13)) {
        PrevDump = result;
        // print("FOUND FIRST PA RT -------------------------------_____=-$result.last");

      } else if ((result.first != 35 && result.last == 13) ||
          (result.first == 35 && result.length == 3)) {
        // print(PrevDump);
        // print(resultString);

        PrevDump += result;
        print("FOUND SECOND PART -------------------------------_____=-");
        print(PrevDump);

        if ((PrevDump.first == 35 && PrevDump.last == 13)) {
          resultString = String.fromCharCodes(PrevDump).split("\n")[0];
          scanAndRespond(resultString);
          print(
              "FOUND both parts -------------------------------_____=-$result.last   $resultString");
        }
      }
    });
    // setState(() {
    // subscribeOutput = 'Notification set';
    // });
  }

  @override
  Widget build(BuildContext context) {


    context.read<CommandProvider>().setScallerMapperContext(context)   ;



    print(widget.viewModel.connectionStatus);
    if (DeviceConnectionState.disconnected ==
        widget.viewModel.connectionStatus) {
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
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(20.0)),
            child: Drawer(
              elevation: 16.0,
              child: SingleChildScrollView(
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              toggleDrawer();
                            },
                            child: const Icon(
                              Icons.table_rows_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                          Container(
                            width: 10,
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'images/main_screen/logo.png',
                          ),
                        ),
                      ),
                      Container(
                        height: 100,
                      ),
                      ListTile(
                        onTap: () {

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => ChangeTunningBox(widget.viewModel ))));


                        },
                        title: Container(
                          alignment: Alignment.centerRight,
                          child: const Text(
                            "Change Tuning Box",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const Divider(
                        height: 0.1,
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => ConfigurationPage(
                                        characteristic: widget.characteristic,
                                        readCharacteristic:
                                            widget.readCharacteristic,
                                        writeWithResponse:
                                            widget.writeWithResponse,
                                        writeWithoutResponse:
                                            widget.writeWithoutResponse,
                                        subscribeToCharacteristic:
                                            widget.subscribeToCharacteristic,
                                        viewModel: widget.viewModel,
                                      ))));
                        },
                        title: Container(
                          alignment: Alignment.centerRight,
                          child: const Text(
                            "Reprogramming",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const Divider(
                        height: 0.1,
                      ),
                      ListTile(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => _buildAboutDialog(
                                context, "Setup Guide", _buildSetupText()),
                          );
                        },
                        title: Container(
                          alignment: Alignment.centerRight,
                          child: const Text(
                            "Setup Guide",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const Divider(
                        height: 0.1,
                      ),
                      ListTile(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => _buildAboutDialog(
                                context, "User Guide", _buildUserGuideText()),
                          );
                        },
                        title: Container(
                          alignment: Alignment.centerRight,
                          child: const Text(
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
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => _buildAboutDialog(
                                context,
                                "Using the Bypass Plug",
                                _buildUsingtheBypassPlugText()),
                          );
                        },
                        title: Container(
                          alignment: Alignment.centerRight,
                          child: const Text(
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
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => _buildAboutDialog(
                                context,
                                "Safety Information",
                                _buildSafetyInformationText()),
                          );
                        },
                        title: Container(
                          alignment: Alignment.centerRight,
                          child: const Text(
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
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => _buildAboutDialog(
                                context,
                                "App Information",
                                _buildAppInformationText()),
                          );
                        },
                        title: Container(
                          alignment: Alignment.centerRight,
                          child: const Text(
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
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => _buildAboutDialog(
                                context,
                                "Contact BLUESPARK",
                                _buildContactBluesparkText()),
                          );
                        },
                        title: Container(
                          alignment: Alignment.centerRight,
                          child: const Text(
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
                          child: const CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 30,
                            child: Icon(
                              Icons.close,
                              size: 55,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 10,
                      ),
                      const Text(
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
        ),
        appBar: AppBar(
          backgroundColor: blackColor,
          elevation: 0.0,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                      onTap: () {
                        print('swsw');
                        _scaffoldKey.currentState!.openEndDrawer();
                      },
                      child: const Icon(
                        Icons.table_rows_rounded,
                        color: Colors.white,
                        size: 35,
                      )),
                ],
              ),
            ),
          ],
        ),
        body: Container(
            child: ModalProgressHUD(
          inAsyncCall:
              false, //    context.watch<CommandProvider>().scllerMapper.syncIsOn,

          child: ListView(
            children: [
              Center(
                  child: Image.asset(
                'images/main_screen/logo.png',
                width: MediaQuery.of(context).size.width * 0.7,
              )),
              context.watch<CommandProvider>().scllerMapper.UpdateSucessfully
                  ? Padding(
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
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(50.0))),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 15,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          left: 50,
                                          right: 20,
                                          top: 5,
                                          bottom: 5),
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
                        ],
                      ),
                    )
                  : Container(),
              context.watch<CommandProvider>().swipeToChangeIsEnable == 0
                  ? Container()
                  : Padding(
                      padding:
                          const EdgeInsets.only(right: 30, left: 30, top: 10),
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                            color: blueColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50.0))),
                        child: Row(
                          mainAxisAlignment: context
                                      .watch<CommandProvider>()
                                      .swipeToChangeIsEnable ==
                                  1
                              ? MainAxisAlignment.spaceAround
                              : MainAxisAlignment.center,
                          children: [
                            context
                                        .watch<CommandProvider>()
                                        .swipeToChangeIsEnable ==
                                    1
                                ? const Text(
                                    "Swipe to change",
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                : const Text(
                                    'Click "Done" to update settings',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                            context
                                        .watch<CommandProvider>()
                                        .swipeToChangeIsEnable ==
                                    1
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      child: Image.asset(
                                        'images/img.png',
                                        height: 40,
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 40,
                                  )
                          ],
                        ),
                      ),
                    ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  mapperWidget(),
                  widget.isScaler ? ScallerWidget() : Container(),
                  Container(
                    height: 50,
                  ),
                  doneButton()
                ],
              ),
            ],
          ),
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
              "Map Select: " +
                  mapperList[int.parse(context
                      .watch<CommandProvider>()
                      .scllerMapper
                      .RESPONSE_mapperSelected)],
              style: const TextStyle(
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
            decoration: BoxDecoration(
                color: greenColor,
                borderRadius: const BorderRadius.all(Radius.circular(10.0))),
            child: Center(
              child: Text(
                context.watch<CommandProvider>().scllerMapper.mapperSelected,
                style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 45,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 100,
            width: 500,
            child: RotatedBox(
                quarterTurns: 3,
                child: ListWheelScrollView(
                  onSelectedItemChanged: (x) {

                    HapticFeedback.selectionClick();

                    context.read<CommandProvider>().setMapper(mapperList[x]);
                  },
                  controller: MapperfixedExtentScrollController,
                  children: mapperList.map((mp) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 5,
                          // width:(selected-(mapperList.indexOf(month))).abs()==1? 110:  (selected-(mapperList.indexOf(month))).abs()==0? 120:90,

                          decoration: BoxDecoration(
                              color: (mapsArray.keys.toList().indexOf(context
                                                  .read<CommandProvider>()
                                                  .scllerMapper
                                                  .mapperSelected) -
                                              (mapperList.indexOf(mp)))
                                          .abs() ==
                                      1
                                  ? lightBlueColor
                                  : (mapsArray.keys.toList().indexOf(context
                                                      .read<CommandProvider>()
                                                      .scllerMapper
                                                      .mapperSelected) -
                                                  (mapperList.indexOf(mp)))
                                              .abs() ==
                                          0
                                      ? blueColor
                                      : Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0))),
                          child: RotatedBox(
                            quarterTurns: -3,
                            child: Center(
                              child: Text(
                                mp,
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 30,
                                    color: (mapsArray.keys.toList().indexOf(
                                                        context
                                                            .read<
                                                                CommandProvider>()
                                                            .scllerMapper
                                                            .mapperSelected) -
                                                    (mapperList.indexOf(mp)))
                                                .abs() ==
                                            1
                                        ? Colors.black
                                        : (mapsArray.keys.toList().indexOf(context
                                                            .read<
                                                                CommandProvider>()
                                                            .scllerMapper
                                                            .mapperSelected) -
                                                        (mapperList
                                                            .indexOf(mp)))
                                                    .abs() ==
                                                0
                                            ? Colors.white
                                            : Colors.black,
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
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Scaler Select: " +
                  context
                      .watch<CommandProvider>()
                      .scllerMapper
                      .RESPONSE_scallerSelected,
              style: const TextStyle(
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
            decoration: BoxDecoration(
                color: greenColor,
                borderRadius: const BorderRadius.all(Radius.circular(10.0))),
            child: Center(
              child: Text(
                context.watch<CommandProvider>().scllerMapper.scallerSelected,
                style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 45,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 100,
            width: 500,
            child: RotatedBox(
                quarterTurns: 3,
                child: ListWheelScrollView(
                  itemExtent: 50,

                  onSelectedItemChanged: (x) {
                    print('555');

                    HapticFeedback.selectionClick();


                    context.read<CommandProvider>().setScaller(scallerList[x]);
                  },
                  controller: ScallerfixedExtentScrollController,
                  children: scallerList.map((mp) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 5,
                          // width:(selected-(scallerList.indexOf(month))).abs()==1? 110:  (selected-(scallerList.indexOf(month))).abs()==0? 120:90,

                          decoration: BoxDecoration(
                              color: (int.parse(context
                                                  .watch<CommandProvider>()
                                                  .scllerMapper
                                                  .scallerSelected) -
                                              (scallerList.indexOf(mp)))
                                          .abs() ==
                                      1
                                  ? lightBlueColor
                                  : (int.parse(context
                                                      .watch<CommandProvider>()
                                                      .scllerMapper
                                                      .scallerSelected) -
                                                  (scallerList.indexOf(mp)))
                                              .abs() ==
                                          0
                                      ? blueColor
                                      : Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0))),
                          child: RotatedBox(
                            quarterTurns: -3,
                            child: Center(
                              child: Text(
                                mp,
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 30,
                                    color: (int.parse(context
                                                        .watch<
                                                            CommandProvider>()
                                                        .scllerMapper
                                                        .scallerSelected) -
                                                    (scallerList.indexOf(mp)))
                                                .abs() ==
                                            1
                                        ? Colors.black
                                        : (int.parse(context
                                                            .watch<
                                                                CommandProvider>()
                                                            .scllerMapper
                                                            .scallerSelected) -
                                                        (scallerList
                                                            .indexOf(mp)))
                                                    .abs() ==
                                                0
                                            ? Colors.white
                                            : Colors.black,
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

  doneButton() {
    return RoundedLoadingButton(
      color: greenColor,
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
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

void _launchURL(_url) async {
  if (!await launch(_url)) throw 'Could not launch $_url';
}

Widget _buildAboutDialog(BuildContext context, String heading, widget) {
  return AlertDialog(
    title: Text(heading),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          widget,
        ],
      ),
    ),
    actions: <Widget>[
      GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
   //     textColor: Theme.of(context).primaryColor,
        child: const Text('Okay, got it!'),
      ),
    ],
  );
}

Widget _buildSetupText() {
  return RichText(
    text: const TextSpan(
      text:
          'Please fit Your Tuning box as outlined in the installation instructions.\n\n',
      style: TextStyle(color: Colors.black87),
      children: <TextSpan>[
        TextSpan(
            text:
                'Install the app from the Google Play or Apple App Store.\n\n'),
        TextSpan(
          text:
              'Switch on your vehicle’s ignition and open the app. The app will request location data to use Bluetooth Low Energy, please allow this.\n\n',
        ),
        TextSpan(
          text:
              'The app will now search for your tuning box. This will appear in the list as “TUNINGBOX”. If the app does not do so automatically please select this option.\n\n',
        ),
        TextSpan(
          text:
              'The app should now connect and allow control of your tuning box.\n\n',
        ),
        TextSpan(text: '.'),
      ],
    ),
  );
}

Widget _buildUserGuideText() {
  return SingleChildScrollView(
    child: RichText(
      text: TextSpan(
        text:
            'This application allows the user to control their tuning box remotely, and easily switch settings.\n\n',
        style: const TextStyle(color: Colors.black87),
        children: <TextSpan>[
          const TextSpan(
              text:
                  'When the tuning box powers up it will always read its hardware settings first. If a unit is (for example) set to map C on the unit hardware, then at start up the unit will load and run map C. This setting can be changed via Bluetooth, but once the engine is turned off and the ECU powers down, the tuning box will revert to its hardware setting.\n\n'),
          const TextSpan(
            text: 'Cold Start Delay\n\n',
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 15),
          ),
          const TextSpan(
              text:
                  'When activated, the cold start delay feature uses a count-down timer to allow the engine to warm up, prior to tune being applied.\n\n'),
          const TextSpan(
              text:
                  'The countdown starts from the moment that throttle is applied (not simply when the engine is started). This allows users in cold climates to warm their engine at idle then have the countdown start when the vehicle is driven away.\n\n'),
          const TextSpan(
            text:
                'A slight disadvantage of the cold start delay feature is that it activates every time the ECU powers up, regardless of whether the engine is actually warm. Typically the ECU takes a few minutes to power down but the engine can remain relatively warm for hours. If for example the user stops for fuel for 10 mins after 1 hour of driving, Cold Start Delay will not be needed.\n\n',
          ),
          const TextSpan(
            text:
                'To get around this, the app displays the cold start countdown time, but allows the user to skip the cold start delay at the push of a button. We do not recommend skipping the cold start feature on a cold engine.\n\n',
          ),
          const TextSpan(
            text: 'For adjustment guides for each unit type please ',
          ),
          TextSpan(
            text: 'click here',
            style: const TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.bold,
                fontSize: 18),
            recognizer: TapGestureRecognizer()
              ..onTap = () => _launchURL(
                    'https://bluesparkautomotive.com/info-faq/instructions',
                  ),
          )
        ],
      ),
    ),
  );
}

Widget _buildUsingtheBypassPlugText() {
  return SingleChildScrollView(
    child: RichText(
      text: const TextSpan(
        text:
            'The included bypass plug can be used to return your vehicle to factory condition semi-permanently without the time or difficulty required in removing the entire wiring loom. With the bypass plug fitted, the unit wiring loom is simply an extension lead and the vehicle is returned to stock condition.\n\n',
        style: TextStyle(color: Colors.black87),
        children: <TextSpan>[
          TextSpan(
              text:
                  'When returning the vehicle to a franchised dealer, we would recommend removing the wiring loom entirely.\n\n'),
        ],
      ),
    ),
  );
}

Widget _buildSafetyInformationText() {
  return SingleChildScrollView(
    child: RichText(
      text: const TextSpan(
        text:
            'Never use a mobile phone whilst driving. Ensure that whenever you use this application with your vehicle that you stop in a safe, secure location.\n\n',
        style: TextStyle(color: Colors.black87),
        children: <TextSpan>[
          TextSpan(
              text:
                  'It is your responsibility to ensure that you obey all applicable laws while operating your vehicle.\n\n'),
        ],
      ),
    ),
  );
}

Widget _buildAppInformationText() {
  return SingleChildScrollView(
    child: RichText(
      text: const TextSpan(
        text: 'App version 1.1\n\n',
        style: TextStyle(color: Colors.black87),
        children: <TextSpan>[],
      ),
    ),
  );
}

Widget _buildContactBluesparkText() {
  return SingleChildScrollView(
    child: RichText(
      text: TextSpan(
        text: '',
        style: const TextStyle(color: Colors.black87),
        children: <TextSpan>[
          const TextSpan(
            text: 'Telephone:\n\n',
            style: TextStyle(
                color: Colors.black87, fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: '+ 44 (0) 191 385 9005\n\n',
            style: const TextStyle(color: Colors.black87),
            recognizer: TapGestureRecognizer()
              ..onTap = () => _launchURL(
                    'tel:+44(0) 191 385 9005',
                  ),
          ),
          const TextSpan(
            text: 'General Enquiries:\n\n',
            style: TextStyle(
                color: Colors.black87, fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: 'sales@bluesparkautomotive.com\n\n',
            style: const TextStyle(color: Colors.black87),
            recognizer: TapGestureRecognizer()
              ..onTap = () => _launchURL(
                    'mailto:sales@bluesparkautomotive.com',
                  ),
          ),
          const TextSpan(
            text: 'Address:\n\n',
            style: TextStyle(
                color: Colors.black87, fontWeight: FontWeight.bold),
          ),
          const TextSpan(
            text: '''
Bluespark Automotive
Unit 23A Dubmire Industrial Estate Fence Houses
Houghton-le-Spring
Tyne and Wear
DH4 5RJ
U.K.\n\n''',
            style: TextStyle(color: Colors.black87),
          ),
        ],
      ),
    ),
  );
}

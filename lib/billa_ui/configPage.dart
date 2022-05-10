
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';

import '../providers/CommandProvider.dart';
import '../src/ui/device_detail/device_interaction_tab.dart';
import '../util/config.dart';
import '../util/functions.dart';

class ConfigurationPage extends StatefulWidget {
   ConfigurationPage(

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
  _ConfigurationPageState createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {


  late StreamSubscription<List<int>>? subscribeStream;

  List<int> PrevDump = [];



  scanAndRespond(String intactString) async {

    print("intactString");
    print(intactString);
    print("#ERR_01#");


    if(intactString.startsWith("#SCA_") && context.read<CommandProvider>().scllerMapper.RESPONSE_scallerSelected!=intactString.replaceAll("#SCA_",'').replaceAll("#", '')   ){
      print("intactString        1111");

      context.read<CommandProvider>().set_RESPONSE_Scaller(intactString.replaceAll("#SCA_",'').replaceAll("#", ''));
      context.read<CommandProvider>().ScallerMapperUpdateSucessfully();

    }
    else if(intactString.startsWith("#MAP_")  && context.read<CommandProvider>().scllerMapper.RESPONSE_mapperSelected!=intactString.replaceAll("#MAP_",'').replaceAll("#", '')){
      print("intactString        22222");



      context.read<CommandProvider>().set_RESPONSE_Mapper(intactString.replaceAll("#MAP_",'').replaceAll("#", ''));
      context.read<CommandProvider>().ScallerMapperUpdateSucessfully();

    }
    else if((intactString.startsWith( "#ERR_01")  && !context.read<CommandProvider>().scllerMapper.MAP_ERROR_IS_OPEN )){
      print("intactString        33333");

      context.read<CommandProvider>().isMapperError();
      print("777777");

    }
    else if((intactString.startsWith( "#ERR_02")  && !context.read<CommandProvider>().scllerMapper.SCALLER_ERROR_IS_OPEN  )  ){  //&& context.read<CommandProvider>().scllerMapper.ERROR==0
      print("8888888``");


      context.read<CommandProvider>().isScallerError();


    }


  }


  ASCII_TO_INT(name){
   List<int> intList = [];

    //loop to each character in string
    for(int i = 0; i <name.length; i++){
      intList.add(name.codeUnitAt(i));

    }
  return intList+[13];
  }


  List<int> _parseInput(msg) {


    var lst = msg
        .split(',')
        .map(
      int.parse,
    )
        .toList();
    List<int> ints = List<int>.from(lst);

print(ints);

    return ints+[13];
  }

  Future<void> subscribeCharacteristic() async {

    subscribeStream =
        widget.subscribeToCharacteristic(widget.characteristic).listen((result) {

          // print('readOutput   ${result}');


          // setState(() {
          context.read<CommandProvider>().setReadOutput( result.toString());
          String resultString = String.fromCharCodes(result).split("\n")[0];
          // print('readOutput CONVERTED    ${resultString}');

          print('resultString');
          print(resultString);
          print('result');
          print(result);
          print(result.first);
          print(result.last);
          if(result.first==37  && result.last==94    ){
            print('Complete ');
            print(result);
            // scanAndRespond(resultString);


            // setTime(resultString);
          }


          else    if((result.first==37  && result.last!=94 )){
            print('Complete 2 ');
            PrevDump  = result;
            // print("FOUND FIRST PA RT -------------------------------_____=-$result.last");


          }

          else      if((result.first!=37  && result.last==94 )){
            // print(PrevDump);
            // print(resultString);

            PrevDump  += result;
            result=[];
            print("FOUND SECOND PART -------------------------------_____=-");
            print(PrevDump);
            print(String.fromCharCodes(PrevDump).split("\n")[0].split('^')[0]);


          }




        });
    // setState(() {
    // subscribeOutput = 'Notification set';
    // });
  }

  Future<void> writeCharacteristicWithoutResponse(msg) async {
    print(widget.characteristic);
    print(msg);
    print('5');
    await widget.writeWithoutResponse(widget.characteristic, (msg)).then((value){
      print('vV');

    });
    // setState(() {
    //   writeOutput = 'Done';
    // });
  }

  coommunicatewithDevice(msg) async {


    await writeCharacteristicWithoutResponse(ASCII_TO_INT(msg));
    return "okay";


  }


  InitsetScallerMapper(val) async {

    try {


      coommunicatewithDevice(GetMapperCode).then((d){
        print(d);
        sleep(Duration(milliseconds:400));
        coommunicatewithDevice(GetScallerCode).then((d){
          sleep(Duration(milliseconds:400));
          print('Yyyyyyyyy');








        });

      });





    } catch (e) {
      print(e);


    }
    // setState(() {
    //   _btnController.stop();
    //
    // });

  }


  @override
  void initState() {




    super.initState();


    subscribeCharacteristic();


    InitsetScallerMapper('124');

    print(widget.viewModel.connectionStatus);

    if(DeviceConnectionState.disconnected ==widget.viewModel.connectionStatus ){
      restartApp();

    }
    // MapperfixedExtentScrollController =
    // new FixedExtentScrollController(initialItem: mapsArray.keys.toList().indexOf( context.read<CommandProvider>().scllerMapper.RESPONSE_mapperSelected));
    // ScallerfixedExtentScrollController =
    // new FixedExtentScrollController(initialItem: int.parse( context.read<CommandProvider>().scllerMapper.RESPONSE_scallerSelected));


    Future.delayed(Duration(seconds:5),(){
      context.read<CommandProvider>(). setSwipeToChangeIsDisable();

      Future.delayed(Duration(seconds:5),(){
        context.read<CommandProvider>(). disable_all_messages();
      });
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          GestureDetector(
            onTap: () async {

              for (int i = 0 ; i< 10 ;i++){
                await Future.delayed(Duration(seconds: 3)).then((value) {
                  coommunicatewithDevice('%P000000000000030${i}');


                });

              }
    },
            child: Container(
              height: 200,
              width: 200,
              color: Colors.yellow,

              child: Text("send signal"),

            ),
          ),
        ],
      ),
    );
  }




}

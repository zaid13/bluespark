
import 'dart:async';
import 'dart:io';

import 'package:bluespark/billa_ui/ui_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:intl/intl.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../main.dart';
import '../providers/CommandProvider.dart';
import '../src/ui/device_detail/device_interaction_tab.dart';
import '../util/config.dart';
import '../util/functions.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
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

  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  var onTapRecognizer;

  TextEditingController textEditingController = TextEditingController();
// ..text = "123456";

  late StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

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
  void dispose() {
    errorController.close();

    super.dispose();
  }

  @override
  void initState() {


    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>();
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


  callApi(code) async {
    print('jgjfjf');
    var client = new http.Client();
    var VehicleDesciption = '3';
    try {
      //  1A3C
      var tt = await client.get(Uri.http('bluesparkautomotive.com','mapfiles/$code.bsk'));

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


      // print(Mastrerls_SIZE21);

      // for(int i= 0 ; i< 30 ; i++){
      //   List result = getDataforNumber(Mastrerls_SIZE21,i);
      //   print(result);
      // }

      return {"list":Mastrerls_SIZE21,"type":VehicleDesciption};


    }
    finally {
      client.close();
    }

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(    key: scaffoldKey,
        backgroundColor: blackColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(height:MediaQuery.of(context).size.height*0.05),
            Center(child: Image.asset('images/main_screen/logo.png',width: MediaQuery.of(context).size.width*0.7,)),

            Expanded(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ListView(
                    children: <Widget>[
                      SizedBox(height: 30),

                      SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Enter your 4 digit code for configuration',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22,color:Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                        child: RichText(
                          text: TextSpan(
                              text: " ",
                              children: [
                                TextSpan(
                                    text: ' ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                              ],
                              style: TextStyle(color: Colors.black54, fontSize: 15)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Form(
                        key: formKey,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 30),
                            child: PinCodeTextField(
                              appContext: context,
                              pastedTextStyle: TextStyle(
                                color: Colors.green.shade600,
                                fontWeight: FontWeight.bold,
                              ),
                              length: 4,
                              obscureText: false,
                              obscuringCharacter: '*',
                              animationType: AnimationType.fade,
                              validator: (v) {
                                if ((v?.length)! < 4) {
                                  return "There should be 4 characters";
                                } else {
                                  return null;
                                }
                              },
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(5),
                                fieldHeight: 60,
                                fieldWidth: 50,
                                activeFillColor:
                                hasError ? Colors.orange : Colors.white,
                              ),
                              cursorColor: Colors.black,
                              animationDuration: Duration(milliseconds: 300),
                              textStyle: TextStyle(fontSize: 20, height: 1.6),
                              backgroundColor:blackColor,
                              enableActiveFill: true,
                              errorAnimationController: errorController,
                              controller: textEditingController,
                              // keyboardType: TextInputType.number,
                              boxShadows: [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  color: blackColor,
                                  blurRadius: 10,
                                )
                              ],
                              onCompleted: (v) {
                                print("Completed");
                              },
                              // onTap: () {
                              //   print("Pressed");
                              // },
                              onChanged: (value) {
                                print(value);
                                setState(() {
                                  currentText = value;
                                });
                              },
                              beforeTextPaste: (text) {
                                print("Allowing to paste $text");
                                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                return true;
                              },
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Text(
                          hasError ? "*Please fill up all the cells properly" : "",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      SizedBox(
                        height: 14,
                      ),
                      doneButton(),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            child: Text("Clear",style: TextStyle(color:Colors.white),),
                            onPressed: () {
                              textEditingController.clear();
                            },
                          ),

                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),

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
            "Configure",
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 30,
                color: blackColor,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      controller: _btnController,
      onPressed: (){
        setState(() {_btnController.start();});


        formKey.currentState?.validate();
        // conditions for validating
        if (currentText.length != 4 ) {
          errorController.add(ErrorAnimationType
              .shake); // Triggering error shake animation
          setState(() {
            hasError = true;
          });
        } else {
          setState(() async {

            var httpRes =  await callApi(currentText);

            List result =httpRes['list'];
            String deviceType = httpRes['type'].split(',')[0];


            //
            coommunicatewithDevice('%MP1');
            coommunicatewithDevice('%AR$deviceType');

            for (int i = 0 ; i< 30 ;i++){
              await Future.delayed(Duration(milliseconds: 450)).then((value) {
                List raw_packet = getDataforNumber(result,i);
                print("Master Packet");
                var MasterPcket ='%P'+raw_packet.join('')+deviceType;



                print(MasterPcket);
                coommunicatewithDevice(MasterPcket);


              });

            }
            coommunicatewithDevice('%SNDC');
            _btnController.stop();
            hasError = false;
            scaffoldKey.currentState?.showSnackBar(SnackBar(
              content: Text("Aye!!"),
              duration: Duration(seconds: 2),
            ));
          });
        }




      },

    );


  }


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








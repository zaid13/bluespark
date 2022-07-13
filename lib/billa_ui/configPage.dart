
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
import 'package:percent_indicator/percent_indicator.dart';


import '../main.dart';
// import '../providers/CommandProvider.dart';
import '../providers/ConfigProvider.dart';
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

  TextEditingController textEditingController = TextEditingController( );
// ..text = "123456";

  late StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  StreamController<String> NewDatacontroller = StreamController<String>();


  scanAndRespond(String intactString) async {

    print('adding it to daa controller');
    NewDatacontroller.add(intactString);

    // if(intactString.length>0)
    // context.read<ConfigProvider>().keyFound(intactString);


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

  checkEachString(resultString,List <int> resultIntList){

    print('readOutput CONVERTED    ${resultString}');

    print('resultString: $resultIntList  String');


    print(resultString.contains('>'));



    if(resultIntList.last==13){
      print('has last 13');
      resultIntList.removeLast();

      print('readOutput CONVERTED  13  ${resultString}');

      print('resultString 13 : $resultIntList  String');


    }


    var copyResult = resultIntList;

    if(resultIntList.length==0) return ;

    print(resultIntList.first);
    print(resultIntList.last);
    if(resultIntList.first==37  && (resultIntList.last==94)     ){
      print('Complete ');
      print(resultIntList);
      // print(resultString);
      scanAndRespond(String.fromCharCodes(resultIntList).split("\n")[0]);
    }

    else    if((resultIntList.first==37  && resultIntList.last!=94 )){
      print('First Part ');
      PrevDump  = resultIntList;



    }

    else      if(( PrevDump.length>0 && resultIntList.first!=37  && resultIntList.last==94 )){
      // print(PrevDump);
      // print(resultString);





      if (PrevDump.length +resultIntList.length >20){

        PrevDump.removeRange(21-resultIntList.length, PrevDump.length);
        PrevDump  += resultIntList;
        print('string is very long shortenfing it');
        print(PrevDump.length);
        print('PrevDump.length');
        print('resultIntList.length');
        print(resultIntList.length);
        print('20-resultIntList.length');
        print(20-resultIntList.length);


      }else{
        print('string is perdect size');

        PrevDump  += resultIntList;
      }
      resultIntList=[];
      print("FOUND SECOND PART -------------------------------__  ___=-");
      print(PrevDump);
      print(PrevDump.length);

      print(String.fromCharCodes(PrevDump).split('\n'));
      print(String.fromCharCodes(PrevDump).split("\n")[0]);
      scanAndRespond(String.fromCharCodes(PrevDump).split("\n")[0]);
      PrevDump = [];

    }

    //------------------------------



    if(  copyResult.isNotEmpty && copyResult.first==35  && copyResult.last==94    ){
      print('Complete #');
      print(copyResult);
      print(String.fromCharCodes(copyResult).split("\n"));
      scanAndRespond(String.fromCharCodes(copyResult).split("\n")[0]);
    }


    else    if((copyResult.isNotEmpty && copyResult.first==35  && copyResult.last!=94 )){
      print('First Part #');
      PrevDump  = copyResult;



    }

    else      if((PrevDump.length>0 && copyResult.isNotEmpty && copyResult.first!=35  && copyResult.last==94  )){


      PrevDump  += copyResult;
      copyResult=[];
      print("FOUND SECOND PART # -------------------------------_____=-");
      print(PrevDump);

      PrevDump = [];


    }


    else if(PrevDump.length>0 && PrevDump.length<20   && resultIntList.first!=37  &&   resultIntList.last!=94){
      print('ADDING ++++++++++++');

      PrevDump.addAll(copyResult);
    }

  }

  Future<void> subscribeCharacteristic() async {

    subscribeStream =
        widget.subscribeToCharacteristic(widget.characteristic).listen((result) {

          // print('readOutput   ${result}');


          // setState(() {
          // context.read<CommandProvider>().setReadOutput( result.toString());
          List<List<int>> masterList = [];
          List<int> subList = [];

          for (int i in result){
            subList.add(i);
            if(i==13){
              masterList.add(subList);
              subList = [];
            }
          }
          if(subList.length>0){              masterList.add(subList);}




          print('results String :$masterList');
          print('results String length  :${masterList.length}');

          for (List<int> i in masterList)
          {
            String resultStrings = String.fromCharCodes(i);
            print(result);
            print(i);
            print(resultStrings);
            print("LKKKL");

            checkEachString(resultStrings, i);
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



    print(widget.viewModel.connectionStatus);

    if(DeviceConnectionState.disconnected ==widget.viewModel.connectionStatus ){
      restartApp();

    }

  }


  callApi(code) async {
    print('jgjfjf');
    var client = new http.Client();
    var VehicleDesciption = '3';
    try {
      //  1A3C
      print('getting url -$code-');
      var tt = await client.get(Uri.http('bluesparkautomotive.com','mapfiles/$code.bsk'));
      print('url got ');

      List<String> ls = (tt.body).split('\n');
      int counter =0;
      List Mastrerls_SIZE21= [];
      NumberFormat formatter = new NumberFormat("00");

      for (String i in ls) {
        counter++;
        if(counter==2){

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
              NewLsit.add(int.parse(j.replaceFirst('\r', '')).toRadixString(16).toUpperCase());

            }
            else if(int.parse(j.replaceFirst('\r', '').replaceFirst('\'', ''))<10){

              NewLsit.add((formatter.format( int.parse(j.replaceFirst('\r', '')))).toString().toUpperCase());

            }
            else{

              NewLsit.add((int.parse(j.replaceFirst('\r', '')).toRadixString(16).toUpperCase()).toString().padLeft(2,'0'));

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
                      ),
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: new LinearPercentIndicator(
                          width: MediaQuery.of(context).size.width - 50,
                          animation: false,
                          lineHeight: 20.0,
                          animationDuration: 2500,

                          percent: context.watch<ConfigProvider>().getPercentageOFVerifiedPackets(),
                          center: Text("${(context.watch<ConfigProvider>().getPercentageOFVerifiedPackets()*100).toStringAsFixed(1)} %",style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold)),
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          progressColor: Colors.green,
                        ),
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
  Future<bool> doConfiguration() async {
    var httpRes = await callApi(currentText);
    bool success = true;

    List result = httpRes['list'];
    String deviceType = httpRes['type'].split(',')[0];
    context.read<ConfigProvider>().freshMap();


    //


    List masterPacketsList = ['%MP1'];
    List responsePacketsList = ['%MPROG1^'];

    masterPacketsList.add('%AR$deviceType');
    responsePacketsList.add('#AR$deviceType^');



  for (int i = 0 ; i< 30 ;i++){

  List raw_packet = getDataforNumber(result,i);
  // print("Master Packet");
  final myInteger = i;
  var hexString = myInteger.toRadixString(16);

  if(i<=16){
     hexString = hexString.padLeft(2, '0');
  }
  // print('hexString');
  // print(hexString);
  // print('hexString');


  var MasterPcket ='%P'+hexString.toUpperCase()+raw_packet.join('');

  masterPacketsList.add(MasterPcket);
  responsePacketsList.add(MasterPcket+'^');

  // if(!success) break;


  }



    masterPacketsList.add('%SNDC');
    responsePacketsList.add('#EPRMC'+'^');

    print('masterPacketsList');
    print(masterPacketsList);

   await sendDataToChip(masterPacketsList,responsePacketsList);


    return success;

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
      onPressed: () async {
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

          print('configuring');
          try{
            bool isError =       await doConfiguration();

          }
          catch(c){
            print(c);
            switchOffSendingButtonState('ERROR 1');
          }



        }




      },

    );


  }



  switchOffSendingButtonState(text){
    setState(()  {
      _btnController.stop();
      hasError = false;
      scaffoldKey.currentState?.showSnackBar(SnackBar(
        content: Text(text),
        duration: Duration(seconds: 2),
      ));
    });
  }

  sendDataToChip(List data,List results) async{


    Stream stream = NewDatacontroller.stream;




    coommunicatewithDevice(data[0]);
    int totalPacketSent = 1;

   StreamSubscription subscribeStream=  stream.listen((value) {
      if(totalPacketSent<data.length) {
        print('Expected value   : ${results[totalPacketSent - 1]}');
        print('Value from device: $value');
      }

      if(data.length+1 == totalPacketSent){return;}

      if(value.toString().trim() == (results[totalPacketSent-1]).toString().trim()  &&  totalPacketSent<=data.length) {

        if(totalPacketSent<data.length) {
          coommunicatewithDevice(data[totalPacketSent]);
        }
        context.read<ConfigProvider>().updatePercentageOFVerifiedPackets(totalPacketSent);
        totalPacketSent++;


        print('length of total packets ${data.length}');
        print('Confirmations recieved  ${totalPacketSent}');

        if(data.length+1 == totalPacketSent){

          print('SUCCESS');
          switchOffSendingButtonState('SUCCESS');

        }

      }
    });

   Future.delayed(Duration(seconds:17),(){
     switchOffSendingButtonState('Time out');
     subscribeStream.cancel();

   });



  }


}
getDataforNumber(Mastrerls_SIZE21,int number){
  List lst = [];

  for (int i = 7*(number%3) ; i<(7*(number%3))+7; i++ ){
    // print((number/3).toInt());
    print(i);
    print(Mastrerls_SIZE21[i][(number/3).toInt()]);
    lst.add(Mastrerls_SIZE21[i][(number/3).toInt()]);
  }
  return  lst;

}








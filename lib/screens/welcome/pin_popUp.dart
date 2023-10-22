
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/CommandProvider.dart';
import '../../providers/SendProvider.dart';
import '../../providers/box_storage.dart';
import '../../util/config.dart';
import '../SplashScreen.dart';
import '../ui_strings.dart';
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:pin_code_fields/pin_code_fields.dart';





class PinCodeVerificationScreen extends StatefulWidget {
  final String? phoneNumber;


  const PinCodeVerificationScreen({
    Key? key,
    this.phoneNumber,
  }) : super(key: key);

  @override
  _PinCodeVerificationScreenState createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController nameEditingController = TextEditingController( );
  // ..text = "123456";
  StreamController<bool> streamController = StreamController();

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    streamController.sink.add(true);
    Future.delayed(Duration(seconds: 3),(){
      if(!streamController.isClosed)
      streamController.sink.add(false);
print('false added');
    });
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
     streamController.close();
    super.dispose();
  }

  // snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: streamController.stream,
      builder: (context, snapshot) {
        print('date ${snapshot.data}');
        if(snapshot.data!=null) {
          bool isSplash= snapshot.data??false;
          return Container(
              child:isSplash?SplashWidget():WillPopScope(
                onWillPop: () async => true,
                child: Scaffold(
                  backgroundColor: blackColor,
                  body: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: ListView(
                      children: <Widget>[
                        const SizedBox(height: 40),
                        Center(
                            child: Image.asset(
                              'images/main_screen/logo.png',
                              width: MediaQuery.of(context).size.width * 0.7,
                            )),
                        const SizedBox(height: 8),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Pin Number Verification',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30,color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(
                          height: 40,
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(

                                  decoration: InputDecoration(
                                    labelText: 'Enter Vehicle Description',

                                    hintText: 'eg. BMW M4 Comp 2023',
                                    labelStyle: TextStyle(color: Colors.white),

                                    hintStyle: TextStyle(color: Colors.white),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(4)),
                                      borderSide: BorderSide(width: 1,color: Colors.blue),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(4)),
                                      borderSide: BorderSide(width: 1,color: Colors.orange),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(4)),
                                      borderSide: BorderSide(width: 1,color: Colors.white),
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(4)),
                                        borderSide: BorderSide(width: 1,)
                                    ),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(4)),
                                        borderSide: BorderSide(width: 1,color: Colors.black)
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(4)),
                                        borderSide: BorderSide(width: 1,color: Colors.yellowAccent)
                                    ),

                                  ),

                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),

                                  controller: nameEditingController,

                                  textInputAction: TextInputAction.next ,
                                  autofocus: true,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(height: 10,),
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
                                  child: RichText(
                                    text: TextSpan(
                                        text: "Enter Pin",

                                        style:
                                        const TextStyle(color: Colors.white, fontSize: 15)),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Container(height: 10,
                                ),

                                PinCodeTextField(
                                  appContext: context,
                                  pastedTextStyle: TextStyle(
                                    color: Colors.green.shade600,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  length: 4,

                                  obscureText: false,
                                  obscuringCharacter: '*',
                                  blinkWhenObscuring: false,
                                  animationType: AnimationType.fade,
                                  validator: (v) {
                                    if (v!.length < 3) {
                                      return "please enter 4 digit code";
                                    } else {
                                      return null;
                                    }
                                  },
                                  pinTheme: PinTheme(
                                      shape: PinCodeFieldShape.box,
                                      borderRadius: BorderRadius.circular(5),
                                      fieldHeight: 50,
                                      fieldWidth: 40,
                                      activeFillColor: Colors.white,
                                      selectedColor: Colors.transparent,

                                      selectedFillColor: Colors.blue,
                                      inactiveFillColor:Colors.blue,
                                      inactiveColor:Colors.blue
                                  ),
                                  cursorColor: Colors.black,
                                  animationDuration: const Duration(milliseconds: 300),
                                  enableActiveFill: true,
                                  errorAnimationController: errorController,
                                  controller: textEditingController,
                                  keyboardType: TextInputType.number,
                                  boxShadows: const [
                                    BoxShadow(
                                      offset: Offset(0, 1),
                                      color: Colors.black12,
                                      blurRadius: 10,
                                    )
                                  ],
                                  onCompleted: (v) {
                                    debugPrint("Completed");
                                  },
                                  // onTap: () {
                                  //   print("Pressed");
                                  // },
                                  onChanged: (value) {
                                    debugPrint(value);
                                    setState(() {
                                      currentText = value;
                                    });
                                  },
                                  beforeTextPaste: (text) {
                                    debugPrint("Allowing to paste $text");
                                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                    return true;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Text(
                            hasError ? "*Please fill up all the cells properly" : "",
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                        ),

                        const SizedBox(
                          height: 14,
                        ),
                        Container(
                          margin:
                          const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                          child: ButtonTheme(
                            height: 50,
                            child: TextButton(
                              onPressed: () async {
                                formKey.currentState!.validate();
                                // conditions for validating  currentText.length != 6 || currentText != "123456"

                                if(nameEditingController.value.text.isEmpty){
                                  final snackBar = SnackBar(
                                    content: const Text('Description is empty'),
                                    duration: Duration(seconds: 3),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar,);
                                  return;
                                }
                                if (false) {
                                  errorController!.add(ErrorAnimationType
                                      .shake); // Triggering error shake animation
                                  setState(() => hasError = true);
                                } else {

                                  errorController!.add(ErrorAnimationType
                                      .shake); // Triggering error shake animation

                                  lastPasswordSent = currentText;
                                  nickName = nameEditingController.value.text;


                                  context.read<SendProvider>().sendData(passwordString+currentText);

                                  await  context.read<SendProvider>().readDate();

                                  Future.delayed(Duration(seconds: 1),(){
                                    setState(() => hasError = true);
                                  });

                                  // setState(
                                  //       () {
                                  //     hasError = false;
                                  //     snackBar("OTP Verified!!");
                                  //   },
                                  // );
                                }
                              },
                              child: Center(
                                  child: Text(
                                    "VERIFY".toUpperCase(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.blue,
                                    offset: const Offset(1, -2),
                                    blurRadius: 5),
                                BoxShadow(
                                    color: Colors.blue,
                                    offset: const Offset(-1, 2),
                                    blurRadius: 5)
                              ]),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextButton(
                          child: const Text("Contact Us",style: TextStyle(color: Colors.white),),
                          onPressed: () {





                            //  textEditingController.clear();
                          },
                        )
                      ],
                    ),
                  ),
                ),
              )
          );
        }

       return SplashWidget();
      }
    );
  }
}
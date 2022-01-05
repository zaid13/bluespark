import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
class Welcome1 extends StatefulWidget {
  const Welcome1({Key? key}) : super(key: key);

  @override
  _Welcome1State createState() => _Welcome1State();
}

class _Welcome1State extends State<Welcome1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Stack(

        children: [
        Container(
            alignment: Alignment.center,
            width: 360,
            height: 250,
            child: Text("Welcome",style: TextStyle(fontSize: 34,fontFamily: "Brand Bold",color: Colors.white),)),
          SlidingUpPanel(
            color: Colors.blue,
          panel: Column(
            children: [
              Container(
                  alignment: Alignment.center,
                width: 230,
                height: 40,
                  child:Text('Cold Start Delay', style: TextStyle(fontSize: 20.0,color: Colors.white),)
              ),

              Row(
                children: [
                  Container(
                      alignment: Alignment.center,
                      width: 360,

                      child: Text('Active', style: TextStyle(fontSize: 20.0,color: Colors.white),)),
                ],
              ),
              Stack(
                  children: <Widget>[
                    Image.asset('images/Welcome/Ellipse.png'),
                    Container(
                        height: 340,
                        child: Center(child: Text("00:27:47",style: TextStyle(color:Colors.white,fontSize: 30),))),
                        Container(
                          height: 390,
                            child: Center(child: Text("Remaining",style: TextStyle(color:Colors.white,fontSize: 20),))),
                  ]
              ),


              Center(
                child: Container(
                  width: 130,
                  height: 40,
                  child: FlatButton(
                    child: Text('SKIP', style: TextStyle(fontSize: 20.0),),
                    color: Colors.black,
                    textColor: Colors.white,
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          )
          )
        ],
      ),
    );
  }
}

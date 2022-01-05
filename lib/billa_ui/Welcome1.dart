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
            child: Text("Welcome",

              style: TextStyle(fontFamily: 'Montserrat',fontSize: 34,color: Colors.white,fontWeight:FontWeight.bold),)),
          SlidingUpPanel(
              maxHeight:MediaQuery.of(context).size.height *0.65,
            color: Colors.blue,
          panel: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Container(
                  alignment: Alignment.center,
                width: 230,
                height: 40,
                  child:Text('Cold Start Delay',
                    style: TextStyle(fontFamily: 'Montserrat',fontSize: 30,color: Colors.white,fontWeight:FontWeight.bold),),

            // style: TextStyle(fontSize: 20.0,color: Colors.white),)
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.circle,color: Colors.green,size: 20,),
                  Container(width: 5,),
                  Text('ACTIVE',
                    style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,color: Colors.white,fontWeight:FontWeight.bold),),
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

                  decoration: new BoxDecoration(
                      color: Colors.black,
                      borderRadius: new BorderRadius.all( Radius.circular(10.0))
                  ),
                  height: 40,
                  child: FlatButton(
                    child: Text('SKIP', style: TextStyle(fontSize: 20.0),),
                    textColor: Colors.white,
                    onPressed: () {},
                  ),
                ),
              ),
              Container(height: 10,)
            ],
          )
          )
        ],
      ),
    );
  }
}

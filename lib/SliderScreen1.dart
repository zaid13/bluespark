import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
class Slider1 extends StatefulWidget {
  const Slider1({Key? key}) : super(key: key);

  @override
  _Slider1State createState() => _Slider1State();
}

class _Slider1State extends State<Slider1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.black,

      body: Stack(

        children: [

          Drawer(
            elevation: 16.0,
            child: Container(
              color: Colors.blue,
              child: Column(
                children: <Widget>[

                Container(
                  height: 200,
                ),
                  ListTile(
                    title: new Text("Step Guide",style: TextStyle(color: Colors.white),),

                  ),
                  Divider(
                    height: 0.1,
                  ),
                  ListTile(
                    title: new Text("User Guide",style: TextStyle(color: Colors.white),),

                  ),
                  ListTile(
                    title: new Text("Using the Bypass Plug",style: TextStyle(color: Colors.white),),

                  ),
                  ListTile(
                    title: new Text("Safety Information",style: TextStyle(color: Colors.white),),

                  ),
                  ListTile(
                    title: new Text("App Information",style: TextStyle(color: Colors.white),),

                  ),
                  ListTile(
                    title: new Text("Contact BLUESPARK",style: TextStyle(color: Colors.white),),

                  ),
                  Container(
                    height: 30,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: Icon(Icons.close),
                  ),
                  Container(
                    height: 10,
                  ),
                  Text('Close',style: TextStyle(fontSize: 15,color: Colors.white),)
                ],
              ),
            ),
          ),
        ],
    ),

    );
  }
}

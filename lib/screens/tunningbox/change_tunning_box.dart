

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import '../../models/BoxModel.dart';
import '../../providers/box_storage.dart';
import '../../providers/deviceConnector.dart';
import '../../src/ui/device_detail/device_interaction_tab.dart';
import '../../util/functions.dart';
import '../ui_strings.dart';

class ChangeTunningBox extends StatefulWidget {

  DeviceInteractionViewModel viewModel;

   ChangeTunningBox(this.viewModel,   {Key? key}) : super(key: key);

  @override
  State<ChangeTunningBox> createState() => _ChangeTunningBoxState();
}

class _ChangeTunningBoxState extends State<ChangeTunningBox> {


  int key = 0;

  @override
  Widget build(BuildContext context) {

    Widget _editDialog(BuildContext context, String heading, mywidget,Box_Model box) {
      TextEditingController txtCtrl = TextEditingController(text: box.nick_name);
      return AlertDialog(
        title: Text(heading),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller:txtCtrl ,
                autofocus: true,

              ),

            ],
          ),
        ),
        actions: <Widget>[

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              //     textColor: Theme.of(context).primaryColor,
              child: const Text('No',style: TextStyle(fontSize: 20),),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () async {
                await BoxStorage.updateBoxWithId(box.mac_address, txtCtrl.value.text);

                setState(() {
                  key=key+1;
                });
                Navigator.of(context).pop();
              },
              //     textColor: Theme.of(context).primaryColor,
              child: const Text('Yes',style: TextStyle(fontSize: 20)),
            ),
          ),

        ],
      );
    }

    Widget _deleteDialog(BuildContext context, String heading, mywidget,Box_Model box) {

      return AlertDialog(
        title: Text(heading),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[


            ],
          ),
        ),
        actions: <Widget>[

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              //     textColor: Theme.of(context).primaryColor,
              child: const Text('No',style: TextStyle(fontSize: 20),),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () async {
                print("box.mac_address to delete");
                print(box.mac_address);
                await BoxStorage.deleteBoxWithId(box.mac_address, );
                if(box.isConnected){
                  widget.viewModel.disconnect();

                  restartApp();
                } else
                {
                  setState(() {
                    key=key+1;
                  });
                  Navigator.of(context).pop();}



              },
              //     textColor: Theme.of(context).primaryColor,
              child: const Text('Yes',style: TextStyle(fontSize: 20)),
            ),
          ),

        ],
      );
    }

    getTile(Box_Model box){
        print('box.mac_address');
        print(box.mac_address);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[500]),

          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Expanded(
                child: Row(children: [
                  box.isConnected?Icon(Icons.check_circle,color: Colors.green,size: 30,)
                      :Icon(Icons.circle_outlined,color: Colors.redAccent,size: 30,),
                  Container(width: 10,),

                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(box.nick_name,style: TextStyle(color: Colors.white,fontSize: 25),),
                        Text('MAC: '+box.mac_address,style: TextStyle(color: Colors.white,fontSize: 11),),



                      ],),
                  )
                  ],




                ),
              ),


              Row(
                children: [
                  GestureDetector(
                      onTap:(){
                        showDialog(context: context, builder: (context) =>  _editDialog(
                            context, "Are you sure to change the name of tuning box?",Container(),box),);


                        print('edit');},
                      child: Icon(Icons.edit,color: Colors.white,)),
                  Container(width: 10,),
                  GestureDetector
                    (
                      onTap: (){
                        showDialog(context: context, builder: (context) =>  _deleteDialog(
                            context, "Are you sure to delete the tuning box ${box.nick_name} ?",Container(),box),);


                     print('delete');
                      },
                      child: Icon(Icons.delete,color: Colors.white,)),
                ],
              )

            ],
        ),
          ),),
      );
    }
    Widget _buildAboutDialog(BuildContext context, String heading, mywidget) {
      return AlertDialog(
        title: Text(heading),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              mywidget,

            ],
          ),
        ),
        actions: <Widget>[

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              //     textColor: Theme.of(context).primaryColor,
              child: const Text('No',style: TextStyle(fontSize: 20),),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () async {
               await BoxStorage.disconnect_allBoxes();

               widget.viewModel.disconnect();


               restartApp();
                // Navigator.of(context).pop();
              },
              //     textColor: Theme.of(context).primaryColor,
              child: const Text('Yes',style: TextStyle(fontSize: 20)),
            ),
          ),

        ],
      );
    }

    return  SafeArea(child: Scaffold(
      backgroundColor: blackColor,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,color: Colors.white,),
        backgroundColor: Colors.blue,
        onPressed: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) => _buildAboutDialog(
                context, "Are you sure to change the current tuning box?",Container())
          );
          // await  BoxStorage.disconnect_allBoxes();
          //
          // restartApp();

        },

      ),

      body: Column(
        children: [
          const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              "Change Tuning Box",
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),

         Expanded(
           child: FutureBuilder<List>(
             key: ValueKey<int>(key),
             future:BoxStorage.updateConnectedBoxReturnAllBoxes(widget.viewModel.deviceId) ,
               builder: (ctx,data){

             if(data.hasData){
               List? allBoxes = data.data;
               return  ListView.builder(
                 itemCount: allBoxes!.length,
                 itemBuilder: (context, index) => getTile( allBoxes[index]) , );
             }
             else{
               return Container();
             }


           }),
         )


        ],
      ),
    ));
  }
}

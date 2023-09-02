


Map<String,String> mapsArray = {        '0':'230',
                                        "0":"%MAP_0\n",
                                        "A":"%MAP_1\n",
                                        "B":"%MAP_2\n",
                                        "C":"%MAP_3\n",
                                        "D":"%MAP_4\n",
                                        "E":"%MAP_5\n" }  ;
List<String> scalerArray =  [
                              "%SCA_0\n",
                              "%SCA_1\n",
                              "%SCA_2\n",
                              "%SCA_3\n",
                              "%SCA_4\n",
                              "%SCA_5\n",
                              "%SCA_6\n",
                              "%SCA_7\n",
                              "%SCA_8\n",
                              "%SCA_9\n",


                              ];

String RequiredServiceId = "0000ffe0-0000-1000-8000-00805f9b34fb";
String RequiredCharacteristicId = "0000ffe1-0000-1000-8000-00805f9b34fb";


Map<String,String> scallerMapperErrorTable = {
  "#ERR_01#":"Reduce Load to change Map",
  "#ERR_02#":"Load Too High to change Scaler",
  "C":"233",
  "D":"234",
  "E":"235" }  ;

String GetScallerCode = "%DIP_?\n";
String GetMapperCode = "%JUM_?\n";
String GetDviceType = "%DEV_?";
String GetWaitTime = "%WUT_?";
String endTimerMSG = "%SKIP\n";
String passwordString = "%PWD";
String resPasswordString = "#PWD";



void log(String text) => print("[FlutterReactiveBLEApp] $text");

List<String> KnownDeviceList = ["BT05","TUNINGBOX","HM-10"];

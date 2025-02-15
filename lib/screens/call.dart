import 'dart:collection';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/src/provider.dart';
import 'package:roccabox_agent/agora/audioCall/audioCallMain.dart';
import 'package:roccabox_agent/agora/dialscreen/dialScreen.dart';
import 'package:roccabox_agent/agora/videoCall/videoCall.dart';
import 'package:roccabox_agent/screens/notificationindex.dart';
import 'package:roccabox_agent/screens/notifications.dart';
import 'package:roccabox_agent/services/APIClient.dart';
import 'package:roccabox_agent/services/modelProvider.dart';
import 'package:roccabox_agent/util/customDialoge.dart';
import 'package:roccabox_agent/util/languagecheck.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import 'chat.dart';

class Calls extends StatefulWidget {
  @override
  _CallState createState() => _CallState();
}

class _CallState extends State<Calls> {
  String notiCount = "0";
  AsyncSnapshot<QuerySnapshot>? snapshot;
  List<QueryDocumentSnapshot> listUsers = new List.from([]);
  final firestoreInstance = FirebaseFirestore.instance;
  List<UserList> listUser = [];
  List<UserList> listUserrev = [];
  var id ;
  var myName ;
  var myImage ;
  FirebaseMessaging? auth;
  var myFcm;
  @override
  void initState() {
    getData();

    auth = FirebaseMessaging.instance;
    auth?.getToken().then((value) {
      print("FirebaseToken " + value.toString());
      myFcm = value.toString();
    }
    );
    WidgetsBinding.instance!
        .addObserver(LifecycleEventHandler(resumeCallBack: () async {
      print("Invoke");
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Notificationcoutn " + notiCount + "");
    LanguageChange languageChange = new LanguageChange();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffFFFFFF),
          elevation: 0,
          centerTitle: true,
          title: Text(
            // Call
            languageChange.CALL[langCount],
            style: TextStyle(
                fontSize: 16,
                color: Color(0xff000000),
                fontWeight: FontWeight.w600),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10, top: 5),
              child: InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationIndex()));
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      height: 46,
                      width: 46,
                      decoration: BoxDecoration(
                        color: Color(0xFF979797).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        "assets/Bell.svg",
                        color: Colors.black54,
                      ),
                    ),
                    Count()
                  ],
                ),
              ),
            ),
          ],
        ),
        body: id != null
            ? StreamBuilder<QuerySnapshot>(
                stream: firestoreInstance
                    .collection("call_master")
                    .doc("call_head")
                    .collection(id)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    listUser.clear();
                    listUserrev.clear();
                    snapshot.data?.docs.forEach((element) {
                      var json;
                      UserList model = new UserList();
                      model.id = element.id.toString();

                      print("StreamId " + element.id);
                      json = element.data();
                      print("StreamName " + json["name"].toString());
                      print("StreamImage " + element.get("image").toString());
                      model.name = json["name"].toString();
                      model.image = json["image"].toString();
                      model.id = json["id"].toString();
                      model.timestamp = json["timestamp"].toString();
                      model.fcmToken = json["fcmToken"].toString();
                      model.timestamp = json["timestamp"].toString();
                      model.chatType = json["chatType"].toString();

                      listUserrev.add(model);
                    });
                    listUser = listUserrev.reversed.toList();
                  }

                  return ListView.separated(
                    itemCount: listUser.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        color: Color(0xff707070),
                      );
                    },
                    itemBuilder: (BuildContext context, int index) {
                      var dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(listUser[index].timestamp.toString()));
                      String formattedDate = DateFormat('dd-MM-yyyy – kk:mm').format(dateTime);
                      return ListTile(
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                getAccessToken(listUser[index].id.toString(), "VOICE",listUser[index].chatType=="agent-admin"?"admin":"user");
                                },
                                icon: Icon(
                                  Icons.phone,
                                  color: Colors.black,
                                )),
                            IconButton(
                                onPressed: () {
                                  getAccessToken(listUser[index].id.toString(), "VIDEO",listUser[index].chatType=="agent-admin"?"admin":"user");

                                },
                                icon: Icon(
                                  Icons.videocam_rounded,
                                  color: Colors.black,
                                ))
                          ],
                        ),
                        leading:listUser[index].image==null || listUser[index].image=="" ? CircleAvatar(
                          backgroundImage: AssetImage('assets/img1.png'),
                        ):CircleAvatar(backgroundImage: NetworkImage(listUser[index].image.toString() )),
                        title: Text(
                          listUser == null ? "" : listUser[index].name == null
                              ? ""
                              : listUser[index].name.toString(),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff000000)),
                        ),
                        subtitle: Text(
                          listUser == null ? "" : listUser[index].timestamp == null
                              ? ""
                              : formattedDate.toString(),
                          style:
                              TextStyle(fontSize: 12, color: Color(0xff818181)),
                        ),
                      );
                    },
                  );
                })
            : Text("No Data Found"));
  }

  void getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    id = pref.getString("id").toString();
    myName = pref.getString("name").toString();
    myImage = pref.getString("image").toString();
    notiCount = pref.getString("notify")!;
    setState(() {});
  }




  Future<dynamic> getAccessToken(String id, String type, String ChatType) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    var userid = pref.getString("id");
    var authToken = pref.getString("auth_token").toString();
    print("AUTH_TOKEN "+authToken.toString());
    Map<String, String> mapheaders = new HashMap();
    mapheaders["Authorization"] = authToken.toString();

    print("user_id "+userid.toString());
    // print(email)
        ;
    var jsonRes;
    http.Response? res;
    var request = http.post(Uri.parse(RestDatasource.AGORATOKEN),
        headers: mapheaders,
        body: {

          "type": type,
          "user_id": userid.toString(),
          "receiver_id": id,
          "time": DateTime.now().millisecondsSinceEpoch.toString(),
          "channelKey": ChatType=="agent-admin"?"key_admin":"key_user",
          "id": "10",
          "click_action": 'FLUTTER_NOTIFICATION_CLICK',
          "chName":ChatType=="agent-admin"?"admin_channel":"user_channel",
        });

    await request.then((http.Response response) {
      res = response;

      // msg = jsonRes["message"].toString();
      // getotp = jsonRes["otp"];
      // print(getotp.toString() + '123');t
    });
    if (res!.statusCode == 200) {
      final JsonDecoder _decoder = new JsonDecoder();
      jsonRes = _decoder.convert(res!.body.toString());
      print("Response: " + res!.body.toString() + "_");
      print("ResponseJSON: " + jsonRes.toString() + "_");


      if(jsonRes["status"]==true){
        var agoraToken = jsonRes["agora_token"].toString();
        var channel = jsonRes["channelName"].toString();
        var name = jsonRes["receiver"]["name"].toString();
        var image = jsonRes["receiver"]["image"].toString();
        var time = jsonRes["time"].toString();
        var fcm = jsonRes["receiver"]["firebase_token"].toString();
        updateChatHead(userid.toString(),name, image, type, fcm, id, "Calling", agoraToken, channel, time);

      }else{
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(jsonRes["message"].toString())));
          if(jsonRes["code"]!=null){
            if(jsonRes["code"]==403){
              showLogoutDialog(context);
            }
          }
        });
      }

    } else {

    }
  }



  void updateChatHead(String userid, String name, String image, String type, String fcmToken,String idd, String status, String agoraToken, String channel, String time) async {

    var documentReference = FirebaseFirestore.instance
        .collection('call_master')
        .doc("call_head")
        .collection(userid)
        .doc(time);


    firestoreInstance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        {
          'fcmToken': fcmToken,
          'id': idd,
          'image': image,
          'name': name,
          'timestamp': time,
          'type': type,
          'callType':"incoming",
          'status': status

        },
      );
    }).then((value) {
      var documentReference = FirebaseFirestore.instance
          .collection('call_master')
          .doc("call_head")
          .collection(idd)
          .doc(time);

      firestoreInstance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'fcmToken': myFcm,
            'id': userid,
            'image': myImage,
            'name': myName,
            'timestamp': time,
            'type': type,
            'callType':"outgoing",
            'status':status
          },
        );
      });
    });
    if(type=="VIDEO"){
      Navigator.push(context, new MaterialPageRoute(builder: (context)=> VideoCall(name:name ,image:image, channel: channel, token: agoraToken, myId: userid.toString(),time: time, senderId: idd,)));

    }else{
      Navigator.push(context, new MaterialPageRoute(builder: (context)=> DialScreen(name:name ,image:image, channel: channel, agoraToken: agoraToken,myId: userid.toString(),time: time,receiverId: idd,)));

    }
  }
}

class Count extends StatelessWidget {
  const Count({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var count = '${context.watch<Counter>().count}';

    return Visibility(
      visible: count.toString() == "0" ? false : true,
      child: Positioned(
        top: -3,
        right: 0,
        child: Container(
          height: 16,
          width: 16,
          decoration: BoxDecoration(
            color: Color(0xFFFF4848),
            shape: BoxShape.circle,
            border: Border.all(width: 1.5, color: Colors.white),
          ),
          child: Center(
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 10,
                height: 1,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }



}

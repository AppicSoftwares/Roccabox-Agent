import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:roccabox_agent/agora/dialscreen/dialScreen.dart';
import 'package:roccabox_agent/agora/videoCall/videoCall.dart';
import 'package:roccabox_agent/screens/chatscreen.dart';
import 'package:roccabox_agent/screens/user_Detail.dart';
import 'package:http/http.dart' as http;
import 'package:roccabox_agent/services/APIClient.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Setting.dart';

class AssignedUsersScreen extends StatefulWidget {
List<TotalUserList> totalUserList = [];

AssignedUsersScreen({Key? key,  required this.totalUserList})
      : super(key: key);



  @override
  State<AssignedUsersScreen> createState() => _TotalUserScreenState();
}

class _TotalUserScreenState extends State<AssignedUsersScreen> {

  bool isloading = false;
  final firestoreInstance = FirebaseFirestore.instance;
  var myimage = "";
  var myname = "";
  var myFcm = "";
  FirebaseMessaging? auth;



  @override
  void initState() {

    super.initState();
    auth = FirebaseMessaging.instance;
    auth?.getToken().then((value) {
      print("FirebaseToken " + value.toString());
      myFcm = value.toString();
    }
    );
  }
  @override
  Widget build(BuildContext context) {
    print(widget.totalUserList.length.toString());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFFFFFF),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Assigned Users',
          style: TextStyle(
              fontSize: 16,
              color: Color(0xff000000),
              fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView.separated(
        itemCount: widget.totalUserList.length,
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: Color(0xff707070),
          );
        },
        itemBuilder: (BuildContext context, int index) {
          print("Imagee "+widget.totalUserList[index].image.toString());
          return ListTile(
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => UserDetails(
                  P_Agency_FilterId: widget.totalUserList[index].filter_id,
                  totalUserList: widget.totalUserList[index],
                ))),
            leading:  widget.totalUserList[index].image.toString() == "null"
                                    ? Image.asset(
                                        'assets/avatar.png',
                                      )
                                    : CircleAvatar(
                                      radius: 30,
                                        backgroundImage: NetworkImage(widget.totalUserList[index].image),
                                      ),
            title: Text(
              widget.totalUserList[index].name,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff000000)),
            ),
            subtitle: Text(
              widget.totalUserList[index].message,
              style: TextStyle(fontSize: 12, color: Color(0xff818181)),
            ),
            trailing: SizedBox(
              width: 115,
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        getAccessToken(widget.totalUserList[index].userId.toString(), "VOICE");

                      },
                      child: Icon(Icons.call, color: Colors.black,size: 24)),
                  SizedBox(width: 20,),
                  GestureDetector(
                      onTap: (){

                        getAccessToken(widget.totalUserList[index].userId.toString(), "VIDEO");
                      },
                      child: Icon(Icons.video_call, color: Colors.black,size: 24)),

                  SizedBox(width: 20,),
                  GestureDetector(
                      onTap: () async {
                        SharedPreferences pref = await SharedPreferences.getInstance();
                        var id = pref.getString("id");
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(senderId:id, receiverId: widget.totalUserList[index].userId, name:  widget.totalUserList[index].name, image: widget.totalUserList[index].image,fcmToken: widget.totalUserList[index].firebase_token,)));
                      },
                      child: Icon(Icons.chat, color: Colors.black,size: 24)),
                ],
              ),
            ),
          );
        },
      ),
    );
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
            'image': myimage,
            'name': myname,
            'timestamp': time,
            'type': type,
            'callType':"outgoing",
            'status':status
          },
        );
      });
    });
    if(type=="VIDEO"){
      Navigator.push(context, new MaterialPageRoute(builder: (context)=> VideoCall(name:name ,image:image, channel: channel, token: agoraToken, myId: userid.toString(),time:time, senderId: idd,)));

    }else{
      Navigator.push(context, new MaterialPageRoute(builder: (context)=> DialScreen(name:name ,image:image, channel: channel, agoraToken: agoraToken,myId: userid.toString(),time: time )));

    }
  }




  Future<dynamic> getAccessToken(String id, String type) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userid = pref.getString("id");

    print("user_id "+userid.toString());
    // print(email)
        ;
    var jsonRes;
    http.Response? res;
    var request = http.post(Uri.parse(RestDatasource.AGORATOKEN),
        body: {

          "type": type,
          "user_id": userid.toString(),
          "receiver_id": id,
          "time":DateTime.now().millisecondsSinceEpoch.toString()


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

      }

    } else {

    }
  }

}
import 'dart:collection';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:roccabox_agent/screens/chatscreen.dart';
import 'package:roccabox_agent/services/APIClient.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../agora/dialscreen/dialScreen.dart';
import '../agora/videoCall/videoCall.dart';
import '../util/customDialoge.dart';




class AssignedUser extends StatefulWidget {
  List<UserModel> userModelList = [];
  AssignedUser({ Key? key, required this.userModelList }) : super(key: key);

  @override
  _AssignedUserState createState() => _AssignedUserState();
}

class _AssignedUserState extends State<AssignedUser> {
  bool isloading = false;
  bool isPressed = false;
  final firestoreInstance = FirebaseFirestore.instance;
  var myimage = "";
  var myname = "";
  var myFcm = "";
  
  @override
  void initState() {
    super.initState();
   
  }






  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          color: Colors.black,
        ),
        backgroundColor: Color(0xffFFFFFF),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Assigned User',
          style: TextStyle(
              fontSize: 16,
              color: Color(0xff000000),
              fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView.separated(
        itemCount: widget.userModelList.length,
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: Color(0xff707070),
          );
        },
        itemBuilder: (BuildContext context, int index) {
          print("Imagee "+widget.userModelList[index].image.toString());
          return ListTile(
            // onTap: () => Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => UserDetails(
            //       P_Agency_FilterId: widget.totalUserList[index].filter_id,
            //       totalUserList: widget.totalUserList[index],
            //     ))),
            leading: widget.userModelList[index].image.toString() == "null"
                                    ? Image.asset(
                                        'assets/avatar.png',
                                      )
                                    : CircleAvatar(
                                      radius: 30,
                                        backgroundImage: NetworkImage(widget.userModelList[index].image),
                                      ),
            title: Text(
              widget.userModelList[index].name,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff000000)),
            ),
            // subtitle: Text(
            //   widget.userModelList[index].message,
            //   style: TextStyle(fontSize: 12, color: Color(0xff818181)),
            // ),
            trailing: SizedBox(
              width: 115,
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {

                        if(!isPressed) {
                          getAccessToken(widget.userModelList[index].id
                              .toString(), "VOICE");

                        }
                      },
                      child: Icon(Icons.call, color: Colors.black,size: 24)),
                  SizedBox(width: 20,),
                  GestureDetector(
                      onTap: (){

                        if(!isPressed){
                          getAccessToken(widget.userModelList[index].id.toString(), "VIDEO");

                        }
                      },
                      child: Icon(Icons.video_call, color: Colors.black,size: 24)),

                  SizedBox(width: 20,),
                  GestureDetector(
                      onTap: () async {
                        SharedPreferences pref = await SharedPreferences.getInstance();
                        var id = pref.getString("id");
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(senderId:id, receiverId: widget.userModelList[index].id, name:  widget.userModelList[index].name, image: widget.userModelList[index].image,fcmToken: widget.userModelList[index].firebase_token,userType: "user",)));
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

    






  Future<dynamic> getAccessToken(String id, String type) async {
    isPressed = true;
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
          "time":DateTime.now().millisecondsSinceEpoch.toString(),
          "channelKey": "key_user",
          "id": "10",
          "click_action": 'FLUTTER_NOTIFICATION_CLICK',

        });

    await request.then((http.Response response) {
      res = response;
      isPressed = false;
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
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Cannot connect to server")));
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
      Navigator.push(context, new MaterialPageRoute(builder: (context)=> DialScreen(name:name ,image:image, channel: channel, agoraToken: agoraToken,myId: userid.toString(),time: time,receiverId: idd, )));

    }
  }

}






class UserModel {

  var id = "";
  var role_id = "";
  var name = "";
  var email = "";
  var country_code = "";
  var phone = "";
  var image = "";
  var email_verified_at = "";
  var firebase_token= "";
  var status = "";
  var created_at = "";
  var updated_at = "";




}
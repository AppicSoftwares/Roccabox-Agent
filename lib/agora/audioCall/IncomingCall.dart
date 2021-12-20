import 'dart:async';
import 'dart:convert';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/src/provider.dart';
import 'package:roccabox_agent/agora/component/roundedButton.dart';
import 'package:roccabox_agent/agora/dialscreen/receivedCall.dart';
import 'package:roccabox_agent/agora/videoCall/videoCall.dart';
import 'package:roccabox_agent/screens/homenav.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../callModel.dart';
import '../constants.dart';
import '../sizeConfig.dart';


class IncomingCall extends StatefulWidget {

  String? payload;

  IncomingCall({Key? key, this.payload}):super(key:key);
  @override
  State<IncomingCall> createState() => _IncomingCallState();
}

class _IncomingCallState extends State<IncomingCall> {


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Body(/*model:widget.model,id:widget.id,*/ payload: widget.payload ),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    FlutterRingtonePlayer.stop();

  }
}


class Body extends StatefulWidget {
  CallModel? model;
  String? id;
  String? payload;
  Body({Key? key, this.model, this.id, this.payload}):super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool pickCall = false;
  late Timer _timmerInstance;
  int _start = 0;
  String _timmer = '';
  Map<String, dynamic> map = Map();
  String? id;
  late String image;
  late String name;
  late String myToken;
  FirebaseMessaging? auth;
  final firestoreInstance = FirebaseFirestore.instance;
  bool isLoading = true;

  late RtcEngine _engine;
  bool _joined = false;
  bool _switch = false;
  int? _remoteUid;
  CallModel model = CallModel.one();
  Future<void> initPlatformStateVoice(var token, var channelName, var images, var name, var receiverId, var time) async {
    // Get microphone permission
    print("AgoraToken "+token.toString());
    await [Permission.microphone].request();

    // Create RTC client instance
    RtcEngineContext contextt = RtcEngineContext(appId);
    _engine = await RtcEngine.createWithContext(contextt);
    // Define event handling logic
    _engine.setEventHandler(RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          print('joinChannelSuccess ${channel} ${uid}');
          _joined = true;
          FlutterRingtonePlayer.stop();
          Navigator.pushReplacement(context, new MaterialPageRoute(
              builder: (context) =>
                  ReceivedCall(id:id,channel: channelName,
                    agoraToken: token, image: images,name: name, engine: _engine,receiverId: receiverId, time: time,)));
        }, userJoined: (int uid, int elapsed) {
      print('userJoined ${uid}');
      setState(() {
        _remoteUid = uid;
      });
    }, userOffline: (int uid, UserOfflineReason reason) {
      print('userOffline ${uid}');

      if(_engine!=null) {
        _engine.destroy();
      }
      if(mounted) {
        Navigator.pushReplacement(
            context, new MaterialPageRoute(builder: (context) => HomeNav()));
      }
      setState(() {
        _remoteUid = 0;
      });
    },
        leaveChannel: (RtcStats reason) {
          print("remote user left channel");

          if(_engine!=null) {
            _engine.destroy();
          }
          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=> HomeNav()));

          //Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=> HomeNav()));


        },
    ));
    // Join channel with channel name as 123
    await _engine.joinChannel(token, channelName, null, 0);
  }

  void startTimmer() {
    var oneSec = Duration(seconds: 1);
    _timmerInstance = Timer.periodic(
        oneSec,
            (Timer timer) => setState(() {
          if (_start < 0) {
            _timmerInstance.cancel();
          } else {
            _start = _start + 1;
            _timmer = getTimerTime(_start);
          }
        }));
  }



  String getTimerTime(int start) {
    int minutes = (start ~/ 60);
    String sMinute = '';
    if (minutes.toString().length == 1) {
      sMinute = '0' + minutes.toString();
    } else
      sMinute = minutes.toString();

    int seconds = (start % 60);
    String sSeconds = '';
    if (seconds.toString().length == 1) {
      sSeconds = '0' + seconds.toString();
    } else
      sSeconds = seconds.toString();

    return sMinute + ':' + sSeconds;
  }
  Future<void> initAgora(var token, var channel) async {
    // retrieve permissions
    print("VideoInitialization");
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = await RtcEngine.create(appId);
    await _engine.enableVideo();
    _engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          print("local user $uid joined");
          setState(() {
            _joined = true;
          });
        },
        userJoined: (int uid, int elapsed) {
          print("remote user $uid joined");
          setState(() {
            _remoteUid = uid;
            Navigator.pushReplacement(context, new MaterialPageRoute(
                builder: (context) =>
                    VideoCall(channel:channel,
                        token: token, myId: id,)));
          });
        },
        userOffline: (int uid, UserOfflineReason reason) {
          print("remote user $uid left channel");
          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=> HomeNav()));
          _engine.destroy();
          setState(() {
            _remoteUid = null;
          });
        },
        leaveChannel: (RtcStats reason) {
          print("remote user left channel");
          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=> HomeNav()));

          _engine.destroy();
          //Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=> HomeNav()));


        },
      ),
    );

    await _engine.joinChannel(token, channel, null, 0);
  }


  @override
  void initState() {
    super.initState();
    //getData();
    FlutterRingtonePlayer.playRingtone(looping: true);

    auth = FirebaseMessaging.instance;
    auth?.getToken().then((value){
      print("FirebaseTokenHome "+value.toString());
      myToken = value.toString();

    }
    );
    Future.delayed(Duration(seconds: 30), () async{
      print("StatusJoined "+_joined.toString());
      if(_joined==false){
        if(mounted) {
          FlutterRingtonePlayer.stop();
        }
      }

    });
    /*if(model.sender_id!=null){
      id = widget.id;
      isLoading = false;

    }*/
     breakPayload(widget.payload);
  }

  @override
  void dispose() {
    // _timmerInstance.cancel();
    FlutterRingtonePlayer.stop();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      body: isLoading==true?Center(child: CircularProgressIndicator(),):id!=null? StreamBuilder<DocumentSnapshot>(
          stream: firestoreInstance
              .collection("call_master")
              .doc("call_head")
              .collection(model.sender_id.toString())
              .doc(model.time.toString())
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot> snapshot) {
            if(snapshot.hasData) {
              if (snapshot.data!.exists) {
                String status = snapshot.data!.get("status").toString();
                if (status.toString() != "null") {
                  if (status.toString() == "end") {
                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      FlutterRingtonePlayer.stop();
                      Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (context)=> HomeNav()), (r)=> false);

                    });
                  }
                }
              }
            }
            return Stack(
            fit: StackFit.expand,
            children: [
              // Image
             /*model.sender_image.toString()=="null"? Image.asset(
                'assets/img_not_available.png',
                width: 200.0,
                height: 200.0,
                fit: BoxFit.cover,
              ):CachedNetworkImage(
                placeholder: (con, url ){
                  return Image.asset(
                    'assets/img_not_available.png',
                    width: 200.0,
                    height: 200.0,
                    fit: BoxFit.fill,
                  );
                },
                errorWidget:(con,url,error){
                  return Material(
                    child: Image.asset(
                      'assets/img_not_available.png',
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  );
                },
                imageUrl: model.sender_image,
                width: 200.0,
                height: 200.0,
                fit: BoxFit.cover,
              ),*/
              Image.asset(
              'assets/img_not_available.png',
              width: 200.0,
              height: 200.0,
              fit: BoxFit.fill,
            ),
              // Black Layer
              DecoratedBox(
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SafeArea(
                  child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model.sender_name,
                            style: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(color: Colors.white),
                          ),
                          VerticalSpacing(of: 10),
                          Text(
                            _timmer.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Visibility(
                                visible:pickCall,
                                child: RoundedButton(
                                  press: () {

                                  },
                                  iconSrc: "assets/Icon Mic.svg",
                                ),
                              ),
                              Visibility(
                                visible: !pickCall,
                                child: RoundedButton(
                                  press: () {

                                    FlutterRingtonePlayer.stop();

                                    setState(() {
                                      _joined = true;
                                      //startTimmer();
                                      if(model.type=="VOICE"){
                                        initPlatformStateVoice(model.agoraToken, model.channelName, model.sender_image, model.sender_name,model.sender_id, model.time);
                                      }else{
                                        Navigator.push(context, new MaterialPageRoute(
                                            builder: (context) =>
                                                VideoCall(channel:model.channelName,
                                                    token: model.agoraToken,senderId:model.sender_id,myId: id,time: model.time, )));
                                        //initAgora(model.agoraToken, model.channelName);
                                      }/*
                                      if(model.type=="VOICE"){
                                        Navigator.push(context, new MaterialPageRoute(
                                            builder: (context) =>
                                                DialScreen(channel: model.channelName,
                                                    agoraToken: model.agoraToken, image: model.sender_image,name: model.sender_name, engine: _engine)));
                                      }else {
                                        Navigator.push(context, new MaterialPageRoute(
                                            builder: (context) =>
                                                VideoCall(channel: model.channelName,
                                                    token: model.agoraToken)));
                                      }*/
                                      pickCall = !pickCall;
                                    });
                                  },
                                  color: Colors.green,
                                  iconColor: Colors.white,
                                  iconSrc: "assets/phone_call_pick.svg",
                                ),
                              ),
                              Visibility(
                                visible: true,
                                child: RoundedButton(
                                  press: () {
                                    setState(() {
                                      FlutterRingtonePlayer.stop();
                                      pickCall = false;
                                      updateChatHead("end");
                                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                                        FlutterRingtonePlayer.stop();
                                        Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (context)=> HomeNav()), (r)=> false);

                                      });
                                    });
                                  },
                                  color: kRedColor,
                                  iconColor: Colors.white,
                                  iconSrc: "assets/call_end.svg",
                                ),
                              ),
                              Visibility(
                                visible: pickCall,
                                child: RoundedButton(
                                  press: () {

                                  },
                                  iconSrc: "assets/Icon Volume.svg",
                                ),
                              ),
                            ],
                          ),
                        ],


                  ),
                ),
              ),
            ],
          );
        }
      ):Center(child: Text("Please Register first"),),
    );
  }



  void updateChatHead(String status) async {
  Map<String, String> map = new Map();
  map["status"] = "end";
   FirebaseFirestore.instance
        .collection('call_master')
        .doc("call_head")
        .collection(id.toString())
        .doc(model.time).update(map).then((value) {
          FirebaseFirestore.instance
              .collection("call_master")
              .doc("call_head")
              .collection(model.sender_id)
              .doc(model.time)
              .update(map);
   });



  }

  void getData()async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    id = pref.getString("id").toString();
    name = pref.getString("name").toString();
    image = pref.getString("image").toString();



  }



  void breakPayload(String? _payload) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    id = pref.getString("id").toString();
    print("Payload "+_payload.toString());
    String a = _payload!.replaceAll("{", "");
    String b = a.replaceAll("}", "");
    print("B is"+b.toString());
    List<String> listdata = b.split(",");
    print(listdata.length);
    print(listdata.toString());


    listdata.forEach((element) {

      if(element.contains("channelName")){
        int i = element.indexOf(":")+2;
        model.channelName = element.substring(i);
        print(model.channelName);
      }

      if(element.contains("sender_id")){
        int i = element.indexOf(":")+2;
        model.sender_id = element.substring(i);
        print("SenderId "+model.sender_id);
      }

      if(element.contains("sender_image")){
        int i = element.indexOf(":")+2;
        model.sender_image = element.substring(i);
        print("sender_image "+model.sender_image);
      }

      if(element.contains("token")){
        int i = element.indexOf(":")+2;
        model.agoraToken = element.substring(i);
        print("agoraToken "+model.agoraToken);
      }

      if(element.contains("sender_name")){
        int i = element.indexOf(":")+2;
        model.sender_name = element.substring(i);
        print("SenderName "+model.sender_name);
      }

      if(element.contains("time")){
        int i = element.indexOf(":")+2;
        model.time = element.substring(i);
        print("Time "+model.time);
      }

      if(element.contains("sender_fcm")){
        int i = element.indexOf(":")+2;
        model.sender_fcm = element.substring(i);
        print("SenderFcm "+model.sender_fcm);
      }

      if(element.contains("type")){
        int i = element.indexOf(":")+2;
        model.type = element.substring(i);
        print("Type "+model.type);
      }
    });


      setState(() {
        isLoading = false;
      });

    Future.delayed(Duration(seconds: 28), () async{
      if(_joined==false){
        if(mounted) {
          FlutterRingtonePlayer.stop();
          Navigator.of(context).pushReplacement(
              new MaterialPageRoute(builder: (context) => HomeNav()));
        }
      }

    });
  }


}
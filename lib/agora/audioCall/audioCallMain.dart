import 'dart:async';
import 'dart:convert';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:roccabox_agent/agora/component/roundedButton.dart';
import 'package:roccabox_agent/agora/dialscreen/receivedCall.dart';
import 'package:roccabox_agent/agora/videoCall/videoCall.dart';
import 'package:roccabox_agent/screens/homenav.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../callModel.dart';
import '../constants.dart';
import '../sizeConfig.dart';


class AudioCallWithImage extends StatefulWidget {

  @override
  State<AudioCallWithImage> createState() => _AudioCallWithImageState();
}

class _AudioCallWithImageState extends State<AudioCallWithImage> {


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Body(),
    );
  }
}


class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool pickCall = false;
  late Timer _timmerInstance;
  int _start = 0;
  String _timmer = '';
  Map<String, dynamic> map = Map();
  late String id;
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

  Future<void> initPlatformStateVoice(var token, var channelName, var images, var name) async {
    // Get microphone permission
    print("Running ");
    print("AgoraToken "+token.toString());
    await [Permission.microphone].request();

    // Create RTC client instance
    RtcEngineContext contextt = RtcEngineContext(appId);
    _engine = await RtcEngine.createWithContext(contextt);
    // Define event handling logic
    _engine.setEventHandler(RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          print('joinChannelSuccess ${channel} ${uid}');
          Navigator.push(context, new MaterialPageRoute(
              builder: (context) =>
                  ReceivedCall(channel: channelName,
                    agoraToken: token, image: images,name: name, engine: _engine,)));
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
      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=> HomeNav()));

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


        }
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
            Navigator.push(context, new MaterialPageRoute(
                builder: (context) =>
                    VideoCall(channel:channel,
                        token: token)));
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
    getData();
    auth = FirebaseMessaging.instance;
    auth?.getToken().then((value){
      print("FirebaseTokenHome "+value.toString());
      myToken = value.toString();

    }
    );
    Future.delayed(Duration(seconds: 2), () async{

      setState(() {
        isLoading = false;

        FlutterRingtonePlayer.playRingtone(looping: true);
      });

    });

    Future.delayed(Duration(seconds: 15), () async{
      if(_joined==false){
        FlutterRingtonePlayer.stop();
        if(mounted) {
          Navigator.of(context).pushReplacement(
              new MaterialPageRoute(builder: (context) => HomeNav()));
        }
      }

    });


  }

  @override
  void dispose() {
    // _timmerInstance.cancel();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as CallModel;
    print(args.sender_id.toString());
    print(args.sender_name.toString());
    print("Callerimage  "+args.sender_image.toString());

    return Stack(
      fit: StackFit.expand,
      children: [
        // Image
        args.sender_image.toString()!="null"?
        CachedNetworkImage(
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
          imageUrl: args.sender_image,
          width: 200.0,
          height: 200.0,
          fit: BoxFit.cover,
        ):Image.asset('assets/img_not_available.png', width: 200,height: 200,fit: BoxFit.cover,),
        // Black Layer
        DecoratedBox(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: SafeArea(
            child:  isLoading== true?Center(child: CircularProgressIndicator(),): StreamBuilder<DocumentSnapshot>(
                stream: firestoreInstance
                    .collection("call_master")
                    .doc("call_head")
                    .collection(id)
                    .doc(args.time)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if(snapshot.hasData){
                    var json;
                    json= snapshot.data!.get("status").toString();
                    print("StatusAudioCallMain "+json.toString());
                    if(json.toString()!="null"){
                      if(json.toString()=="end"){
                        WidgetsBinding.instance!.addPostFrameCallback((_){
                          FlutterRingtonePlayer.stop();
                          Navigator.of(context).pushReplacement(
                              new MaterialPageRoute(builder: (context) => HomeNav()));

                        });
                      }
                    }


                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        args.sender_name,
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
                                setState(() {
                                  FlutterRingtonePlayer.stop();
                                  //startTimmer();
                                  _joined = true;
                                  if(args.type=="VOICE"){
                                    initPlatformStateVoice(args.agoraToken, args.channelName, args.sender_image, args.sender_name);
                                  }else{
                                    Navigator.pushReplacement(context, new MaterialPageRoute(
                                        builder: (context) =>
                                            VideoCall(channel:args.channelName,
                                              token: args.agoraToken,senderId:args.sender_id,myId: id,time: args.time, )));
                                    //initAgora(args.agoraToken, args.channelName);
                                  }/*
                                if(args.type=="VOICE"){
                                  Navigator.push(context, new MaterialPageRoute(
                                      builder: (context) =>
                                          DialScreen(channel: args.channelName,
                                              agoraToken: args.agoraToken, image: args.sender_image,name: args.sender_name, engine: _engine)));
                                }else {
                                  Navigator.push(context, new MaterialPageRoute(
                                      builder: (context) =>
                                          VideoCall(channel: args.channelName,
                                              token: args.agoraToken)));
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

                                  updateChatHead(args, "end");
                                  Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context)=> HomeNav()));

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
                  );
                }
            ),
          ),
        ),
      ],
    );
  }



  void updateChatHead(CallModel args, String status) async {
    Map<String, String> map = new Map();
    map["status"] = "end";
    FirebaseFirestore.instance
        .collection('call_master')
        .doc("call_head")
        .collection(id)
        .doc(args.time).update(map).then((value) {
      FirebaseFirestore.instance
          .collection("call_master")
          .doc("call_head")
          .collection(args.sender_id)
          .doc(args.time)
          .update(map);
    });



  }

  void getData()async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    id = pref.getString("id").toString();
    name = pref.getString("name").toString();
    image = pref.getString("image").toString();

  }

}
import 'dart:async';
import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:roccabox_agent/agora/component/dialUser.dart';
import 'package:roccabox_agent/agora/component/roundedButton.dart';
import 'package:roccabox_agent/agora/videoCall/videoCall.dart';
import 'package:roccabox_agent/screens/homenav.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../sizeConfig.dart';
import 'dialButton.dart';
import 'package:audioplayers/audioplayers.dart';


class DialScreen extends StatefulWidget {
  var name, image, channel, agoraToken, myId, time, receiverId;
  DialScreen({Key? key, this.name, this.image, this.channel, this.agoraToken, this.myId, this.time, this.receiverId}):super(key:key);
  @override
  State<DialScreen> createState() => _DialScreenState();
}

class _DialScreenState extends State<DialScreen> {
  bool pickCall = false;
  Timer? _timmerInstance;
  int _start = 0;
  String _timmer = '';
  late RtcEngine _engine;
  int? _remoteUid;
  bool _localUserJoined = false;
  var APP_ID = 'c5971380084649549b2af1d70a36c2d2';
  var Token = '006c5971380084649549b2af1d70a36c2d2IAAYkiOiBA5SjY8lso60pT1CLi2JZ4bIJoTXM8Bj4A7/O5QcH3YAAAAAEADmp+kb3whxYQEAAQDfCHFh';
  bool _joined = false;
  bool _switch = false;
  bool isSpeakerOn = false;
  bool isMute = false;
  final firestoreInstance = FirebaseFirestore.instance;
  var idd;
  var status = "calling";
  FirebaseMessaging? auth;
  var myFcm;
  var selectedTimeStamp;
  var remote = false;
  var isLoading = true;
  AudioCache audioPlayer = AudioCache();
  AudioPlayer? player; // create this





  void _playFile() async{
    if(Platform.isIOS) {
      player = await audioPlayer.play('Dial Tone.m4r'); // assign player here
    }else{
      player = await audioPlayer.play('Dial Tone.mp3'); // assign player here
    }
  }

  void _stopFile() {
    player?.stop(); // stop the file like this
  }
  @override
  void initState() {
    //getid();
    super.initState();
    //startTimmer();
    Future.delayed(Duration(seconds: 2), () async{

      setState(() {
        isLoading = false;
        _playFile();
      });

    });

    print("AgoraTokenDial "+widget.agoraToken.toString()+"");
   // initAgora();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    // Get microphone permission
    await [Permission.microphone].request();
    Future.delayed(Duration(seconds: 30), () async{
      if(remote==false){
        _engine.leaveChannel();
        _engine.destroy();
        _stopFile();
        if(mounted) {
          Navigator.of(context).pushReplacement(
              new MaterialPageRoute(builder: (context) => HomeNav()));
        }
      }

    });
    // Create RTC client instance
    RtcEngineContext contextt = RtcEngineContext(appId);
    _engine = await RtcEngine.createWithContext(contextt);
    // Define event handling logic
    _engine.setEventHandler(RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          print('joinChannelSuccess ${channel} ${uid}');
          setState(() {
            _joined = true;

          });
        }, userJoined: (int uid, int elapsed) {
      print('userJoined ${uid}');
      startTimmer();
      setState(() {
        _remoteUid = uid;
        remote = true;
        _stopFile();
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


      },


    ));
    // Join channel with channel name as 123
    await _engine.joinChannel(widget.agoraToken, widget.channel, null, 0);
  }


  @override
  Widget build(BuildContext context) {
    idd = widget.myId;
    print("Idddd "+idd.toString());
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: kBackgoundColor,
      body: isLoading==true?Center(child: CircularProgressIndicator(),):SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child:idd!=null? StreamBuilder<DocumentSnapshot>(
              stream: firestoreInstance
                  .collection("call_master")
                  .doc("call_head")
                  .collection(idd)
                  .doc(widget.time)
                  .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if(snapshot.hasData){
                if(snapshot.data!.exists) {
                  status = snapshot.data!.get("status").toString();

                  if (status.toString() != "null") {
                    if (status.toString() == "end") {
                      _engine.leaveChannel();
                      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                        Navigator.of(context).pushReplacement(
                            new MaterialPageRoute(
                                builder: (context) => HomeNav()));
                      });
                    }
                  }
                }
              }
              return Column(
                children: [
                  Text(
                    widget.name!=null?widget.name:"",
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(color: Colors.white),
                  ),
                  Text(
                    _timmer==''?"Calling…":_timmer,
                    style: TextStyle(color: Colors.white60),
                  ),
                  VerticalSpacing(),
                  DialUserPic(image: widget.image),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      /*RoundedButton(
                        press: () {
                          if(isMute==true){
                            _engine.enableAudio();
                            isMute = false;
                          }else{
                            _engine.disableAudio();
                            isMute = true;
                          }
                        },
                        iconSrc: !isMute?"assets/mute.svg":"assets/Icon Mic.svg",
                      ),*/
                      GestureDetector(
                          onTap: (){
                            if(isMute==true){
                              _engine.enableLocalAudio(true);
                              isMute = false;
                            }else{
                              _engine.enableLocalAudio(false);
                              isMute = true;
                            }
                          },
                          child: SvgPicture.asset(
                            "assets/mute.svg",
                            color: !isMute? Colors.white:Colors.blueAccent,
                            width: 25,
                            height: 25,)),
                      RoundedButton(
                        press: () {
                          pickCall = false;
                          _stopFile();
                          _engine.leaveChannel();
                          updateChatHead();
                          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=> HomeNav()));

                          },
                        color: kRedColor,
                        iconColor: Colors.white,
                        iconSrc: "assets/call_end.svg",
                      ),
                     /* RoundedButton(
                        press: () {
                          _engine.isSpeakerphoneEnabled().then((value){
                            print(value.toString());
                            setState(() {
                              if(value.toString()=="true"){
                                _engine.setEnableSpeakerphone(false);
                                isSpeakerOn = false;
                              }else{
                                _engine.setEnableSpeakerphone(true);
                                isSpeakerOn = true;
                              }
                            });

                          });

                        },
                        iconSrc: !isSpeakerOn? "assets/Icon Volume.svg":"assets/speaker_off.svg",
                      ),*/

                      GestureDetector(
                          onTap: (){
                            _engine.isSpeakerphoneEnabled().then((value){
                              print(value.toString());
                              setState(() {
                                if(value.toString()=="true"){
                                  _engine.setEnableSpeakerphone(false);
                                  isSpeakerOn = false;
                                }else{
                                  _engine.setEnableSpeakerphone(true);
                                  isSpeakerOn = true;
                                }
                              });

                            });
                          },
                          child: SvgPicture.asset(
                              "assets/Icon Volume.svg",
                              color: !isSpeakerOn? Colors.white:Colors.blueAccent,
                              width: 25,
                              height: 25,)),
                    ],
                  ),
                  /*    Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    DialButton(
                      iconSrc: "assets/Icon Mic.svg",
                      text: "Audio",
                      press: () {},
                    ),
                    DialButton(
                      iconSrc: "assets/Icon Volume.svg",
                      text: "Microphone",
                      press: () {},
                    ),
                    DialButton(
                      iconSrc: "assets/Icon Video.svg",
                      text: "Video",
                      press: () {},
                    ),
                    DialButton(
                      iconSrc: "assets/Icon Message.svg",
                      text: "Message",
                      press: () {},
                    ),
                    DialButton(
                      iconSrc: "assets/Icon User.svg",
                      text: "Add contact",
                      press: () {},
                    ),
                    DialButton(
                      iconSrc: "assets/Icon Voicemail.svg",
                      text: "Voice mail",
                      press: () {},
                    ),
                  ],
                ),
                VerticalSpacing(),
                Visibility(
                  visible: true,
                  child: RoundedButton(
                    iconSrc: "assets/call_end.svg",
                    press: () {

                    },
                    color: kRedColor,
                    iconColor: Colors.white,
                  ),
                )*/
                ],
              );
            }
          ):Center(child: Text("Please Register first"),),
        ),
      )
    );
  }




  @override
  void dispose() {

    if(mounted) {
      _timmerInstance?.cancel();
      _engine.destroy();
      _stopFile();
    }
    super.dispose() ;
  }


  void startTimmer() {
    var oneSec = Duration(seconds: 1);
    _timmerInstance = Timer.periodic(
        oneSec,
            (Timer timer) => setState(() {
          if (_start < 0) {
            _timmerInstance?.cancel();
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

  void getid() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    idd = pref.get("id").toString();
  }


  void updateChatHead() async {
    Map<String, String> map = new Map();
    map["status"] = "end";
    FirebaseFirestore.instance
        .collection('call_master')
        .doc("call_head")
        .collection(widget.myId.toString())
        .doc(widget.time).update(map).then((value) {
      FirebaseFirestore.instance
          .collection("call_master")
          .doc("call_head")
          .collection(widget.receiverId)
          .doc(widget.time)
          .update(map);
    });



  }
}



class Body extends StatefulWidget {


  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  bool pickCall = false;
  late Timer _timmerInstance;
  int _start = 0;
  String _timmer = '';

  @override
  void initState() {
    super.initState();
    startTimmer();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
             "",
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(color: Colors.white),
            ),
            Text(
              _timmer==''?"Calling…":_timmer,
              style: TextStyle(color: Colors.white60),
            ),
            VerticalSpacing(),
            DialUserPic(image: "assets/calling_face.png"),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RoundedButton(
                  press: () {},
                  iconSrc: "assets/Icon Mic.svg",
                ),

                RoundedButton(
                  press: () {
                    setState(() {
                      pickCall = false;
                      _timmerInstance.cancel();

                      Navigator.pop(context);
                    });
                  },
                  color: kRedColor,
                  iconColor: Colors.white,
                  iconSrc: "assets/call_end.svg",
                ),
                RoundedButton(
                  press: () {

                  },
                  iconSrc: "assets/Icon Volume.svg",
                ),
              ],
            ),
        /*    Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: [
                DialButton(
                  iconSrc: "assets/Icon Mic.svg",
                  text: "Audio",
                  press: () {},
                ),
                DialButton(
                  iconSrc: "assets/Icon Volume.svg",
                  text: "Microphone",
                  press: () {},
                ),
                DialButton(
                  iconSrc: "assets/Icon Video.svg",
                  text: "Video",
                  press: () {},
                ),
                DialButton(
                  iconSrc: "assets/Icon Message.svg",
                  text: "Message",
                  press: () {},
                ),
                DialButton(
                  iconSrc: "assets/Icon User.svg",
                  text: "Add contact",
                  press: () {},
                ),
                DialButton(
                  iconSrc: "assets/Icon Voicemail.svg",
                  text: "Voice mail",
                  press: () {},
                ),
              ],
            ),
            VerticalSpacing(),
            Visibility(
              visible: true,
              child: RoundedButton(
                iconSrc: "assets/call_end.svg",
                press: () {

                },
                color: kRedColor,
                iconColor: Colors.white,
              ),
            )*/
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timmerInstance.cancel();
    super.dispose();
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
}
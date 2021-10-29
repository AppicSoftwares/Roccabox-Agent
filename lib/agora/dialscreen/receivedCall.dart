import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:roccabox_agent/agora/component/dialUser.dart';
import 'package:roccabox_agent/agora/component/roundedButton.dart';
import 'package:roccabox_agent/screens/homenav.dart';

import '../callModel.dart';
import '../constants.dart';
import '../sizeConfig.dart';
import 'dialButton.dart';


class ReceivedCall extends StatefulWidget {
  var name, image, channel, agoraToken;
  RtcEngine engine;
  ReceivedCall({Key? key, this.name, this.image, this.channel, this.agoraToken, required this.engine}):super(key:key);
  @override
  State<ReceivedCall> createState() => _ReceivedCallState();
}

class _ReceivedCallState extends State<ReceivedCall> {
  bool pickCall = false;
  late Timer _timmerInstance;
  int _start = 0;
  String _timmer = '';
  late RtcEngine _engine;
  int? _remoteUid;
  bool _localUserJoined = false;
  var APP_ID = 'c5971380084649549b2af1d70a36c2d2';
  var Token = '006c5971380084649549b2af1d70a36c2d2IAAYkiOiBA5SjY8lso60pT1CLi2JZ4bIJoTXM8Bj4A7/O5QcH3YAAAAAEADmp+kb3whxYQEAAQDfCHFh';
  bool _joined = false;
  bool _switch = false;
  bool isMute = false;

  bool isSpeakerOn = false;
  @override
  void initState() {
    super.initState();
    _engine = widget.engine;
    startTimmer();
   // initPlatformState(widget.agoraToken, widget.channel);

  }

  Future<void> initPlatformState(var token, var channelName) async {
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
          setState(() {
            _joined = true;
          });
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

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = await RtcEngine.create(appId);
    _engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          print("local user $uid joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        userJoined: (int uid, int elapsed) {
          print("remote user $uid joined");
          setState(() {
            _remoteUid = uid;
          });
          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=> HomeNav()));

        },
        userOffline: (int uid, UserOfflineReason reason) {
          print("remote user $uid left channel");
          if(_engine!=null) {
            _engine.destroy();
          }
          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=> HomeNav()));

          setState(() {
            _remoteUid = null;
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
      ),
    );

  }



  @override
  Widget build(BuildContext context) {
    print("Imageee "+widget.image.toString());
    SizeConfig().init(context);
   /* final args = ModalRoute.of(context)!.settings.arguments as CallModel;
    print(args.sender_id.toString());
    print(args.sender_name.toString());
   */
    return Scaffold(
        backgroundColor: kBackgoundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  widget.name!=null?widget.name:"",
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(color: Colors.white),
                ),
                Text(
                  _timmer==''?"Calling…..":_timmer,
                  style: TextStyle(color: Colors.white60),
                ),
                VerticalSpacing(),
                widget.image.toString()=="null"?DialUserPic(image: widget.image.toString()):SizedBox(height: 50,),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
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
                          height: 25,
                        )),

                    RoundedButton(
                      press: () {
                        if(_engine!=null) {
                          _engine.leaveChannel();
                          _engine.destroy();
                        }
                        pickCall = false;
                        _timmerInstance.cancel();

                        Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=> HomeNav()));

                      },
                      color: kRedColor,
                      iconColor: Colors.white,
                      iconSrc: "assets/call_end.svg",
                    ),
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
            ),
          ),
        )
    );
  }




  @override
  void dispose() {
    _timmerInstance.cancel();
    _engine.destroy();
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
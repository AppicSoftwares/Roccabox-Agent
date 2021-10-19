
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:roccabox_agent/agora/component/roundedButton.dart';
import 'package:roccabox_agent/agora/constants.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:roccabox_agent/agora/sizeConfig.dart';


import 'package:roccabox_agent/screens/homenav.dart';
class VideoCall extends StatefulWidget {
  var token, channel, name, image;
  VideoCall({Key? key, this.token, this.channel, this.name, this.image}):super(key:key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<VideoCall> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  bool visibility = false;
  @override
  void initState() {
    super.initState();
    initAgora();
  }


  @override
  void dispose() {
    _engine.destroy();
    super.dispose();
  }


  Future<void> initAgora() async {
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
            _localUserJoined = true;
            visibility = true;
          });
        },
        userJoined: (int uid, int elapsed) {
          visibility = true;
          print("remote user $uid joined");
          setState(() {
            _remoteUid = uid;

          });
        },
        userOffline: (int uid, UserOfflineReason reason) {
          print("remote user $uid left channel");
          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=> HomeNav()));
          _engine.destroy();
          setState(() {
            _remoteUid = null;
            visibility = false;
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

    await _engine.joinChannel(widget.token, widget.channel, null, 0);
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(

      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: _remoteVideo(),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 100,
                height: 150,
                child: Center(
                  child: _localUserJoined
                      ? RtcLocalView.SurfaceView()
                      : CircularProgressIndicator(),
                ),
              ),
            ),
            Visibility(
              visible: visibility,
              child: Align(
                alignment: Alignment.bottomCenter,
                child:    Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RoundedButton(
                      press: () {

                      },
                      iconSrc: "assets/Icon Mic.svg",
                    ),
                    SizedBox(width: 30,),
                    RoundedButton(
                      press: () {
                        setState(() {
                          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=> HomeNav()));
                          _engine.destroy();
                        });
                      },
                      color: kRedColor,
                      iconColor: Colors.white,
                      iconSrc: "assets/call_end.svg",
                    ),
                    SizedBox(width: 30,),
                    RoundedButton(
                      press: () {

                      },
                      iconSrc: "assets/Icon Volume.svg",
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return RtcRemoteView.SurfaceView(uid: _remoteUid!);
    } else {
      return Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}
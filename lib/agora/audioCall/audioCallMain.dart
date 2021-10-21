import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:roccabox_agent/agora/component/roundedButton.dart';
import 'package:roccabox_agent/agora/dialscreen/dialScreen.dart';
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
    FlutterRingtonePlayer.playRingtone(looping: true);
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
    return Stack(
      fit: StackFit.expand,
      children: [
        // Image
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
        ),
        // Black Layer
        DecoratedBox(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: SafeArea(
            child: Column(
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
                            print("argsToken "+ args.agoraToken.toString()+"");
                            if(args.type=="VOICE"){
                              Navigator.push(context, new MaterialPageRoute(
                                  builder: (context) =>
                                      DialScreen(channel: args.channelName,
                                          agoraToken: args.agoraToken, image: args.sender_image,name: args.sender_name,)));
                            }else {
                              Navigator.push(context, new MaterialPageRoute(
                                  builder: (context) =>
                                      VideoCall(channel: args.channelName,
                                          token: args.agoraToken)));
                            }
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
                            updateChatHead(args);
                            Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context)=> HomeNav()));
                            _timmerInstance.cancel();

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



  void updateChatHead(CallModel args) async {

    var documentReference = FirebaseFirestore.instance
        .collection('call_master')
        .doc("call_head")
        .collection(id)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());


    firestoreInstance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        {
          'fcmToken': args.sender_fcm,
          'id': args.sender_id,
          'image': args.sender_image,
          'name': args.sender_name,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          'type': args.type,
          'callType':"incoming"

        },
      );
    }).then((value) {
      var documentReference = FirebaseFirestore.instance
          .collection('call_master')
          .doc("call_head")
          .collection(args.sender_id)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      firestoreInstance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'fcmToken': myToken,
            'id': id,
            'image': image,
            'name': name,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'type': args.type,
            'callType':"outgoing"
          },
        );
      });
    });

  }

  void getData()async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    id = pref.getString("id").toString();
    name = pref.getString("name").toString();
    image = pref.getString("image").toString();

  }

}
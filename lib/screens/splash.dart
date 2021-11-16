import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homenav.dart';
import 'login.dart';

class Splash extends StatefulWidget {
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String id = "";
  FirebaseMessaging? auth;
  var token;
  final firestoreInstance = FirebaseFirestore.instance;
 // final databaseRef = FirebaseDatabase.instance.reference(); //database reference object

  @override
  void initState() {
    auth = FirebaseMessaging.instance;
    auth?.getToken().then((value) {
      print("FirebaseToken " + value.toString());
      token = value.toString();
    }
    );
    getLoginStatus();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: SvgPicture.asset('assets/roccabox-logo.svg'),
        ),
      ),
    );
  }

  getLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString("id").toString();
    print("id :" + id + "^");


    if (id != null) {
      var documentReference = FirebaseFirestore.instance
          .collection('token')
          .doc(id.toString());

      firestoreInstance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'token': token
          },
        );
      });
      
 /*     databaseRef.push().set({id:token}).then((value) {
        print("RunningRelatime "+"true");
      });*/
    }
    
    Future.delayed(Duration(seconds: 2), () {
      id.toString() == "" || id.toString() == "null" || id == null
          ? Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()))
          : Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeNav()),
              (route) => false);
    });
  }


}

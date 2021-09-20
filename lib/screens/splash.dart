import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:roccabox_agent/screens/home.dart';
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
  @override
  void initState() {
    auth = FirebaseMessaging.instance;
    auth?.getToken().then((value){
      print("FirebaseToken "+value.toString());
      token = value.toString();
    });
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

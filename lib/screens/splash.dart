import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:roccabox_agent/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class Splash extends StatefulWidget {

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String id = "";

  @override
  void initState() {

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
    print("id :"+id+"^");

    Future.delayed(Duration(seconds: 2), () {
     id.toString()=="" || id.toString()=="null" || id==null ?
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login())):
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    });
  }
}

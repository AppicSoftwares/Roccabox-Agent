import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:roccabox_agent/main.dart';
import 'package:roccabox_agent/screens/call.dart';
import 'package:roccabox_agent/screens/chat.dart';
import 'package:roccabox_agent/services/APIClient.dart';
import 'package:roccabox_agent/util/languagecheck.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Setting.dart';
import 'notifications.dart';

class HomeNav extends StatefulWidget {

  
  @override
  _HomeNavState createState() => _HomeNavState();
}

class _HomeNavState extends State<HomeNav> {
  int _index = 0;
  List widgets = <Widget>[Chat(), Call(), Notifications(), Profile()];
FirebaseMessaging? auth;
  var token;
    LanguageChange languageChange = new LanguageChange();


    @override
  void initState() {
   
    super.initState();
    auth = FirebaseMessaging.instance;
    auth?.getToken().then((value){
      print("FirebaseTokenHome "+value.toString());
      token = value.toString();

      if(token != null){
        updateToken(token);
      }


    }
    );

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgets.elementAt(_index),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _index,
          type: BottomNavigationBarType.fixed,
          // showSelectedLabels: true,
          selectedIconTheme: IconThemeData(color: Color(0xffFFBA00)),
          unselectedIconTheme: IconThemeData(color: Color(0xff8E8E8E)),
          selectedLabelStyle: TextStyle(fontSize: 12, color: Color(0xffFFBA00)),
          unselectedLabelStyle:
              TextStyle(fontSize: 12, color: Color(0xff8E8E8E)),
          selectedItemColor: Color(0xffFFBA00),
          unselectedItemColor: Color(0xff8E8E8E),
          onTap: (page) {
            setState(() {
              _index = page;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/chat.svg',
                  color: _index == 0 ? Color(0xffFFBA00) : Color(0xff8E8E8E),
                ),
                //Chat
                label: languageChange.CHAT[langCount],
                ),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/call.svg',
                  color: _index == 1 ? Color(0xffFFBA00) : Color(0xff8E8E8E),
                ),

                //Call
                label: languageChange.CALL[langCount]),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/notification.svg',
                  color: _index == 2 ? Color(0xffFFBA00) : Color(0xff8E8E8E),
                ),

                //Notification
                label: languageChange.NOTIFICATION[langCount]),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/profile.svg',
                  color: _index == 3 ? Color(0xffFFBA00) : Color(0xff8E8E8E),
                ),

                //Menu
                label: languageChange.MENU[langCount])
          ]),
    );
  }

  Future<dynamic> getUserList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var id = pref.getString("id").toString();
    var email = pref.getString("email").toString();
      
  }


   Future<dynamic> updateToken(String token) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var userid = pref.getString("id");

  print("user_id "+userid.toString());
  print("token "+token.toString());
    // print(email)
;
    var jsonRes;
    http.Response? res;
    var request = http.post(Uri.parse(RestDatasource.SENDTOKEN_URL),
        body: {

      "token": token.toString(),
      "user_id": userid.toString()


    });

    await request.then((http.Response response) {
      res = response;

      // msg = jsonRes["message"].toString();
      // getotp = jsonRes["otp"];
      // print(getotp.toString() + '123');t
    });
    if (res!.statusCode == 200) {
      final JsonDecoder _decoder = new JsonDecoder();
      jsonRes = _decoder.convert(res!.body.toString());
      print("Response: " + res!.body.toString() + "_");
      print("ResponseJSON: " + jsonRes.toString() + "_");


    } else {

    }
  }

}

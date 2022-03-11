import 'dart:collection';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:roccabox_agent/main.dart';
import 'package:roccabox_agent/screens/call.dart';
import 'package:roccabox_agent/screens/chat.dart';
import 'package:roccabox_agent/services/APIClient.dart';
import 'package:roccabox_agent/util/customDialoge.dart';
import 'package:roccabox_agent/util/languagecheck.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Setting.dart';
import 'login.dart';
import 'notifications.dart';

class HomeNav extends StatefulWidget {

  
  @override
  _HomeNavState createState() => _HomeNavState();
}

class _HomeNavState extends State<HomeNav> {
  int _index = 0;
  List widgets = <Widget>[Chat(backShow: false,), Calls(), Notifications(), Profile()];
FirebaseMessaging? auth;
  var token;
    LanguageChange languageChange = new LanguageChange();

GlobalKey globalKey = new GlobalKey(debugLabel: 'btm_app_bar');
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
    //getAccessToken();
    getNotify();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgets.elementAt(_index),
      bottomNavigationBar: BottomNavigationBar(
        key: globalKey,
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
            getData();
            setState(() {

              _index = page;
              if(_index==0){
                 currentInstance = "CHAT_SCREEN";
                  chatUser = "";

              }else{
                currentInstance = "";
                chatUser = "";
              }
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
      final BottomNavigationBar? navigationBar = globalKey.currentWidget as BottomNavigationBar?;
    navigationBar!.onTap!(1);
  }


   Future<dynamic> updateToken(String token) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var userid = pref.getString("id");
  var authToken = pref.getString("auth_token").toString();
  print("AUTH_TOKEN "+authToken.toString());
  Map<String, String> mapheaders = new HashMap();
  mapheaders["Authorization"] = authToken.toString();

  print("user_id "+userid.toString());
  print("token "+token.toString());
    // print(email)
;
    var jsonRes;
    http.Response? res;
    var request = http.post(Uri.parse(RestDatasource.SENDTOKEN_URL),
        headers: mapheaders,
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

      if(jsonRes["status"].toString()=="false"){
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(jsonRes["message"].toString())));
          if(jsonRes["code"]!=null){
            if(jsonRes["code"]==403){
              showLogoutDialog(context);
            }
          }
        });
      }

    } else {

    }
  }

    void getNotify() async{
   notificationCount = 0;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var isRead = preferences.getStringList("isRead");
    print("IsRead " + isRead.toString());
    if (isRead != null) {
      if (isRead.isNotEmpty) {
        for (var k = 0; k < isRead.length; k++) {
          print("element " + isRead[k].toString());
          if (isRead[k] == "false") {
            notificationCount++;
          }
        }
      }
    }
    print("counthome " + notificationCount.toString());
    preferences.setString("notify",notificationCount.toString());
    preferences.commit();
    setState(() {});
  }


  Future getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userid = pref.getString("id");
    var authToken = pref.getString("auth_token").toString();
    print("AUTH_TOKEN "+authToken.toString());
    Map<String, String> mapheaders = new HashMap();
    mapheaders["Authorization"] = authToken.toString();

    var jsonRes;
    var response =
    await http.post(Uri.parse(RestDatasource.BASE_URL + 'userProfile'),
        headers: mapheaders,
        body: {
          "user_id":userid
        });

    if (response.statusCode == 200) {
      var apiObj = JsonDecoder().convert(response.body.toString());
      if(apiObj["status"]==true){
        var data = apiObj["data"];
        if(apiObj["data"]["status"].toString()!="1"){
          var pref = await SharedPreferences.getInstance();
          pref.clear();
          pref.commit();
          var result  = new MaterialPageRoute(builder: (context) => Login());
          Navigator.of(context,rootNavigator: true).pushAndRemoveUntil(result, (route) => false);


        }
      }else{
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(jsonRes["message"].toString())));
          if(jsonRes["code"]!=null){
            if(jsonRes["code"]==403){
              showLogoutDialog(context);
            }
          }
        });
      }

    } else {
      throw Exception('Failed to load album');
    }
  }



}

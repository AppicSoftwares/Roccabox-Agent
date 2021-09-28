import 'dart:math';

import 'package:flutter/material.dart';
import 'package:roccabox_agent/screens/holidayrent.dart';
import 'package:roccabox_agent/util/languagecheck.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  




  List names = [
    'Rajveer Place',
    'Taj Place',
    'Amar Place',
    'KLM Place',
    'Calibration Place',
    'Special Place',
    'Moti Place',
    'Rajvansh Place',
    'Taj Place',
    'Amar Place',
    'KLM Place',
    'Calibration Place',
    'Special Place',
  ];



  List<String> titleList = [];
  List<String> bodyList = [];
  @override
  void initState() {
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    LanguageChange languageChange = new LanguageChange();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFFFFFF),
        elevation: 0,
        centerTitle: true,
        title: Text(

          // Notifications
          languageChange.NOTIFICATION[langCount],
          style: TextStyle(
              fontSize: 16,
              color: Color(0xff000000),
              fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView.separated(
        itemCount: titleList.length,
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            height: 0,
            color: Color(0xff707070),
          );
        },
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => NotificationDetails())),
            isThreeLine: true,
            leading: CircleAvatar(
              backgroundColor:
                  Colors.primaries[Random().nextInt(Colors.primaries.length)],
              // backgroundImage: AssetImage('assets/img1.png'),
              child: Text(
                titleList.elementAt(index).toString().substring(0, 1),
                style: TextStyle(fontSize: 22, color: Colors.black),
              ),
            ),
            title: Text(
              titleList.elementAt(index),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff000000)),
            ),
            subtitle: Text(bodyList[index],
              style: TextStyle(fontSize: 12, color: Color(0xff818181)),
            ),
          );
        },
      ),
    );
  }


  Future<void> getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    titleList = preferences.getStringList("titleList")!;
    bodyList = preferences.getStringList("bodyList")!;
    setState(() {
      titleList = titleList.reversed.toList();
      bodyList = bodyList.reversed.toList();
    });
  }
}

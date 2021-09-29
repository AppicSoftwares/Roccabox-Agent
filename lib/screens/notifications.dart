import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:roccabox_agent/screens/homenav.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  List<String> isread = [];



  @override
  void initState() {
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Color(0xff000000),
          onPressed: (){
            Navigator.pushReplacement(context, new MaterialPageRoute(builder: (con)=> HomeNav()));
          },
        ),
        backgroundColor: Color(0xffFFFFFF),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Notifications',
          style: TextStyle(
              fontSize: 16,
              color: Color(0xff000000),
              fontWeight: FontWeight.w600),
        ),

        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10, top: 5),
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () {

              },
              child: Container(
                padding: EdgeInsets.all(12),
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: Color(0xFF979797).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  "assets/delete.svg",
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: titleList.length,
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: Color(0xff707070),
          );
        },
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
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
            subtitle: Text(
              bodyList[index],
              style: TextStyle(fontSize: 12, color: Color(0xff818181)),
            ),
          );
        },
      ),
    );
  }



  Future<void> getData() async {
    List<String> isRead = [];
    SharedPreferences preferences = await SharedPreferences.getInstance();
    titleList = preferences.getStringList("titleList")!;
    bodyList = preferences.getStringList("bodyList")!;
    isread = preferences.getStringList("isRead")!;
    isread.forEach((element) {
      isRead.add("true");
    });
    preferences.setStringList("isRead", isRead);
    preferences.commit();
    setState(() {
      titleList = titleList.reversed.toList();
      bodyList = bodyList.reversed.toList();
    });
  }
}
/*
ListView.separated(
        itemCount: names.length,
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: Color(0xff707070),
          );
        },
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            isThreeLine: true,
            leading: CircleAvatar(
              backgroundColor:
                  Colors.primaries[Random().nextInt(Colors.primaries.length)],
              // backgroundImage: AssetImage('assets/img1.png'),
              child: Text(
                names.elementAt(index).toString().substring(0, 1),
                style: TextStyle(fontSize: 22, color: Colors.black),
              ),
            ),
            title: Text(
              names.elementAt(index),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff000000)),
            ),
            subtitle: Text(
              'Hi! We have assigned you  a new agent for your previous enquiry. They will message you shortly',
              style: TextStyle(fontSize: 12, color: Color(0xff818181)),
            ),
          );
        },
      ),*/
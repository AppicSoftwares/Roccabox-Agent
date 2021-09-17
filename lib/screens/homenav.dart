import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:roccabox_agent/screens/call.dart';
import 'package:roccabox_agent/screens/chat.dart';

import 'Setting.dart';
import 'notifications.dart';

class HomeNav extends StatefulWidget {
  @override
  _HomeNavState createState() => _HomeNavState();
}

class _HomeNavState extends State<HomeNav> {
  int _index = 0;
  List widgets = <Widget>[Chat(), Call(), Notifications(), Profile()];
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
                label: 'Chat',
                ),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/call.svg',
                  color: _index == 1 ? Color(0xffFFBA00) : Color(0xff8E8E8E),
                ),
                label: 'Call'),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/notification.svg',
                  color: _index == 2 ? Color(0xffFFBA00) : Color(0xff8E8E8E),
                ),
                label: 'Notification'),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/profile.svg',
                  color: _index == 3 ? Color(0xffFFBA00) : Color(0xff8E8E8E),
                ),
                label: 'Profile')
          ]),
    );
  }
}

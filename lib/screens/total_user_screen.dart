import 'package:flutter/material.dart';
import 'package:roccabox_agent/screens/chatscreen.dart';
import 'package:roccabox_agent/screens/user_Detail.dart';

import 'Setting.dart';

class TotalUserScreen extends StatefulWidget {
List<TotalUserList> totalUserList = [];

TotalUserScreen({Key? key,  required this.totalUserList})
      : super(key: key);



  @override
  State<TotalUserScreen> createState() => _TotalUserScreenState();
}

class _TotalUserScreenState extends State<TotalUserScreen> {
    
  @override
  Widget build(BuildContext context) {
    print(widget.totalUserList.length.toString());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFFFFFF),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Chat',
          style: TextStyle(
              fontSize: 16,
              color: Color(0xff000000),
              fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView.separated(
        itemCount: widget.totalUserList.length,
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: Color(0xff707070),
          );
        },
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => UserDetails(
                  totalUserList: widget.totalUserList[index],
                ))),
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/img1.png'),
            ),
            title: Text(
              widget.totalUserList[index].name,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff000000)),
            ),
            subtitle: Text(
              widget.totalUserList[index].message,
              style: TextStyle(fontSize: 12, color: Color(0xff818181)),
            ),
          );
        },
      ),
    );
  }
}
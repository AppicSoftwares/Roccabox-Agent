import 'package:flutter/material.dart';
import 'package:roccabox_agent/screens/chatscreen.dart';
import 'package:roccabox_agent/screens/user_Detail.dart';
import 'package:roccabox_agent/twilio/callscreen.dart';
import 'package:roccabox_agent/twilio/dialer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Setting.dart';

class AssignedUsersScreen extends StatefulWidget {
List<TotalUserList> totalUserList = [];

AssignedUsersScreen({Key? key,  required this.totalUserList})
      : super(key: key);



  @override
  State<AssignedUsersScreen> createState() => _TotalUserScreenState();
}

class _TotalUserScreenState extends State<AssignedUsersScreen> {

  bool isloading = false;
    
  @override
  Widget build(BuildContext context) {
    print(widget.totalUserList.length.toString());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFFFFFF),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Assigned Users',
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
                  P_Agency_FilterId: widget.totalUserList[index].filter_id,
                  totalUserList: widget.totalUserList[index],
                ))),
            leading:  widget.totalUserList[index].image == null
                                    ? Image.asset(
                                        'assets/avatar.png',
                                      )
                                    : CircleAvatar(
                                      radius: 30,
                                        backgroundImage: NetworkImage(widget.totalUserList[index].image),
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
            trailing: SizedBox(
              width: 70,
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () async {
                        SharedPreferences pref = await SharedPreferences.getInstance();
                        var id = pref.getString("id");
                       // Navigator.push(context, MaterialPageRoute(builder: (context) => DialScreen(senderId:id, receiverId: widget.totalUserList[index].userId, name:  widget.totalUserList[index].name, image: widget.totalUserList[index].image,fcmToken: widget.totalUserList[index].firebase_token,)));
                      },
                      child: Icon(Icons.call, color: Colors.black,size: 24)),
                  SizedBox(width: 20,),
                  GestureDetector(
                      onTap: () async {
                        SharedPreferences pref = await SharedPreferences.getInstance();
                        var id = pref.getString("id");
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(senderId:id, receiverId: widget.totalUserList[index].userId, name:  widget.totalUserList[index].name, image: widget.totalUserList[index].image,fcmToken: widget.totalUserList[index].firebase_token,)));
                      },
                      child: Icon(Icons.chat, color: Colors.black,size: 24)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
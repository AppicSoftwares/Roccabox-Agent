import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:roccabox_agent/screens/notificationindex.dart';
import 'package:roccabox_agent/screens/notifications.dart';
import 'package:roccabox_agent/util/languagecheck.dart';

import '../main.dart';

class Call extends StatefulWidget {
  @override
  _CallState createState() => _CallState();
}

class _CallState extends State<Call> {

  String notiCount = "";
  @override
  Widget build(BuildContext context) {
    LanguageChange languageChange = new LanguageChange();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFFFFFF),
        elevation: 0,
        centerTitle: true,
        title: Text(

          // Call
          languageChange.CALL[langCount],
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
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationIndex()));
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        height: 46,
                        width: 46,
                        decoration: BoxDecoration(
                          color: Color(0xFF979797).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          "assets/Bell.svg",
                          color: Colors.black54,
                        ),
                      ),
                      Visibility(
                        visible: notiCount=="0"?false:true,
                        child: Positioned(
                          top: -3,
                          right: 0,
                          child: Container(
                            height: 16,
                            width: 16,
                            decoration: BoxDecoration(
                              color: Color(0xFFFF4848),
                              shape: BoxShape.circle,
                              border: Border.all(width: 1.5, color: Colors.white),
                            ),
                            child: Center(
                              child: Text(
                                notiCount,
                                style: TextStyle(
                                  fontSize: 10,
                                  height: 1,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
        ],
      ),
      body: ListView.separated(
        itemCount: 15,
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: Color(0xff707070),
          );
        },
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.phone,
                      color: Colors.black,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.videocam_rounded,
                      color: Colors.black,
                    ))
              ],
            ),
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/img1.png'),
            ),
            title: Text(
              'Assigned Agent',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff000000)),
            ),
            subtitle: Text(
              'Sukhdev Place',
              style: TextStyle(fontSize: 12, color: Color(0xff818181)),
            ),
          );
        },
      ),
    );
  }
}

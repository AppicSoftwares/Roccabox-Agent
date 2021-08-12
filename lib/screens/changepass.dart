import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChangePass extends StatefulWidget {
  @override
  _ChangePassState createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 60, left: 10, bottom: 70),
              height: 53,
              width: 145,
              child: SvgPicture.asset('assets/roccabox-logo.svg'),
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text('Agent,',
                  style: TextStyle(
                      fontSize: 26,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      color: Color(0xff000000))),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, bottom: 60),
              child: Text('Sign in to connect!',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w300,
                    fontSize: 22,
                    color: Color(0xff8A8787),
                  )),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                decoration: InputDecoration(
                    labelText:'New Password',

                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xffD2D2D2))),
                    labelStyle:
                        TextStyle(fontSize: 15, color: Color(0xff000000))),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: TextField(
                decoration: InputDecoration(
                    labelText: 'Confirm Password',

                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xffD2D2D2))),
                    labelStyle:
                        TextStyle(fontSize: 15, color: Color(0xff000000))),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              height: 55,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xffFFBA00)),
              child: Center(
                  child: Text(
                'Confirm',
                style: TextStyle(fontSize: 15, color: Color(0xff000000)),
              )),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:roccabox_agent/screens/privacy.dart';
import 'package:roccabox_agent/screens/terms.dart';

import 'aboutUs.dart';
import 'contactus.dart';
import 'language.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFFFFFF),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(
              fontSize: 16,
              color: Color(0xff000000),
              fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              leading: Image.asset('assets/avatar.png'),
              title: Text(
                'Testing User',
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff000000),
                    fontWeight: FontWeight.w600),
              ),
              subtitle: Text('test@gmail.com'),
              trailing: TextButton(
                  onPressed: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => EditProfile()));
                  },
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xffFFBA00),
                      decoration: TextDecoration.underline,
                    ),
                  )),
            ),
            ListTile(
              tileColor: Color(0xffF3F3F3),
              title: Text(
                'Total No. of Clients',
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff000000),
                    fontWeight: FontWeight.w600),
              ),
            ),
            ListTile(
              // onTap: () => Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => PropertyList())),
              //tileColor: Color(0xffF3F3F3),
              title: Text(
                'Total User',
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff000000),
                    fontWeight: FontWeight.w500),
              ),
              trailing: Text(
                '2208',
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff000000),
                    fontWeight: FontWeight.w500),
              ),
            ),
            ListTile(
              tileColor: Color(0xffF3F3F3),
              title: Text(
                'Settings',
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff000000),
                    fontWeight: FontWeight.w600),
              ),
            ),
            ListTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Language()));
                },
                //tileColor: Color(0xffF3F3F3),
                title: Text(
                  'Language(English)',
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff000000),
                      fontWeight: FontWeight.w500),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                )),
            Divider(
              color: Color(0xff707070),
            ),
            ListTile(
              //tileColor: Color(0xffF3F3F3),
              title: Text(
                'Logout',
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff000000),
                    fontWeight: FontWeight.w500),
              ),
            ),
            ListTile(
              tileColor: Color(0xffF3F3F3),
              title: Text(
                'Help',
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff000000),
                    fontWeight: FontWeight.w600),
              ),
            ),
            ListTile(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Privacy())),
                //tileColor: Color(0xffF3F3F3),
                title: Text(
                  'Privacy and security',
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff000000),
                      fontWeight: FontWeight.w500),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                )),
            Divider(
              color: Color(0xff707070),
            ),
            ListTile(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AboutUs())),
                //tileColor: Color(0xffF3F3F3),
                title: Text(
                  'About Us',
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff000000),
                      fontWeight: FontWeight.w500),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                )),
            Divider(
              color: Color(0xff707070),
            ),
            ListTile(
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Terms())),
                //tileColor: Color(0xffF3F3F3),
                title: Text(
                  'Terms & Conditions',
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff000000),
                      fontWeight: FontWeight.w500),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                )),
            Divider(
              color: Color(0xff707070),
            ),
            ListTile(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Contact())),
                //tileColor: Color(0xffF3F3F3),
                //tileColor: Color(0xffF3F3F3),
                title: Text(
                  'Contact Us',
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff000000),
                      fontWeight: FontWeight.w500),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                )),
          ],
        ),
      ),
    );
  }
}

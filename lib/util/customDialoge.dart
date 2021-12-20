import 'package:flutter/material.dart';
import 'package:roccabox_agent/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

showLogoutDialog(BuildContext context) {

  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("No", style: TextStyle(color: Colors.blueAccent),),
    onPressed:  () {
      Navigator.of(context, rootNavigator: true).pop(context);
    },
  );
  Widget continueButton = FlatButton(
    child: Text("Ok", style: TextStyle(color: Colors.blueAccent),),
    onPressed:  () async {
      var pref = await SharedPreferences.getInstance();
      pref.clear();
      pref.commit();
      var result  = new MaterialPageRoute(builder: (context) => Login());
      Navigator.of(context,rootNavigator: true).pushAndRemoveUntil(result, (route) => false);


    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(

    title: Text("Session Expired!", style: TextStyle(fontWeight: FontWeight.bold),),
    content: Text("Please Login Again"),
    actions: [
     // cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:roccabox_agent/services/APIClient.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'login.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool isLoading = false;

  String id = "";
  FirebaseMessaging? auth;
  var token;
  final firestoreInstance = FirebaseFirestore.instance;


  @override
  void initState() {
    
    super.initState();

    


  }


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
           icon: Icon(Icons.exit_to_app), onPressed: () {
              Logout();
          }, )
        ],
      ),

    );
  }

  Future<void> Logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    preferences.commit();
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => Login()), (r)=>false);
  }




}

import 'dart:collection';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:roccabox_agent/agora/dialscreen/dialScreen.dart';
import 'package:roccabox_agent/agora/videoCall/videoCall.dart';
import 'package:roccabox_agent/main.dart';
import 'package:roccabox_agent/screens/assigned_user.dart';
import 'package:roccabox_agent/screens/change_Password.dart';
import 'package:roccabox_agent/screens/edit_profile.dart';
import 'package:roccabox_agent/screens/login.dart';
import 'package:roccabox_agent/screens/privacy.dart';
import 'package:roccabox_agent/screens/terms.dart';
import 'package:roccabox_agent/screens/assigned_users.dart';
import 'package:roccabox_agent/services/APIClient.dart';
import 'package:roccabox_agent/util/customDialoge.dart';
import 'package:roccabox_agent/util/languagecheck.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'aboutUs.dart';
import 'chat.dart';
import 'chatscreen.dart';
import 'contactus.dart';
import 'language.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List data = [];
  List<TotalUserList> totalUserList = [];
  var count = "";
  var email;
  var name;
  var image;
  var myFcm, myImage, myName;
  final firestoreInstance = FirebaseFirestore.instance;
  FirebaseMessaging? auth;
  var id;
  bool isLoading = false;
  UserList user = UserList();
  @override
  void initState() {
    getChatData();
     getData();
    super.initState();

     auth = FirebaseMessaging.instance;
     auth?.getToken().then((value) {
       print("FirebaseToken " + value.toString());
       myFcm = value.toString();
     }
     );
     getUserList();
    isLoading = true;
  }

    LanguageChange languageChange = new LanguageChange();

  @override
  
  Widget build(BuildContext context) {
    print("jjj" + email.toString() + "");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFFFFFF),
        elevation: 0,
        centerTitle: true,
        title: Text(
          //Menu
          languageChange.MENU[langCount],
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
                  EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              leading: image == null || image.toString()=="null"
                                    ? Image.asset(
                                        'assets/avatar.png',
                                      )
                                    : CircleAvatar(
                                      radius: 30,
                                        backgroundImage: NetworkImage(image),
                                      ),
              title: Text(
                (name != null) ? name : "",
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff000000),
                    fontWeight: FontWeight.w600),
              ),
                subtitle: Text(
                  (email.toString() != "null") ?
                    email.toString():""
                   
                ),
                
              trailing: TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => EditProfile())).then((value) => {getData()});
                  },
                  child: Text(

                    //EDIT PROFILE
                    languageChange.EDIT[langCount],
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
                //Total No. of clients
                languageChange.TOTALNOOFCLIENTS[langCount],
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
                  languageChange.Assigned_Enquiries[langCount],
                  // total user //assigned enquires, asigned user
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff000000),
                      fontWeight: FontWeight.w500),
                ),
                trailing: Text(
                  count,
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff000000),
                      fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  if(totalUserList!=null && totalUserList.length>0) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AssignedUsersScreen(
                                    totalUserList: totalUserList)));
                  }
                  }),
           
           ListTile(
                // onTap: () => Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => PropertyList())),
                //tileColor: Color(0xffF3F3F3),
                title: Text(
                  languageChange.Assigned_User[langCount],
                 //asigned user
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff000000),
                      fontWeight: FontWeight.w500),
                ),
                trailing: Text(
                  count,
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff000000),
                      fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  // if(totalUserList!=null && totalUserList.length>0) {
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) =>
                  //               AssignedUsersScreen(
                  //                   totalUserList: totalUserList)));
                  // }

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                             AssignedUser()));
                  }),
           
           
           
            ListTile(
              tileColor: Color(0xffF3F3F3),
              title: Text(
                //Help
                languageChange.HELP[langCount],
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff000000),
                    fontWeight: FontWeight.w600),
              ),
            ),
            ListTile(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AboutUs())),
                //tileColor: Color(0xffF3F3F3),
                title: Text(

                  // about us
                  languageChange.ABOUT[langCount],
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
                onTap: () {
                  print("UserId "+user.id.toString()+"");
                  if(user.id!=null && user.id.toString()!="null" && user.id.toString()!="") {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) =>
                        ChatScreen(name: user.name,
                            image: user.image,
                            receiverId: user.id,
                            senderId: id,
                            fcmToken: user.fcmToken,
                            userType: "admin")));
                  }
                  },
                //tileColor: Color(0xffF3F3F3),
                //tileColor: Color(0xffF3F3F3),
                title: Text(

                  //contact us
                  languageChange.TALKTOADMIN[langCount],
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff000000),
                      fontWeight: FontWeight.w500),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                )),
           /* Divider(
              color: Color(0xff707070),
            ),
            ListTile(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Contact())),
                //tileColor: Color(0xffF3F3F3),
                //tileColor: Color(0xffF3F3F3),
                title: Text(

                  //contact us
                  languageChange.CONTACT[langCount],
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff000000),
                      fontWeight: FontWeight.w500),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                )),*/
                 Divider(
              color: Color(0xff707070),
            ),
            ListTile(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Privacy())),
                //tileColor: Color(0xffF3F3F3),
                title: Text(
                  // privacy and security
                  languageChange.PRIVACY[langCount],
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

                  // Terms and conditions
                  languageChange.TERMS[langCount],
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff000000),
                      fontWeight: FontWeight.w500),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                )),
           
            ListTile(
              tileColor: Color(0xffF3F3F3),
              title: Text(

                //SETTINGS
                languageChange.SETTINGS[langCount],
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
                  //LANGUAGE
                  languageChange.LANGUAGE[langCount],
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
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangePaasword()));
                },
                //tileColor: Color(0xffF3F3F3),
                title: Text(
                  //CHANGE PASSWORD
                  languageChange.CHANGEPASWWORD[langCount],
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
                //LOGOUT
                languageChange.LOGOUT[langCount],
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff000000),
                    fontWeight: FontWeight.w500),
              ),
              onTap: () async {
                showAlertDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
  Future getChatData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    id = pref.getString("id").toString();
    var authToken = pref.getString("auth_token").toString();
    print("AUTH_TOKEN "+authToken.toString());
    Map<String, String> mapheaders = new HashMap();
    mapheaders["Authorization"] = authToken.toString();

    var jsonRes;
    var response =
    await http.post(Uri.parse(RestDatasource.BASE_URL + 'userProfile'),
        headers: mapheaders,
        body: {
          "user_id":"38"
        });

    if (response.statusCode == 200) {
      var apiObj = JsonDecoder().convert(response.body.toString());
      if(apiObj["status"]==true){
        var data = apiObj["data"];
        user = new UserList();
        user.chatType = "user-admin";
        user.name = data["name"];
        user.id = "38";
        user.fcmToken = data["firebase_token"];
        user.image = data["image"];
      }

    } else {
      throw Exception('Failed to load album');
    }
  }
  void updateChatHead(String userid, String name, String image, String type, String fcmToken,String idd, String status, String agoraToken, String channel, String time) async {

    var documentReference = FirebaseFirestore.instance
        .collection('call_master')
        .doc("call_head")
        .collection(userid)
        .doc(time);


    firestoreInstance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        {
          'fcmToken': fcmToken,
          'id': idd,
          'image': image,
          'name': name,
          'timestamp': time,
          'type': type,
          'callType':"incoming",
          'status': status

        },
      );
    }).then((value) {
      var documentReference = FirebaseFirestore.instance
          .collection('call_master')
          .doc("call_head")
          .collection(idd)
          .doc(time);

      firestoreInstance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'fcmToken': myFcm,
            'id': userid,
            'image': myImage,
            'name': myName,
            'timestamp': time,
            'type': type,
            'callType':"outgoing",
            'status':status
          },
        );
      });
    });
    if(type=="VIDEO"){
      Navigator.push(context, new MaterialPageRoute(builder: (context)=> VideoCall(name:name ,image:image, channel: channel, token: agoraToken, myId: userid.toString(),time: time, senderId: idd,)));

    }else{
      Navigator.push(context, new MaterialPageRoute(builder: (context)=> DialScreen(name:name ,image:image, channel: channel, agoraToken: agoraToken,myId: userid.toString(),time: time,receiverId: idd,)));

    }
  }

  Future<dynamic> getUserList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var id = pref.getString("id").toString();
    var authToken = pref.getString("auth_token").toString();
    print("AUTH_TOKEN "+authToken.toString());
    Map<String, String> mapheaders = new HashMap();
    mapheaders["Authorization"] = authToken.toString();

    myName = pref.getString("name").toString();
    myImage = pref.getString("image").toString();
    print("id "+id.toString()+"");
    var request = http.get(Uri.parse(
      RestDatasource.GETASSIGNEDUSER_URL + id,
    ), headers: mapheaders);

    var jsonRes;
    var jsonArray;
    var res;

    await request.then((http.Response response) {
      res = response;
      final JsonDecoder _decoder = new JsonDecoder();
      jsonRes = _decoder.convert(response.body.toString());
      print("Ress" + jsonRes.toString() + "");
    });

    if (res.statusCode == 200) {
      print("Response: " + jsonRes.toString() + "_");

      if (jsonRes["status"].toString() == "true") {
        totalUserList.clear();
        count = jsonRes["count"].toString();
        print("count:" + count + "");
        jsonArray = jsonRes["data"];

        if (jsonArray != null) {
          if (jsonArray.length > 0) {
            for (var i = 0; i < jsonArray.length; i++) {
              TotalUserList modelSearch = new TotalUserList();
              modelSearch.name = jsonArray[i]["name"];
              modelSearch.userId = jsonArray[i]["userId"].toString();
              modelSearch.email = jsonArray[i]["email"].toString();
              modelSearch.phone = jsonArray[i]["phone"].toString();
              modelSearch.enqID = jsonArray[i]["enqID"].toString();
              modelSearch.property_image = jsonArray[i]["property_image"].toString();
              modelSearch.image = jsonArray[i]["image"].toString();
              modelSearch.filter_id = jsonArray[i]["filter_id"].toString();
              modelSearch.firebase_token = jsonArray[i]["firebase_token"].toString();
              modelSearch.property_Rid =
                  jsonArray[i]["property_Rid"].toString();
              modelSearch.message = jsonArray[i]["message"].toString();

              totalUserList.add(modelSearch);
            }
          }
        }
        print("ppr " + totalUserList.length.toString() + "^");

        setState(() {
          isLoading = false;
        });
   } else {
        setState(() {
          isLoading  = false;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(jsonRes["message"].toString())));
          if(jsonRes["code"]!=null){
            if(jsonRes["code"]==403){
              showLogoutDialog(context);
            }
          }
        });
      }
    } else {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please try later")));

      });
    }
     getData();
  }

  void getData()async  {
     SharedPreferences pref = await SharedPreferences.getInstance();
    var id = pref.getString("id").toString();
    email = pref.getString("email").toString();
    name = pref.getString("name").toString();
    image = pref.getString("image").toString();

    print("yyy" + email.toString() + "");
    setState(() {
      
    });
  }

  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("No", style: TextStyle(color: Colors.blueAccent),),
      onPressed:  () {
        Navigator.of(context, rootNavigator: true).pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Yes", style: TextStyle(color: Colors.blueAccent),),
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
      title: Text("Logout", style: TextStyle(fontWeight: FontWeight.bold),),
      content: Text("Are you sure you want to logout?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}

class TotalUserList {
  String name = "";
  String email = "";
  String phone = "";
  String userId = "";
  String enqID = "";
  String property_Rid = "";
  String message = "";
  String property_image = "";
  String image = "";
  String filter_id = "";
  String firebase_token = "";
}

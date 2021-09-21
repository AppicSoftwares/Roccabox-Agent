import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:roccabox_agent/main.dart';
import 'package:roccabox_agent/screens/change_Password.dart';
import 'package:roccabox_agent/screens/edit_profile.dart';
import 'package:roccabox_agent/screens/login.dart';
import 'package:roccabox_agent/screens/privacy.dart';
import 'package:roccabox_agent/screens/terms.dart';
import 'package:roccabox_agent/screens/assigned_users.dart';
import 'package:roccabox_agent/services/APIClient.dart';
import 'package:roccabox_agent/util/languagecheck.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'aboutUs.dart';
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
  

  
  
  bool isLoading = false;

  @override
  void initState() {
     getData();
    super.initState();
   
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
                  EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              leading: Image.asset('assets/avatar.png'),
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
                        MaterialPageRoute(builder: (context) => EditProfile()));
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
                  languageChange.TOTALUSER[langCount],
                  // total user
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
                )),
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
                var pref = await SharedPreferences.getInstance();

                pref.clear();
                pref.commit();
                Navigator.pushAndRemoveUntil(
                    context,
                    new MaterialPageRoute(builder: (context) => Login()),
                    (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> getUserList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var id = pref.getString("id").toString();
   
    var request = http.get(Uri.parse(
      RestDatasource.GETASSIGNEDUSER_URL + id,
    ));

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
        // Fluttertoast.showToast(
        //     msg: jsonRes["message"].toString(),
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.CENTER,
        //     timeInSecForIosWeb: 2,
        //     backgroundColor: Colors.green,
        //     textColor: Colors.white,
        //     fontSize: 16.0);
        // print("Data " + jsonRes['data']['token'] + "*");
      } else {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(jsonRes["message"].toString())));
          // Fluttertoast.showToast(
          //     msg: "Exception: " + jsonRes["message"].toString(),
          //     toastLength: Toast.LENGTH_SHORT,
          //     gravity: ToastGravity.CENTER,
          //     timeInSecForIosWeb: 2,
          //     backgroundColor: Colors.red,
          //     textColor: Colors.white,
          //     fontSize: 16.0);
        });
      }
    } else {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please try leter")));
        // Fluttertoast.showToast(
        //     msg: "Exception: " + jsonRes["message"].toString(),
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.CENTER,
        //     timeInSecForIosWeb: 2,
        //     backgroundColor: Colors.red,
        //     textColor: Colors.white,
        //     fontSize: 16.0);
      });
    }
     getData();
  }

  void getData()async  {
     SharedPreferences pref = await SharedPreferences.getInstance();
    var id = pref.getString("id").toString();
    email = pref.getString("email").toString();
    name = pref.getString("name").toString();

    print("yyy" + email.toString() + "");
    setState(() {
      
    });
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
}

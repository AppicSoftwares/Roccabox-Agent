import 'dart:convert';
import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:roccabox_agent/main.dart';
import 'package:roccabox_agent/services/APIClient.dart';
import 'package:roccabox_agent/util/languagecheck.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePaasword extends StatefulWidget {
  const ChangePaasword({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<ChangePaasword> {
  bool isloading = false;

  @override
  void initState() {
    super.initState();
 
  }

  var oldPassword, newPassword, confirmPassword, id;
  TextEditingController oldPasswordController = new TextEditingController();
  TextEditingController newPasswordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    LanguageChange languageChange = new LanguageChange();
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        backgroundColor: Color(0xffFFFFFF),
        elevation: 0,
        centerTitle: true,
        title: Text(
          //Update Password
          languageChange.PASSWORDUPDATE[langCount]
          ,
          style: TextStyle(
              fontSize: 16,
              color: Color(0xff000000),
              fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(10, 30, 10, 0),
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      Text(
                        // Change Password
                        languageChange.CHANGEPASWWORD[langCount],
                        style:
                            TextStyle(color: Color(0xffFFBA00), fontSize: 30),
                      ),
                      SizedBox(height: 3),
                      Text(
                        //Create your new secured password
                        languageChange.CREATEYOURNEWPASSWORD[langCount],
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Text(
                    // Old Password
                    languageChange.OLDPASSWORD[langCount],
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff000000)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                  child: TextFormField(
                    controller: oldPasswordController,
                  
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please Enter Your Old Password';
                      }

                      return null;
                    },
                    onChanged: (val) {},
                    // controller: uptname,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Text(
                    //New Password
                    languageChange.NEWPASSWORD[langCount],
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff000000)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                  child: TextFormField(
                    controller: newPasswordController,
                    validator: (val) {},
                    // controller: uptemail,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Text(
                    //Confirm Password
                    languageChange.CONFIRMPASSWORD[langCount],
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff000000)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                  child: TextFormField(
                    controller: confirmPasswordController,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please Enter Your Old Password';
                      }

                      return null;
                    },
                    onChanged: (val) {},
                    // controller: uptname,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                isloading
                    ? Align(
                        alignment: Alignment.center,
                        child: Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Platform.isAndroid
                                ? CircularProgressIndicator()
                                : CupertinoActivityIndicator()))
                    : GestureDetector(
                        onTap: () {
                          print("hhyy"+oldPasswordController.text.toString().trim());
                          if (newPasswordController.text.toString().trim() !=
                              confirmPasswordController.text
                                  .toString()
                                  .trim()) {
                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Confirm Password and new Password should be same')));
                         
                          } else if (oldPasswordController.text.toString().trim().isEmpty) {
                            

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Please enter old password')));
                          }else{
                                 changePassword(
                              oldPasswordController.text.toString().trim(),
                              newPasswordController.text.toString().trim(),
                            );
                         }
                        },
                        child: Container(
                          height: 50,
                          // width: 122,
                          // height: 30,
                          margin: EdgeInsets.only(top: 20),
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          decoration: BoxDecoration(
                            color: Color(0xffFFBA00),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(

                              //Update Password
                              languageChange.UPDATEPROFILE[langCount],
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> changePassword(String oldPassword, String newPassword) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var id = pref.getString("id").toString();
    setState(() {
      isloading = true;
    });
    print(id.toString);
    print(oldPassword);
    print(newPassword);
    String msg = "";
    var jsonRes;
    http.Response? res;
    var request = http.post(
        Uri.parse(RestDatasource.CHANGEPASSWORD_URL
            // RestDatasource.SEND_OTP,
            ),
        body: {
          "user_id": id,
          "oldPassword": oldPassword,
          "newPassword": newPassword,
        });

    await request.then((http.Response response) {
      res = response;
      // msg = jsonRes["message"].toString();
      // getotp = jsonRes["otp"];
      // print(getotp.toString() + '123');
    });
    if (res!.statusCode == 200) {
      final JsonDecoder _decoder = new JsonDecoder();
      jsonRes = _decoder.convert(res!.body.toString());
      print("Response: " + res!.body.toString() + "_");
      print("ResponseJSON: " + jsonRes.toString() + "_");
      print("status: " + jsonRes["status"].toString() + "_");

      if (jsonRes["status"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonRes["message"].toString())),
        );

        // print('getotp1: ' + getotp.toString());
        Navigator.pop(context);

        setState(() {
          isloading = false;
        });
      }
      if (jsonRes["status"] == false) {
        setState(() {
          isloading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonRes["message"].toString())),
        );
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error while fetching data')));

      setState(() {
        isloading = false;
      });
    }
  }
}

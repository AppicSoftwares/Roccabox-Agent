import 'dart:convert';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:roccabox_agent/screens/changepass.dart';
import 'package:roccabox_agent/screens/signup.dart';
import 'package:http/http.dart' as http;
import 'package:roccabox_agent/services/APIClient.dart';

class Forgot extends StatefulWidget {
  @override
  _ForgotState createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  final formkey = GlobalKey<FormState>();
  String? email;
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                margin: EdgeInsets.only(left: 10, bottom: 50),
                child: Text('Forgot\nPassword',
                    style: TextStyle(
                        fontSize: 26,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Color(0xff000000))),
              ),
              Form(
                key: formkey,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    showCursor: true,
                    inputFormatters: [
                      BlacklistingTextInputFormatter(RegExp(r"\s"))
                    ],
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (val) {
                      email = val;
                    },
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please Enter your Email';
                      }
                      if (!EmailValidator.validate(email.toString())) {
                        return 'Please Enter valid Email Id';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: 'Email Id',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Color(0xffD2D2D2))),
                        labelStyle:
                            TextStyle(fontSize: 15, color: Color(0xff000000))),
                  ),
                ),
              ),
              isloading
                  ? Align(
                      alignment: Alignment.center,
                      child: Platform.isAndroid
                          ? CircularProgressIndicator()
                          : CupertinoActivityIndicator())
                  : GestureDetector(
                      onTap: () {
                        if (formkey.currentState!.validate()) {
                          if (EmailValidator.validate(email.toString())) {
                            forgotPassword(email.toString());
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) => ChangePass()));
                          }
                        }
                      },
                      // onTap: () {

                      // },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        height: 55,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xffFFBA00)),
                        child: Center(
                            child: Text(
                          'Send Verification Email',
                          style:
                              TextStyle(fontSize: 15, color: Color(0xff000000)),
                        )),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don’t have an account?',
                      style: TextStyle(fontSize: 16, color: Color(0xff000000)),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Signup()));
                        },
                        child: Text('Sign up',
                            style: TextStyle(
                                fontSize: 16, color: Color(0xffFFBA00))))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> forgotPassword(String email) async {
    setState(() {
      isloading = true;
    });

    print(email);
    String msg = "";
    var jsonRes;
    http.Response? res;
    var request = http.post(Uri.parse(RestDatasource.FORGOTPASSWORD_URL),
        body: {"email": email.toString()});

    await request.then((http.Response response) {
      res = response;
    });

    if (res!.statusCode == 200) {
      final JsonDecoder _decoder = new JsonDecoder();
      jsonRes = _decoder.convert(res!.body.toString());
      print("Response: " + res!.body.toString() + "_");
      print("ResponseJSON: " + jsonRes.toString() + "_");
      print("status: " + jsonRes["status"].toString() + "_");
      print("message: " + jsonRes["message"].toString() + "_");

      setState(() {
        isloading = false;
      });
      if (jsonRes["status"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonRes["message"].toString())));

        Navigator.pop(context);
      } else {
        setState(() {
          isloading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonRes["message"].toString())));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error while fetvhing data')));
    }
  }
}

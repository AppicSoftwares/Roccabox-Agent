import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:roccabox_agent/screens/login.dart';

import 'package:http/http.dart' as http;
import 'package:roccabox_agent/services/APIClient.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final formkey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool obscure = true;
  String? phone;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
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
                child: Text('Sign up to get started!',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w300,
                      fontSize: 22,
                      color: Color(0xff8A8787),
                    )),
              ),
              Form(
                key: formkey,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        showCursor: true,
                        inputFormatters: [
                          BlacklistingTextInputFormatter(RegExp(r"\s"))
                        ],
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please Enter your Email';
                          }
                          if (!EmailValidator.validate(email.toString())) {
                            return 'Please Enter valid Email Id';
                          }
                          return null;
                        },
                        onChanged: (val) {
                          email = val;
                        },
                        decoration: InputDecoration(
                            labelText: 'Email Id',

                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Color(0xffD2D2D2))),
                            labelStyle: TextStyle(
                                fontSize: 15, color: Color(0xff000000))),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                      child: TextFormField(
                        onChanged: (val) {
                          phone = val;
                        },
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please Enter Your phone number';
                          }
                          return null;
                        },
                        maxLength: 10,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                            counterText: "",
                            labelText:'Phone Number',

                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Color(0xffD2D2D2))),
                            labelStyle: TextStyle(
                                fontSize: 15, color: Color(0xff000000))),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      child: TextFormField(
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please Enter Your Password';
                          }
                          return null;
                        },
                        onChanged: (val) {
                          password = val;
                        },
                        obscureText: obscure,
                        inputFormatters: [FilteringTextInputFormatter.deny(" ")],
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: obscure
                                    ? Icon(
                                        Icons.visibility_outlined,
                                      )
                                    : Icon(
                                        Icons.visibility_off_outlined,
                                      ),
                                onPressed: () {
                                  setState(() {
                                    obscure = !obscure;
                                  });
                                }),
                            labelText:'Password',

                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Color(0xffD2D2D2))),
                            labelStyle: TextStyle(
                                fontSize: 15, color: Color(0xff000000))),
                      ),
                    ),
                  ],
                ),
              ),
              isLoading==true?Center(child: CircularProgressIndicator(),):  GestureDetector(
                onTap: () {
                  if (formkey.currentState!.validate()) {
                    if (EmailValidator.validate(email.toString())) {
                        setState(() {
                          isLoading = true;

                        });
                        postApi(email.toString(), password.toString(), phone.toString());


                    }
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  height: 55,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xffFFBA00)),
                  child: Center(
                      child: Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 15, color: Color(0xff000000)),
                  )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(fontSize: 16, color: Color(0xff000000)),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                        child: Text('Login',
                            style: TextStyle(
                                fontSize: 16, color: Color(0xffFFBA00))))
                  ],
                ),
              ),
              Center(
                child: Text(
                  'Need to wait for Admin’s Approval',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Color(0xff000000)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }




  Future<dynamic> postApi(
  String email, String password, String phone) async {
    print("email: " + email.toString().trim() + "_");
    print("password: " + password.toString().trim() + "_");
    print("phone: " + phone.toString().trim() + "_");
    print("role_id: " +  "2");
    var jsonRes;
    late http.Response res;
    String msg = "";
    var request = http.post(
        Uri.parse(
          RestDatasource.SIGNUP_URL ,
        ),
        body:{
          "email":email.toString().trim(),
          "password":password.toString().trim(),
          "phone":phone.toString().trim(),
          "role_id":"2"
        }
    );



/*    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': token
    };
    //request.files.add(await http.MultipartFile.fromPath(base64Image, fileName));
    if (file != null) {
      request.files.add(http.MultipartFile('image',
          File(file.path).readAsBytes().asStream(), File(file.path).lengthSync(),
          filename: fileName));
    }*/
    await request.then((http.Response response){
      res = response;
      final JsonDecoder _decoder = new JsonDecoder();
      jsonRes = _decoder.convert(response.body.toString());
      print("Response: " + response.body.toString() + "_");
      print("ResponseJSON: " + jsonRes.toString() + "_");
      print("status: " + jsonRes["status"].toString() + "_");
      print("message: " + jsonRes["message"].toString() + "_");
      msg = jsonRes["message"].toString();
    });
    // var respone = await res.stream.bytesToString();


    if(res!=null) {
      if (res.statusCode == 200) {
        if (jsonRes["status"] == 200) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('id', jsonRes["data"]["id"].toString());
          prefs.setString('email', jsonRes["data"]["email"].toString());
          prefs.commit();

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(msg)));
          setState(() {
            isLoading = false;
          });
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) => HomePage()), (r)=>false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(msg)));
          setState(() {
            isLoading = false;

          });
        }
      } else {

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error while fetching data')));
        setState(() {
          isLoading = false;
          /* Fluttertoast.showToast(
              msg: "Exception: " + jsonRes["message"].toString(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);*/
        });
      }
    }else{
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
          msg: "Error while fetching data",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}

import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:roccabox_agent/screens/homenav.dart';
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
  String? name;
  String? email;
  String? password;
  bool obscure = true;
  String? phone;
  bool isLoading = false;
  String? firstname;
  String? lastname;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 60, left: 10, bottom: 10),
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
                margin: EdgeInsets.only(left: 10, bottom: 20),
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
<<<<<<< HEAD
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                      child: TextFormField(
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please Enter Your First Name';
                          }
                          if (val.length < 4) {
                            return 'The Full Name should be more then 4 characters';
                          }

                          return null;
                        },
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.deny(" ")
                        // ],
                        onChanged: (val) {
                          firstname = val;
                        },
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            label: Text(
                              'First Name',
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Color(0xffD2D2D2))),
                            labelStyle: TextStyle(
                                fontSize: 15, color: Color(0xff000000))),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                      child: TextFormField(
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please Enter Your Last Name';
                          }
                          if (val.length < 4) {
                            return 'The Full Name should be more then 4 characters';
                          }

                          return null;
                        },
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.deny(" ")
                        // ],
                        onChanged: (val) {
                          lastname = val;
                        },
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            label: Text(
                              'Last Name',
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Color(0xffD2D2D2))),
=======
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextFormField(
                        showCursor: true,
                        inputFormatters: [
                          WhitelistingTextInputFormatter(RegExp(r"[a-zA-Z]+|\s")),
                        ],
                        keyboardType: TextInputType.name,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please Enter your Name';
                          }
                          return null;
                        },
                        onChanged: (val) {
                          name = val;
                        },
                        decoration: InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Color(0xffD2D2D2))
                            ),
>>>>>>> 4472561cc9a75b5e123d235ac0039c845954bd87
                            labelStyle: TextStyle(
                                fontSize: 15, color: Color(0xff000000))),
                      ),
                    ),
                    Container(
<<<<<<< HEAD
                      margin: EdgeInsets.symmetric(horizontal: 10),
=======
                      margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
>>>>>>> 4472561cc9a75b5e123d235ac0039c845954bd87
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
                                borderSide:
                                    BorderSide(color: Color(0xffD2D2D2))),
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
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            prefixIcon: CountryCodePicker(
                              // showFlag: false,
                              onChanged: print,
                              // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                              initialSelection: 'IN',
                              favorite: ['+91', 'FR'],
                              // optional. Shows only country name and flag
                              showCountryOnly: false,
                              // optional. Shows only country name and flag when popup is closed.
                              showOnlyCountryWhenClosed: false,
                              // optional. aligns the flag and the Text left
                              alignLeft: false,
                            ),
                            counterText: "",
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Color(0xffD2D2D2))),
                            labelStyle: TextStyle(
                                fontSize: 15, color: Color(0xff000000))),
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(" ")
                        ],
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
                            labelText: 'Password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Color(0xffD2D2D2))),
                            labelStyle: TextStyle(
                                fontSize: 15, color: Color(0xff000000))),
                      ),
                    ),
                  ],
                ),
              ),
<<<<<<< HEAD
              isLoading == true
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : GestureDetector(
                      onTap: () {
                        if (formkey.currentState!.validate()) {
                          if (EmailValidator.validate(email.toString())) {
                            setState(() {
                              isLoading = true;
                            });
                            postApi(
                                email.toString(),
                                password.toString(),
                                phone.toString(),
                                firstname.toString() +
                                    ' ' +
                                    lastname.toString());
                          }
                        }
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        height: 55,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xffFFBA00)),
                        child: Center(
                            child: Text(
                          'Sign Up',
                          style:
                              TextStyle(fontSize: 15, color: Color(0xff000000)),
                        )),
                      ),
                    ),
=======
              isLoading==true?Center(child: CircularProgressIndicator(),):  GestureDetector(
                onTap: () {
                  if (formkey.currentState!.validate()) {
                    if (EmailValidator.validate(email.toString())) {
                        setState(() {
                          isLoading = true;

                        });
                        postApi(name.toString(),email.toString(), password.toString(), phone.toString());


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
>>>>>>> 4472561cc9a75b5e123d235ac0039c845954bd87
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

<<<<<<< HEAD
  Future<dynamic> postApi(
      String email, String password, String phone, String name) async {
=======



  Future<dynamic> postApi( String name,
  String email, String password, String phone) async {
    print("name: " + email.toString().trim() + "_");
>>>>>>> 4472561cc9a75b5e123d235ac0039c845954bd87
    print("email: " + email.toString().trim() + "_");
    print("password: " + password.toString().trim() + "_");
    print("phone: " + phone.toString().trim() + "_");
    print("role_id: " + "2");
    var jsonRes;
    late http.Response res;
    String msg = "";
    var request = http.post(
        Uri.parse(
          RestDatasource.SIGNUP_URL,
        ),
<<<<<<< HEAD
        body: {
          "email": email.toString().trim(),
          "password": password.toString().trim(),
          "phone": phone.toString().trim(),
          "role_id": "2",
          'name': name.toString()
        });
=======
        body:{
          "name":name.toString().trim(),
          "email":email.toString().trim(),
          "password":password.toString().trim(),
          "phone":phone.toString().trim(),
          "role_id":"2"
        }
    );


>>>>>>> 4472561cc9a75b5e123d235ac0039c845954bd87

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
    await request.then((http.Response response) {
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

    if (res.statusCode == 200) {
      if (jsonRes["status"] == 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg)));
        setState(() {
          isLoading = false;
        });

<<<<<<< HEAD
        // Navigator.pushAndRemoveUntil(context,
        //     MaterialPageRoute(builder: (context) => HomePage()), (r) => false);
=======
    if(res!=null) {
      if (res.statusCode == 200) {
        if (jsonRes["status"] == true) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('id', jsonRes["data"]["id"].toString());
          prefs.setString('email', jsonRes["data"]["email"].toString());
          prefs.setString('name', jsonRes["data"]["name"].toString());
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
>>>>>>> 4472561cc9a75b5e123d235ac0039c845954bd87
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        print('done');
        prefs.setString('id', jsonRes["data"]["id"].toString());
        prefs.setString('email', jsonRes["data"]["email"].toString());
        prefs.commit();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeNav()),
            (route) => false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('home')));
        setState(() {
          isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error while fetching data')));
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
  }
}

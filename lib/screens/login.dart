import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:roccabox_agent/screens/forgot.dart';
import 'package:roccabox_agent/screens/homenav.dart';
import 'package:roccabox_agent/screens/signup.dart';
import 'package:http/http.dart' as http;
import 'package:roccabox_agent/services/APIClient.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formkey = GlobalKey<FormState>();
  bool obscure = true;
  String? email;
  String? pass;
  bool isLoading = false;
  String? name;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container(
              //   margin: EdgeInsets.only(top: 60, left: 10, bottom: 70),
              //   height: 53,
              //   width: 145,
              //   child: SvgPicture.asset('assets/roccabox-logo.svg'),
              // ),
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * .07,
                    bottom: MediaQuery.of(context).size.height * .05,
                    left: 10),
                height: 53,
                width: 145,
                child: SvgPicture.asset('assets/roccabox-logo.svg'),
              ),
              // Container(
              //   margin: EdgeInsets.only(left: 10),
              //   child: Text('Agent,',
              //       style: TextStyle(
              //           fontSize: 26,
              //           fontFamily: 'Poppins',
              //           fontWeight: FontWeight.bold,
              //           color: Color(0xff000000))),
              // ),
              Container(
                  margin: EdgeInsets.only(left: 10, bottom: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Agent,',
                          style: TextStyle(
                              fontSize: 26,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              color: Color(0xff000000))),
                      Text('Sign In to connect!',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w300,
                            fontSize: 22,
                            color: Color(0xff8A8787),
                          ))
                    ],
                  )),
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
                          onChanged: (val) {
                            email = val;
                          },
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Please Enter your Email';
                            }
                            if (!EmailValidator.validate(email.toString())) {
                              return 'Please Enter Valid Email Id';
                            }
                            return null;
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
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        child: TextFormField(
                          obscureText: obscure,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Please Enter Your Password';
                            }

                            return null;
                          },
                          onChanged: (val) {
                            pass = val;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(" ")
                          ],
                          // obscure
                          //         ? Icon(Icons.visibility_outlined)
                          //         : Icon(Icons.visibility_off),
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
                  )),
              isLoading == true
                  ? Center(
                      child: Image.asset("assets/loader2.gif",
                      width: 60,
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        if (formkey.currentState!.validate()) {
                          if (EmailValidator.validate(email.toString())) {
                            setState(() {
                              isLoading = true;
                            });
                            postApi(email.toString(), pass.toString(), );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Please enter a valid email')));
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
                          'Login',
                          style:
                              TextStyle(fontSize: 15, color: Color(0xff000000)),
                        )),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
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
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Forgot()));
                  },
                  child: Text(
                    'Forgot Password?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Color(0xff000000)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> postApi(String email, String password, ) async {

    print("email: " + email.toString().trim() + "_");
    print("password: " + password.toString().trim() + "_");
    print("role_id: " + "2");
    print("name: " + name.toString().trim() + "_");
    var jsonRes;
    late http.Response res;
    String msg = "";
    var request = http.post(
        Uri.parse(
          RestDatasource.LOGIN_URL,
        ),
        body: {
          "email": email.toString().trim(),
          "password": password.toString().trim(),
          "role_id": "2",
         
        });

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
    try{
      await request.then((http.Response response) {
        res = response;
        final JsonDecoder _decoder = new JsonDecoder();
        jsonRes = _decoder.convert(res.body.toString());


      });
    }catch(e){
      print(e.toString());

      setState(() {
        isLoading = false;
      });
    }


    // var respone = await res.stream.bytesToString();

    if (res != null) {
      if (res.statusCode == 200) {
        print("Response: " + res.toString() + "_");
        print("ResponseJSON: " + jsonRes.toString() + "_");
        msg = jsonRes["message"].toString();
        if (jsonRes["status"] == true) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('id', jsonRes["data"]["id"].toString());
          prefs.setString('email', jsonRes["data"]["email"].toString());
          prefs.setString('name', jsonRes["data"]["name"].toString());
          prefs.setString('phone', jsonRes["data"]["phone"].toString());

          prefs.commit();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(msg)));
          setState(() {
            isLoading = false;
          });
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) => HomeNav()), (r) => false);
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(msg)));
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
    } else {
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

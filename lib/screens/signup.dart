import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:roccabox_agent/screens/login.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                          label: Text(
                            'Email Id',
                          ),
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
                          label: Text(
                            'Phone Number',
                          ),
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
                          label: Text(
                            'Password',
                          ),
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
            GestureDetector(
              onTap: () {
                if (formkey.currentState!.validate()) {
                  if (EmailValidator.validate(email.toString())) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
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
    );
  }
}

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:roccabox_agent/screens/changepass.dart';
import 'package:roccabox_agent/screens/signup.dart';

class Forgot extends StatefulWidget {
  @override
  _ForgotState createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  final formkey = GlobalKey<FormState>();
  String? email;
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
              GestureDetector(
                onTap: () {
                  if (formkey.currentState!.validate()) {
                    if (EmailValidator.validate(email.toString())) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Verification Email sent!')),
                      );
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => ChangePass()));
                    }
                  }
                },
                // onTap: () {

                // },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  height: 55,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xffFFBA00)),
                  child: Center(
                      child: Text(
                    'Send Verification Email',
                    style: TextStyle(fontSize: 15, color: Color(0xff000000)),
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
}

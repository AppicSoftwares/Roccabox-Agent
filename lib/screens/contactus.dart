import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:roccabox_agent/main.dart';
import 'package:roccabox_agent/util/languagecheck.dart';

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  @override
  Widget build(BuildContext context) {

  LanguageChange languagecheck = new LanguageChange();

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        backgroundColor: Color(0xffFFFFFF),
        elevation: 0,
        centerTitle: true,
        title: Text(

          // Contact Us
          languagecheck.CONTACT[langCount],
          style: TextStyle(
              fontSize: 16,
              color: Color(0xff000000),
              fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Text(
                  //name
                  languagecheck.NAME[langCount],
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff000000)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                child: TextField(
                  decoration: InputDecoration(
                      labelText: languagecheck.NAME[langCount],
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Text(
                  //Email
                  languagecheck.EMAIL[langCount],
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff000000)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                child: TextField(
                  decoration: InputDecoration(
                      labelText: 'test@gmail.com',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Text(
                  //Phone Number
                  languagecheck.PHONENUMBER[langCount],
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff000000)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: CountryCodePicker(
                        // showFlag: false,
                        onChanged: print,
                        // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                        initialSelection: 'gb',
                        // favorite: ['+91', 'FR'],
                        // optional. Shows only country name and flag
                        showCountryOnly: false,
                        // optional. Shows only country name and flag when popup is closed.
                        showOnlyCountryWhenClosed: false,
                        // optional. aligns the flag and the Text left
                        alignLeft: false,
                      ),
                      labelText: '9876543210',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Text(
                //Message
                languagecheck.MESSAGE[langCount],
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff000000)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 20),
                child: TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    //Type a message
                      hintText: languagecheck.TYPEAMESSAGE[langCount],
                      // label: Text(
                      //   'Enter Price',
                      // ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Color(0xffFFBA00),
                    borderRadius: BorderRadius.circular(10)),
                height: 50,
                child: Center(
                    child: Text(
                      //Next
                      languagecheck.NEXT[langCount],
                        style: TextStyle(fontSize: 16, color: Colors.white))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

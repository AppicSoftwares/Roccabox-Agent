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

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var name, email, phone, id, image;
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController numberController = new TextEditingController();
  @override
  void initState() {
    getData();
    super.initState();
  }

  String? uptname;
  String? uptemail;
  String? uptphone;
  // TextEditingController uptname = TextEditingController();
  // TextEditingController uptemail = TextEditingController();
  // TextEditingController uptname = TextEditingController();

  String base64Image = "";
  String fileName = "";
  File? file;
  bool isLoading = false;
  final picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        file = File(pickedFile.path);
      });
      base64Image = base64Encode(file!.readAsBytesSync());
    } else {
      print('No image selected.');
    }

    fileName = file!.path.split("/").last;
    print("ImageName: " + fileName.toString() + "_");
    print("Image: " + base64Image.toString() + "_");
    setState(() {});
  }

  Future<dynamic> uploadImage(
    String firstName,
    String email,
  ) async {
    print("Id "+id+"");
    var request = http.MultipartRequest(
      "POST",
      Uri.parse(
        RestDatasource.BASE_URL + "updateProfile",
      ),
    );
    if(email.toString() != "null" || email.toString()!="") {
      request.fields["email"] = email;
    }
    if(firstName.toString() != "null" || firstName.toString()!="") {
      request.fields["name"] = firstName;
    }

    request.fields["id"] = id;
    //request.files.add(await http.MultipartFile.fromPath(base64Image, fileName));
    if (file != null) {
      request.files.add(http.MultipartFile(
          'image',
          File(file!.path).readAsBytes().asStream(),
          File(file!.path).lengthSync(),
          filename: fileName));
    }
    var jsonRes;
    var res = await request.send();
 // print("ResponseJSON: " + respone.toString() + "_");
    // print("status: " + jsonRes["success"].toString() + "_");
    // print("message: " + jsonRes["message"].toString() + "_");

    if (res.statusCode == 200) {
      var respone = await res.stream.bytesToString();
      final JsonDecoder _decoder = new JsonDecoder();
      jsonRes = _decoder.convert(respone.toString());
      print("Response: " + jsonRes.toString() + "_");
      print(jsonRes["status"]);
      if (jsonRes["status"].toString() == "true") {

        SharedPreferences prefs = await SharedPreferences.getInstance();
        // prefs.setString('id', jsonRes["data"]["id"].toString());
        prefs.setString('email', jsonRes["data"]["email"].toString());
        prefs.setString('image', jsonRes["data"]["image"].toString());
        prefs.setString('name', jsonRes["data"]["name"].toString());
        prefs.setString('phone', jsonRes["data"]["phone"].toString());
        

        


        // prefs.setString('phone', jsonRes["data"]["phone"].toString());
        prefs.commit();
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonRes["message"].toString())));
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
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Please try leter")));
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
  }

  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    LanguageChange languageChange = new LanguageChange();
 


    //  file == null ? print('null') : print(file!.path);
    image != null ? print(image) : print("imagenotfound");
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        backgroundColor: Color(0xffFFFFFF),
        elevation: 0,
        centerTitle: true,
        title: Text(

          // Profile
          languageChange.PROFILE[langCount],
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
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    height: 100,
                    width: 110,
                    child: GestureDetector(
                      onTap: () => getImage(),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          FittedBox(
                            child: file == null
                                ? image == null
                                    ? Image.asset(
                                        'assets/avatar.png',
                                      )
                                    : CircleAvatar(
                                        backgroundImage: NetworkImage(image),
                                      )
                                : CircleAvatar(
                                    backgroundImage:
                                        FileImage(File(file!.path)),
                                  ),
                          ),
                          Positioned(
                              right: 0,
                              bottom: 0,
                              child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Color(0xffEEEEEE),
                                  child: Icon(Icons.edit)))
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Text(
                    //Name
                    languageChange.NAME[langCount],
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
                    controller: nameController,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please Enter Your Name';
                      }

                      return null;
                    },
                    onChanged: (val) {
                      uptname = val;
                    },
                    // controller: uptname,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Text(
                    //Email
                    languageChange.EMAIL[langCount],
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
                    controller: emailController,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please Enter Your Email Id';
                      }
                      if (!EmailValidator.validate(emailController.text.toString().trim())) {
                        return 'Please Enter valid Email Id';
                      }
                      return null;
                    },
                    inputFormatters: [FilteringTextInputFormatter.deny(" ")],
                    onChanged: (val) {
                      uptemail = val;
                    },
                    // controller: uptemail,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Text(
                    //Phone Number
                    languageChange.PHONENUMBER[langCount],
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
                    controller: numberController,
                    enabled: false,
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
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                isLoading
                    ? Align(
                        alignment: Alignment.center,
                        child: Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Platform.isAndroid
                                ? CircularProgressIndicator()
                                : CupertinoActivityIndicator()))
                    : GestureDetector(
                        onTap: () {
                          if (formkey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                        print("UpdateName "+uptname.toString()+"^^");
                        print("UpdateEmail "+uptemail.toString()+"^^");
                        print("UpdatePhone "+uptphone.toString()+"^^");
                        if(uptname==null){
                          uptname = nameController.text.toString();
                        }
                            if(uptemail==null){
                              uptemail = emailController.text.toString();
                            }
                            uploadImage(uptname.toString(), uptemail.toString());

                            // userRegister(email.toString(), phone.toString(),
                            //     firstname.toString() + ' ' + lastname.toString());
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
                              //update profile
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

  void getData() async {
    var pref = await SharedPreferences.getInstance();
    name = pref.getString("name");
    nameController.text = pref.getString("name").toString();
    email = pref.getString("email");
    emailController.text = pref.getString("email").toString();
    phone = pref.getString("phone");
    numberController.text = pref.getString("phone").toString();
    image = pref.getString("image");
    id = pref.getString("id").toString();
    print("name " + name + "");
    print("id " + id + "");
    print("email " + email + "");
    print("image " + image + "");
    print("phone " + phone + "");
    setState(() {});
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:roccabox_agent/services/APIClient.dart';
/*
Future<dynamic> uploadImage(
    File image,
    String firstName,
    String lastName,
    String restroName,
    String restroAddress,
String token,
    String mobile) async {
  var request = http.MultipartRequest(
    "POST",
    Uri.parse(
      RestDatasource.BASE_URL + "editVendorProfile",
    ),
  );
  Map<String, String> headers = {
    'Content-Type': 'multipart/form-data',
    'Authorization': token
  };
  request.headers["Content-Type"] = 'multipart/form-data';
  request.headers["Authorization"] = token;
  request.fields["restro_name"] = restroName;
  request.fields["restro_address"] = restroAddress;
  request.fields["first_name"] = firstName;
  request.fields["last_name"] = lastName;
  request.fields["mobile"] = mobile;
  //request.files.add(await http.MultipartFile.fromPath(base64Image, fileName));
  if (file != null) {
    request.files.add(http.MultipartFile('image',
        File(file.path).readAsBytes().asStream(), File(file.path).lengthSync(),
        filename: fileName));
  }
  var res = await request.send();
  var respone = await res.stream.bytesToString();
  var jsonRes;
  final JsonDecoder _decoder = new JsonDecoder();
  jsonRes = _decoder.convert(respone.toString());
  print("Response: " + res.toString() + "_");
  print("ResponseJSON: " + respone.toString() + "_");
  print("status: " + jsonRes["success"].toString() + "_");
  print("message: " + jsonRes["message"].toString() + "_");

  if (res.statusCode == 200) {
    if (jsonRes["success"].toString() == "true") {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
          msg: jsonRes["message"].toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      print("Data " + jsonRes['data']['token'] + "*");
      LoginData data = new LoginData();
      data.token =
          jsonRes['data']["token"] == null ? "" : jsonRes['data']["token"];
      data.email =
          jsonRes['data']["email"] == null ? "" : jsonRes['data']["email"];
      data.f_name =
          jsonRes['data']["f_name"] == null ? "" : jsonRes['data']["f_name"];
      data.l_name =
          jsonRes['data']["l_name"] == null ? "" : jsonRes['data']["l_name"];
      data.image =
          jsonRes['data']["image"] == null ? "" : jsonRes['data']["image"];
      data.mobile =
          jsonRes['data']["mobile"] == null ? "" : jsonRes['data']["mobile"];
      data.restro_name = jsonRes['data']["restro_name"] == null
          ? ""
          : jsonRes['data']["restro_name"];
      data.restro_address = jsonRes['data']["restro_address"] == null
          ? ""
          : jsonRes['data']["restro_address"];
      saveUserLogin(data).then((bool committed) {
        Navigator.of(context).pop();
      });
    } else {
      setState(() {
        isLoading = false;
        Fluttertoast.showToast(
            msg: "Exception: " + jsonRes["message"].toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      });
    }
  } else {
    setState(() {
      isLoading = false;
      Fluttertoast.showToast(
          msg: "Exception: " + jsonRes["message"].toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }
}*/

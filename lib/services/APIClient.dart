import 'dart:async';
import 'dart:io';

import 'network_utils.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "https://facebook.roccabox.com/blog/api/";
  static final SIGNUP_URL = BASE_URL + "signUp";
  static final LOGIN_URL = BASE_URL + "Login";
}

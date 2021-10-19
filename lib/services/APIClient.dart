import 'dart:async';
import 'dart:io';

import 'network_utils.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "https://facebook.roccabox.com/blog/api/";
  static final SIGNUP_URL = BASE_URL + "signUp";
  static final NEWURL1 = BASE_URL + "newsearch1";
  static final LOGIN_URL = BASE_URL + "Login";
  static final GETASSIGNEDUSER_URL = BASE_URL + "getAssignedUser?user_id=";
  static final CHANGEPASSWORD_URL = BASE_URL + "changePassword";
  static final FORGOTPASSWORD_URL = BASE_URL + "forget-password";
  static final SENDTOKEN_URL = BASE_URL + "updateToken";
  static final TWILIOTOKEN = BASE_URL + "twilioToken";
  static final AGORATOKEN = BASE_URL + "agora-token";
}

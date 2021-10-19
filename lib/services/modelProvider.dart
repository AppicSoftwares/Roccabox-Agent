import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class Counter with ChangeNotifier {
  int countt = 0;
  int get count => countt;

  void getNotify() async{
    countt = notificationCount;

    notifyListeners();
  }

}

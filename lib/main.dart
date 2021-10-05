import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:roccabox_agent/screens/homenav.dart';
import 'package:roccabox_agent/screens/notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/splash.dart';


int langCount = 0;
int notificationCount = 0;
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    "001",
    "Roccabox",
    "This is description ",
    importance: Importance.high,
    playSound: true,
    enableLights: true,
    showBadge: true

);


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin
= FlutterLocalNotificationsPlugin();


Future<void> backgroundMessagehandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  FirebaseMessaging.onBackgroundMessage(backgroundMessagehandler);

  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true
  );
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Roccabox',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: Splash(),

      routes: {
    '/notification': (context)=> Notifications(),
    '/home': (context)=> HomeNav()
    },
      navigatorKey: navigatorKey,

    );
  }


}
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
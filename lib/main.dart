import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:roccabox_agent/agora/audioCall/audioCallMain.dart';
import 'package:roccabox_agent/agora/callModel.dart';
import 'package:roccabox_agent/screens/chatscreen.dart';
import 'package:roccabox_agent/screens/homenav.dart';
import 'package:roccabox_agent/screens/notifications.dart';
import 'package:roccabox_agent/services/modelProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

import 'screens/splash.dart';



var currentInstance = "";
var chatUser = "";
int langCount = 0;
int notificationCount = 0;
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    "001",
    "Roccabox",
    "This is description ",
    importance: Importance.high,
    playSound: true,
    enableLights: true,
    showBadge: true,



);


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin
= FlutterLocalNotificationsPlugin();


Future<void> backgroundMessagehandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  Map<String, dynamic>map = message.data;
  print("Map "+map.toString());
  var screeen = map["screen"];
  if(screeen=="VIDEO_SCREEN"|| screeen == "VOICE_SCREEN"){
    Future.delayed(Duration(seconds: 15), () async{
      await flutterLocalNotificationsPlugin.cancelAll();
    });
  }
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);


  FirebaseMessaging.onBackgroundMessage(backgroundMessagehandler);

  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true
  );
  HttpOverrides.global = MyHttpOverrides();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Counter()),
    ],
    child: MyApp(),
  ),);
}
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {

  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {




  @override
  void initState() {
    super.initState();

    getNotify();


    var initializationSettingsAndroid =
    new AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final InitializationSettings initializationSettings = InitializationSettings(
        iOS: initializationSettingsIOS, android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);

    //fetchLocation();
    FirebaseMessaging.onMessage.listen((RemoteMessage message){
      print('Running On Message'+message.data.toString()+"");
      print('Running On notification'+message.notification.toString()+"");
      print('CurrentInstance '+currentInstance.toString()+"");

      Map<String, dynamic>map;
      if(message.notification==null){
        if(message.data!=null) {
          map = message.data;

       /*   print("map " + map.toString());
          print("id " + map["sender_id"]);
        */

          if (map["screen"] == "VIDEO_SCREEN" || map['screen']=="VOICE_SCREEN") {
            Future.delayed(Duration(seconds: 15), () async{
              await flutterLocalNotificationsPlugin.cancelAll();
            });
            navigatorKey.currentState!.pushReplacementNamed('/call_received',
                arguments: CallModel(
                    map["sender_image"],
                    map["channelName"],
                    map["time"],
                    map["type"],
                    map["sender_fcm"],
                    map["sender_id"],
                    map["sender_name"],
                    map["token"]));
          } else {
            if (chatUser == null) {
              createListMap(map);
              flutterLocalNotificationsPlugin.show(
                  message.hashCode,
                  map["title"].toString(),
                  map["body"].toString(),
                  NotificationDetails(
                      android: AndroidNotificationDetails(
                        channel.id,
                        channel.name,
                        channel.description,
                        color: Colors.blue,
                        playSound: true,
                        additionalFlags: Int32List.fromList(<int>[4]),
                        icon: '@mipmap/ic_launcher',
                        largeIcon: DrawableResourceAndroidBitmap(
                            '@mipmap/ic_launcher'),
                      )
                  ));
            } else if (chatUser != map["id"]) {
              flutterLocalNotificationsPlugin.show(
                  message.hashCode,
                  map["title"].toString(),
                  map["body"].toString(),
                  NotificationDetails(
                      android: AndroidNotificationDetails(
                        channel.id,
                        channel.name,
                        channel.description,
                        color: Colors.blue,
                        playSound: true,
                        icon: '@mipmap/ic_launcher',
                        largeIcon: DrawableResourceAndroidBitmap(
                            '@mipmap/ic_launcher'),
                      )
                  ));
            }
          }
        }


      }else {
        RemoteNotification? notification  = message.notification;

        AndroidNotification? android = message.notification?.android;

        if (notification != null && android != null) {
          Map<String, dynamic>map = new Map();
          var screen = "";

          if(message.data!=null){

            map = message.data;
            screen = map["screen"];
            print("Screennnnn "+map.toString());
          }

          if(map["screen"]=="VIDEO_SCREEN" || map['screen']=="VOICE_SCREEN"){
            Future.delayed(Duration(seconds: 15), () async{
              await flutterLocalNotificationsPlugin.cancelAll();
            });
            navigatorKey.currentState!.pushReplacementNamed('/call_received', arguments: CallModel(  map["sender_image"],
                map["channelName"],
                map["time"],
                map["type"],
                map["sender_fcm"],
                map["sender_id"],
                map["sender_name"],
                map["token"]));

          }else{
          if(chatUser==null) {
            createList(notification);
            flutterLocalNotificationsPlugin.show(
                notification.hashCode,
                notification.title,
                notification.body,
                NotificationDetails(
                    android: AndroidNotificationDetails(
                      channel.id,
                      channel.name,
                      channel.description,
                      color: Colors.blue,
                      playSound: true,
                      icon: '@mipmap/ic_launcher',
                      largeIcon: DrawableResourceAndroidBitmap(
                          '@mipmap/ic_launcher'),
                    )
                ));
          }else if(chatUser!=map["id"]) {
            createList(notification);
            flutterLocalNotificationsPlugin.show(
                notification.hashCode,
                notification.title,
                notification.body,
                NotificationDetails(
                    android: AndroidNotificationDetails(
                      channel.id,
                      channel.name,
                      channel.description,
                      color: Colors.blue,
                      playSound: true,
                      icon: '@mipmap/ic_launcher',
                      largeIcon: DrawableResourceAndroidBitmap(
                          '@mipmap/ic_launcher'),
                    )
                ));
          }
          }
        }
      }
    });


    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new on message openedApp event was published');
      RemoteNotification? notification = message.notification;
      AndroidNotification? androidNotification = message.notification!.android;

      if(notification!=null){
        Map<String, dynamic> map = message.data;
        if(message.data!=null){
          map = message.data;
          print("Mappp "+map.toString());
          if(map['screen']=="VIDEO_SCREEN" || map['screen']=="VOICE_SCREEN"){
            Future.delayed(Duration(seconds: 15), () async{
              await flutterLocalNotificationsPlugin.cancelAll();
            });
            navigatorKey.currentState!.pushReplacementNamed('/call_received', arguments: CallModel(
                map["sender_image"],
                map["channelName"],
                map["time"],
                map["type"],
                map["sender_fcm"],
                map["sender_id"],
                map["sender_name"],
                map["token"]
            ));

          }else {
            createList(notification);
          }
        }
        //    showAlertDialog(context);
        /*       showDialog(context: context, builder:(_) {

          return AlertDialog(
            title: Text(notification.title.toString()),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification.body.toString())
                ],
              ),
            ),
          );

        });*/
      }else if(message.data!=null){
        Map<String, dynamic> map = message.data;
        if(map['screen']=="VIDEO_SCREEN" || map['screen']=="VOICE_SCREEN"){
          navigatorKey.currentState!.pushReplacementNamed('/call_received', arguments: CallModel(map["sender_image"], map["channelName"], map["time"],  map["type"], map["sender_fcm"], map["sender_id"], map["sender_name"], map["agoraToken"]));

        }else{
          createListMap(map);
        }
      }

    });


  }
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
    '/home': (context)=> HomeNav(),
    '/chatscreen': (context)=> ChatScreen(),
    '/call_received':(context)=> AudioCallWithImage()
    },
      navigatorKey: navigatorKey,

    );
  }





  Future<void> createList(RemoteNotification notification) async {
    print("ListSave");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String>? titleList = preferences.getStringList('titleList');
    List<String>? bodyList = preferences.getStringList('bodyList');
    List<String>? isReadList = preferences.getStringList('isRead');
    // List<String> timeList = preferences.getStringList('timeList');
    if(titleList!=null && bodyList!=null && isReadList!=null){
      titleList.add(notification.title.toString());
      bodyList.add(notification.body.toString());
      isReadList.add("false");
      preferences.setStringList("titleList", titleList);
      preferences.setStringList("bodyList", bodyList);
      preferences.setStringList("isRead", isReadList);
      //  preferences.setStringList("timeList", timeList);
      preferences.commit();
    }else{
      List<String> titleListNew = [];
      List<String> bodyListNew = [];
      List<String> isReadNew = [];

      titleListNew.add(notification.title.toString());
      bodyListNew.add(notification.body.toString());
      isReadNew.add("false");

      preferences.setStringList("titleList", titleListNew);
      preferences.setStringList("bodyList", bodyListNew);
      preferences.setStringList("isRead", isReadNew);
      preferences.commit();
    }

    getNotify();

  }
  void getNotify() async{
    notificationCount = 0;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var isRead = preferences.getStringList("isRead");
    print("IsRead " + isRead.toString());
    if (isRead != null) {
      if (isRead.isNotEmpty) {
        for (var k = 0; k < isRead.length; k++) {
          print("element " + isRead[k].toString());
          if (isRead[k] == "false") {
            notificationCount++;
          }
        }
      }
    }
    context.read<Counter>().getNotify();
    print("countsplash " + notificationCount.toString());
    preferences.setString("notify",notificationCount.toString());
    preferences.commit();

    //   navigatorKey.currentState!.pushReplacementNamed('/home');
  }


  Future<void> createListMap(Map<String, dynamic> map) async {
    print("ListSaveMap");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String>? titleList = preferences.getStringList('titleList');
    List<String>? bodyList = preferences.getStringList('bodyList');
    List<String>? isReadList = preferences.getStringList('isRead');
    // List<String> timeList = preferences.getStringList('timeList');
    if(titleList!=null && bodyList!=null && isReadList!=null){
      titleList.add(map["title"].toString());
      bodyList.add(map["body"].toString());
      isReadList.add("false");
      preferences.setStringList("titleList", titleList);
      preferences.setStringList("bodyList", bodyList);
      preferences.setStringList("isRead", isReadList);
      //  preferences.setStringList("timeList", timeList);
      preferences.commit();
    }else{
      List<String> titleListNew = [];
      List<String> bodyListNew = [];
      List<String> isReadListNew = [];

      titleListNew.add(map["title"].toString());
      bodyListNew.add(map["body"].toString());
      isReadListNew.add("false");

      preferences.setStringList("titleList", titleListNew);
      preferences.setStringList("bodyList", bodyListNew);
      preferences.setStringList("isRead", isReadListNew);
      preferences.commit();
    }


    getNotify();
  }

  Future selectNotification(String? payload) async {
/*    if (payload != null) {
      debugPrint('notification payload: $payload');
    }*/
    navigatorKey.currentState!.pushNamed('/notification');

  }
  Future onDidReceiveLocalNotification(
      int? id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          CupertinoAlertDialog(
            title: Text(title.toString()),
            content: Text(body.toString()),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Ok'),
                onPressed: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Notifications(),
                    ),
                  );
                },
              )
            ],
          ),
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
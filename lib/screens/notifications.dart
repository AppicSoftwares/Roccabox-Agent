import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/src/provider.dart';
import 'package:roccabox_agent/screens/assigned_users.dart';
import 'package:roccabox_agent/screens/documentScreen.dart';

import 'package:roccabox_agent/screens/homenav.dart';
import 'package:roccabox_agent/screens/imageScreen2.dart';
import 'package:roccabox_agent/services/APIClient.dart';
import 'package:roccabox_agent/services/modelProvider.dart';
import 'package:roccabox_agent/util/customDialoge.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'Setting.dart';
import 'chat.dart';

class Notifications extends StatefulWidget {
  String? payload = "";
  Notifications({Key? key, this.payload}):super(key: key);

  @override
 _NotificationsState createState() => _NotificationsState();

}

class _NotificationsState extends State<Notifications> {
  List names = [
    'Rajveer Place',
    'Taj Place',
    'Amar Place',
    'KLM Place',
    'Calibration Place',
    'Special Place',
    'Moti Place',
    'Rajvansh Place',
    'Taj Place',
    'Amar Place',
    'KLM Place',
    'Calibration Place',
    'Special Place',
  ];

  List<TotalUserList> totalUserList = [];

  List<String> titleList = [];
  List<String> bodyList = [];
  List<String> isread = [];
  List<String> imageList = [];
  List<String> screenList = [];
  List<String> idList = [];
  List<String> urlList = [];
  List<String> urlTypeList = [];
  var isdata = false;


  @override
  void initState() {
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Color(0xff000000),
          onPressed: (){
             Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (builder)=> HomeNav()), (route) => false);
          },
        ),
        backgroundColor: Color(0xffFFFFFF),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Notifications',
          style: TextStyle(
              fontSize: 16,
              color: Color(0xff000000),
              fontWeight: FontWeight.w600),
        ),

        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10, top: 5),
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () async {

                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.remove("titleList");
                pref.remove("bodyList");
                pref.remove("isRead");
                pref.remove("urlList");
                pref.remove("urlTypeList");
                pref.remove("idList");
                pref.remove("screenList");
                pref.remove("imageList");
                //pref.getStringList("timeList" ).clear();
                titleList.clear();
                bodyList.clear();
                urlList.clear();
                urlTypeList.clear();
                idList.clear();
                screenList.clear();
                imageList.clear();
                notificationCount = 0;
                context.read<Counter>().getNotify();
                isdata = false;
                setState(() {

                });

              },
              child: Container(
                padding: EdgeInsets.all(12),
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: Color(0xFF979797).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  "assets/delete.svg",
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: ()async{
          await Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (builder)=> HomeNav()), (route) => false);
          return true;
        },
        child: isdata?ListView.separated(
          itemCount: titleList.length,
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: Color(0xff707070),
            );
          },
          itemBuilder: (BuildContext context, int index) {

            print(screenList.length.toString()+"*");
            return isdata?ListTile(
              isThreeLine: true,
              onTap: (){
                if(screenList!=null && screenList.isNotEmpty){
                  if(screenList.elementAt(index)!=""){
                    if(screenList.elementAt(index)=="CHAT_SCREEN"){
                      Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (context)=> HomeNav()), (r)=> false);

                      /*   if(idList!=null) {
                        if (idList.elementAt(index) != "") {
                          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=> Chat()));
                        }
                      }*/
                    }else if(screenList.elementAt(index)=="NOTIFICATION_SCREEN"){
                      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=> HomeNav.one(index: 3)));

                    }else if(screenList.elementAt(index)=="notification"){
                      print("urlType "+urlTypeList.elementAt(index).toString()+"^^");
                      if(urlTypeList.elementAt(index)!="" && urlTypeList.elementAt(index)!=null){
                        if(urlTypeList.elementAt(index).toString().toLowerCase()=="jpg" || urlTypeList.elementAt(index).toString().toLowerCase()=="png"){
                          Navigator.push(context, new MaterialPageRoute(builder: (builder)=> ImageScreeen(image: urlList.elementAt(index).toString(),)));
                        }else if(urlTypeList.elementAt(index).toString().toLowerCase()=="pdf"){
                          Navigator.push(context, new MaterialPageRoute(builder: (builder)=> DocumentScreen(path: urlList.elementAt(index).toString(),)));

                        }else{

                        }
                      }
                    }
                  }
                }
              },
              leading: CircleAvatar(
                backgroundColor:
                Colors.primaries[Random().nextInt(Colors.primaries.length)],
                // backgroundImage: AssetImage('assets/img1.png'),
                child: Text(
                  titleList.elementAt(index).toString().substring(0, 1),
                  style: TextStyle(fontSize: 22, color: Colors.black),
                ),
              ),
              title: Text(
                titleList.elementAt(index),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff000000)),
              ),
              subtitle: Text(
                bodyList[index],
                style: TextStyle(fontSize: 12, color: Color(0xff818181)),
              ),
              trailing: urlList.elementAt(index).toString()!=""?urlList.elementAt(index).toString().toLowerCase().endsWith("jpg") || urlList.elementAt(index).toString().toLowerCase().endsWith("png") || urlList.elementAt(index).toString().toLowerCase().endsWith("jpeg")?
              CircleAvatar(backgroundImage: NetworkImage(
                  urlList.elementAt(index).toString()), radius: 30,):
              Image.asset("assets/doc_icon.png", width: 50, height: 50,):Text("")
              ,
            ): Center(child:Image.asset('assets/no_notification_yet.png'));
          },
        ): Center(child:Image.asset('assets/no_notification_yet.webp')),
      ),
    );
  }



  Future<void> getData() async {
    getUserList();
    List<String> isRead = [];
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.containsKey("titleList")) {
      isdata = true;
      titleList = preferences.getStringList("titleList")!;
    }else{
      isdata = false;
    }
    bodyList = preferences.getStringList("bodyList")!;
    isread = preferences.getStringList("isRead")!;
   // imageList = preferences.getStringList("imageList")!;
    screenList = preferences.getStringList("screenList")!;
   // idList = preferences.getStringList("idList")!;
    urlList = preferences.getStringList("urlList")!;
    urlTypeList = preferences.getStringList("urlTypeList")!;

    isread.forEach((element) {
      isRead.add("true");
    });

    preferences.setStringList("isRead", isRead);
    preferences.commit();
    notificationCount = 0;
    context.read<Counter>().notifyListeners();

    setState(() {
      titleList = titleList.reversed.toList();
      bodyList = bodyList.reversed.toList();
     // imageList = imageList.reversed.toList();
     // idList = idList.reversed.toList();
      screenList = screenList.reversed.toList();
      urlList = urlList.reversed.toList();
      urlTypeList = urlTypeList.reversed.toList();

    });
  }

  Future<dynamic> getUserList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var id = pref.getString("id").toString();
    var authToken = pref.getString("auth_token").toString();
    print("AUTH_TOKEN "+authToken.toString());
    Map<String, String> mapheaders = new HashMap();
    mapheaders["Authorization"] = authToken.toString();

    print("id "+id.toString()+"");
    var request = http.get(Uri.parse(
      RestDatasource.GETASSIGNEDUSER_URL + id,
    ), headers: mapheaders);

    var jsonRes;
    var jsonArray;
    var res;

    await request.then((http.Response response) {
      res = response;
      final JsonDecoder _decoder = new JsonDecoder();
      jsonRes = _decoder.convert(response.body.toString());
      print("Ress" + jsonRes.toString() + "");
    });

    if (res.statusCode == 200) {
      print("Response: " + jsonRes.toString() + "_");

      if (jsonRes["status"].toString() == "true") {
        totalUserList.clear();
        jsonArray = jsonRes["data"];

        if (jsonArray != null) {
          if (jsonArray.length > 0) {
            for (var i = 0; i < jsonArray.length; i++) {
              TotalUserList modelSearch = new TotalUserList();
              modelSearch.name = jsonArray[i]["name"];
              modelSearch.userId = jsonArray[i]["userId"].toString();
              modelSearch.email = jsonArray[i]["email"].toString();
              modelSearch.phone = jsonArray[i]["phone"].toString();
              modelSearch.enqID = jsonArray[i]["enqID"].toString();
              modelSearch.property_image = jsonArray[i]["property_image"].toString();
              modelSearch.image = jsonArray[i]["image"].toString();
              modelSearch.filter_id = jsonArray[i]["filter_id"].toString();
              modelSearch.firebase_token = jsonArray[i]["firebase_token"].toString();
              modelSearch.property_Rid =
                  jsonArray[i]["property_Rid"].toString();
              modelSearch.message = jsonArray[i]["message"].toString();

              totalUserList.add(modelSearch);
            }
          }
        }

        setState(() {
        });
      } else {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(jsonRes["message"].toString())));
          if(jsonRes["code"]!=null){
            if(jsonRes["code"]==403){
              showLogoutDialog(context);
            }
          }
        });
      }
    } else {
      setState(() {


      });
    }}

}
/*
ListView.separated(
        itemCount: names.length,
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: Color(0xff707070),
          );
        },
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            isThreeLine: true,
            leading: CircleAvatar(
              backgroundColor:
                  Colors.primaries[Random().nextInt(Colors.primaries.length)],
              // backgroundImage: AssetImage('assets/img1.png'),
              child: Text(
                names.elementAt(index).toString().substring(0, 1),
                style: TextStyle(fontSize: 22, color: Colors.black),
              ),
            ),
            title: Text(
              names.elementAt(index),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff000000)),
            ),
            subtitle: Text(
              'Hi! We have assigned you  a new agent for your previous enquiry. They will message you shortly',
              style: TextStyle(fontSize: 12, color: Color(0xff818181)),
            ),
          );
        },
      ),*/
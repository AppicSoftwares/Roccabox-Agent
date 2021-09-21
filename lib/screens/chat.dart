import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:roccabox_agent/screens/chatscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chat extends StatefulWidget {
  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  AsyncSnapshot<QuerySnapshot>? snapshot;
  List<QueryDocumentSnapshot> listUsers = new List.from([]);
  final firestoreInstance = FirebaseFirestore.instance;
  List<UserList> listUser = [];
  var id;
  @override
  void initState() {
    getData();
    WidgetsBinding.instance!.addObserver(
        LifecycleEventHandler(resumeCallBack: () async {
          print("Invoke");
        }
    ));

    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFFFFFF),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Chat',
          style: TextStyle(
              fontSize: 16,
              color: Color(0xff000000),
              fontWeight: FontWeight.w600),
        ),
      ),
      body: id!=null?StreamBuilder<QuerySnapshot>(
        stream: firestoreInstance
            .collection("chat_master")
            .doc("chat_head")
            .collection(id)
            .snapshots(),
        builder:(BuildContext context,
    AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.hasData){
            listUser.clear();
            snapshot.data?.docs.forEach((element) {
              var json;
              UserList model = new UserList();
              model.id = element.id.toString();

              print("StreamId "+element.id);
              json = element.data();
                print("StreamName " + json["user"].toString());
                print("StreamImage " + element.get("image").toString());
                model.name = json["user"].toString();
                model.image = json["image"].toString();
                model.message = json["msg"].toString();
                model.clicked = json["clicked"].toString();

              listUser.add(model);
            });
          }
          return ListView.separated(
            itemCount: listUser.length,
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                color: Color(0xff707070),
              );
            },

            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                onTap: () =>
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) =>
                        ChatScreen(name: listUser[index].name,
                          image: listUser[index].image,
                          receiverId: listUser[index].id,
                          senderId: id,))),
                leading:listUser[index].image==null? CircleAvatar(
                  backgroundImage: AssetImage('assets/img1.png'),
                ):CircleAvatar(backgroundImage: NetworkImage(listUser[index].image.toString() )),
                title: Text(
                  listUser == null ? "" : listUser[index].name.toString(),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff000000)),
                ),
                subtitle: Text(
                  listUser == null ? "" : listUser[index].message == null
                      ? ""
                      : listUser[index].message.toString(),
                  style: TextStyle(fontSize: listUser[index].clicked != null &&  listUser[index].clicked == "true"?12:16, color:  listUser[index].clicked != null &&  listUser[index].clicked == "true"?Color(0xff818181):Colors.black,
                      fontWeight:listUser[index].clicked != null &&  listUser[index].clicked == "true"?FontWeight.normal:FontWeight.bold ),
                ),
              );
            },
          );

        }
      ):Text("No Data Found"),
    );
  }

  void getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    id = pref.getString("id");
    setState(() {

    });
   /* firestoreInstance.collection("chat_master").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        firestoreInstance
            .collection("chat_master")
            .doc(result.id)
            .collection(id.toString())
            .get()
            .then((querySnapshot) {
              querySnapshot.docs.forEach((element) {
                UserList model = new UserList();
                model.id = element.id.toString();
                model.name = element.data()["user"].toString();
                model.image = element.data()["image"].toString();
                model.message = element.data()["msg"].toString();
                print("Id "+element.id);
                print("DataName "+element.data()["user"].toString());
                print("DataImage "+element.data()["image"].toString());

                //print("Name "+element.id);
                listUser.add(model);
              });
              setState(() {

              });
          *//*  listUsers.clear();
            listUsers.addAll(snapshot!.data!.docs);
            print("LengthofList "+listUsers.length.toString()+"");
           *//*   *//*querySnapshot.docs.forEach((result) {
            print(result.data());
          });*//*
        });
      });
    });*/
    
  }
}


class UserList{
  String? name;
  String? id;
  String? image;
  String? message;
  String? clicked;
}


class LifecycleEventHandler extends WidgetsBindingObserver {
  final AsyncCallback resumeCallBack;


  LifecycleEventHandler({
    required this.resumeCallBack,

  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        if (resumeCallBack != null) {
          await resumeCallBack();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        break;
    }
  }
}

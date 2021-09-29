import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:roccabox_agent/services/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  var senderId, receiverId, name, fcmToken, image;
  ChatScreen({Key? key, this.image, this.name, this.receiverId, this.senderId, this.fcmToken})
      : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final firestoreInstance = FirebaseFirestore.instance;
  List<QueryDocumentSnapshot> listMessage = new List.from([]);
  final ScrollController listScrollController = ScrollController();
  TextEditingController _textEditingController = new TextEditingController();
  final FocusNode focusNode = FocusNode();
  var message = "";
  var msg = "";
  int _limit = 20;
  int _limitIncrement = 20;
  
  var name;
  var image;
  File? imageFile;
  String imageUrl = "";
  bool isLoading = false;
  FirebaseMessaging? auth;
  var token;
  @override
  void initState() {
    focusNode.addListener(onFocusChange);
    listScrollController.addListener(_scrollListener);
    auth = FirebaseMessaging.instance;
    auth?.getToken().then((value){
      print("FirebaseTokenHome "+value.toString());
      token = value.toString();

      

    }
    );
    getData();
    super.initState();
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {});
    }
  }

  _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xffFFFFFF),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Container(
            width: double.infinity,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  widget.image == null
                      ? CircleAvatar(
                          backgroundImage: AssetImage('assets/img1.png'),
                        )
                      : CircleAvatar(
                          backgroundImage:
                              NetworkImage(widget.image.toString())),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.phone,
                        color: Colors.black,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.videocam_rounded,
                        color: Colors.black,
                      ))
                ],
              ),
              title: Text(
                widget.name == null ? "" : widget.name,
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff000000),
                    fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                'Rajveer Place',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xff818181),
                ),
              ),
            ),
          )),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              // List of messages
              buildListMessage(),

              // Sticker
              // isShowSticker ? buildSticker() : Container(),

              // Input content
              buildInput(),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: widget.senderId != null && widget.receiverId != null
          ? StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chat_master')
                  .doc("message_list")
                  .collection(widget.senderId + "-" + widget.receiverId)
                  .orderBy('timestamp', descending: true)
                  //.limit(_limit)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  listMessage.clear();
                  listMessage.addAll(snapshot.data!.docs);
                  return chatMessage(listMessage, snapshot.data!.docs);
                  //  return ListView.builder(
                  //    padding: EdgeInsets.all(10.0),
                  //    itemBuilder: (context, index) => buildItem(index, snapshot.data?.docs[index]),
                  //    itemCount: snapshot.data?.docs.length,
                  //    reverse: true,
                  //    controller: listScrollController,
                  //  );
                } else {
                  return Center(
                      child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                  ));
                }
              },
            )
          : Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
              ),
            ),
    );
  }

  Widget chatMessage(List<QueryDocumentSnapshot<Object?>> listMessage,
      List<QueryDocumentSnapshot<Object?>> docs) {
    print("SizeofList " + listMessage.length.toString() + "");
    return ListView.builder(
      itemCount: listMessage.length,
      reverse: true,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment:
                docs[index].get("idFrom").toString() == widget.senderId
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
            children: [
              Material(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                      topLeft: docs[index].get("idFrom").toString() ==
                              widget.senderId
                          ? Radius.circular(30.0)
                          : Radius.circular(0.0),
                      topRight: docs[index].get("idFrom").toString() ==
                              widget.senderId
                          ? Radius.circular(0)
                          : Radius.circular(30.0)),
                  elevation: 5.0,
                  color: docs[index].get("idFrom").toString() != widget.senderId
                      ? Colors.blueAccent
                      : Color(0xffFFBA00),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Text(
                      docs[index].get("content"),
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  )),
            ],
          ),
        );
        // return Container(
        //   padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
        //   width: 200.0,
        //   margin: EdgeInsets.only(
        //       bottom:  10.0, right: 10.0),
        //   decoration: BoxDecoration(
        //     color: Colors.grey[100],
        //     borderRadius: BorderRadius.circular(5),
        //     boxShadow: [
        //       BoxShadow(
        //           color: Colors.black54,
        //           offset: Offset(2, 3),
        //           blurRadius: 10,
        //           spreadRadius: 1)
        //     ],
        //   ),
        //   child: Text("Hello World"),
        // );
      },
    );
  }

  Widget buildInput() {
    return Container(
      margin: EdgeInsets.only(right: 15),
      child: Column(
        children: [
          Container(
            height: 1,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Row(
            children: <Widget>[
              // Button send image
              // Material(
              //   child: Container(
              //     margin: EdgeInsets.symmetric(horizontal: 1.0),
              //     child: IconButton(
              //       icon: Icon(Icons.image),
              //       onPressed: (){},
              //       color: kPrimaryColor,
              //     ),
              //   ),
              //   color: Colors.white,
              // ),
              // Material(
              //   child: Container(
              //     margin: EdgeInsets.symmetric(horizontal: 1.0),
              //     child: IconButton(
              //       icon: Icon(Icons.face),
              //       onPressed: (){},
              //       color: kPrimaryColor,
              //     ),
              //   ),
              //   color: Colors.white,
              // ),

              // Edit text
              Flexible(
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: TextField(
                    onSubmitted: (value) {},
                    style: TextStyle(color: Colors.black, fontSize: 15.0),
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Type your message...',
                      hintStyle: TextStyle(color: Colors.grey),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: InkWell(
                          onTap: getImage,
                          child: SvgPicture.asset(
                            "assets/attachment.svg",
                            width: 5,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    focusNode: focusNode,
                  ),
                ),
              ),

              InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () {},
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 46,
                      width: 46,
                      decoration: BoxDecoration(
                        color: kSecondaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          if (_textEditingController.text
                              .toString()
                              .trim()
                              .isNotEmpty) {
                            message = _textEditingController.text.toString().trim();
                            msg = _textEditingController.text.toString().trim();
                            print("SenderId " + widget.senderId + "");
                            print("Id " + widget.receiverId + "");
                            var documentReference = FirebaseFirestore.instance
                                .collection('chat_master')
                                .doc("message_list")
                                .collection(
                                    widget.senderId + "-" + widget.receiverId)
                                .doc(DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString());

                            firestoreInstance
                                .runTransaction((transaction) async {
                              transaction.set(
                                documentReference,
                                {
                                  'idFrom': widget.senderId,
                                  'idTo': widget.receiverId,
                                  'timestamp': DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString(),
                                  'content': _textEditingController.text
                                      .toString()
                                      .trim(),
                                  'type': "text"
                                },
                              );
                            }).then((value) {
                              var s = _textEditingController.text.toString();
                              print("TextEdit " +
                                  _textEditingController.text.toString());
                              var documentReference = FirebaseFirestore.instance
                                  .collection('chat_master')
                                  .doc("message_list")
                                  .collection(
                                      widget.receiverId + "-" + widget.senderId)
                                  .doc(DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString());

                              firestoreInstance
                                  .runTransaction((transaction) async {
                                transaction.set(
                                  documentReference,
                                  {
                                    'idFrom': widget.senderId,
                                    'idTo': widget.receiverId,
                                    'timestamp': DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString(),
                                    'content': s.toString(),
                                    'type': "text"
                                  },
                                );
                              });

                              updateChatHead(s.toString());

                              _textEditingController.clear();
                              focusNode.unfocus();
                            });
                            // listScrollController.animateTo(0.0,
                            //     duration: Duration(milliseconds: 300),
                            //     curve: Curves.easeOut);
                          }

                          sendNotification();
                        },
                        color: Color(0xffFFBA00),
                      ),
                    ),
                  ],
                ),
              ),

              //  Material(
              //     child: IconButton(

              //       icon: Icon(Icons.send),
              //       onPressed: (){},
              //       color: Colors.yellow[600],
              //     ),
              //     color: Colors.white,
              // ),

              // Button send message
            ],
          ),
        ],
      ),
      width: double.infinity,
      height: 70.0,
      //  decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey, width: 0.5)), color: Colors.white),
    );
  }

  void updateChatHead(String s) async {
    print("messageeee " + message + "");
 print("mytoken " + token + "");
    var documentReference = FirebaseFirestore.instance
        .collection('chat_master')
        .doc("chat_head")
        .collection(widget.senderId)
        .doc(widget.receiverId);
    print("s " + s + "");

    firestoreInstance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        {
          'idFrom': widget.senderId,
          'idTo': widget.receiverId,
          'msg': s.toString(),
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          'type': "text",
          'image': widget.image,
          'agent': name,
          'user': widget.name,
          'clicked': "true",
          'fcmToken': widget.fcmToken

        },
      );
    }).then((value) {
      var documentReference = FirebaseFirestore.instance
          .collection('chat_master')
          .doc("chat_head")
          .collection(widget.receiverId)
          .doc(widget.senderId);

      firestoreInstance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'idFrom': widget.senderId,
            'idTo': widget.receiverId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'msg': s.toString(),
            'type': "text",
            'image': image,
            'agent': name,
            'user': widget.name,
            'clicked': "false",
            'fcmToken': token
          },
        );
      });
    });
    message = "";
  }

  void getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    name = pref.getString("name");
    image = pref.getString("image");

    var documentReference = FirebaseFirestore.instance
        .collection('chat_master')
        .doc("chat_head")
        .collection(widget.senderId)
        .doc(widget.receiverId);

    firestoreInstance.runTransaction((transaction) async {
      transaction.update(
        documentReference,
        {'clicked': "true"},
      );
    });
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile? pickedFile;

    pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path.toString());
      if (imageFile != null) {
        setState(() {
          isLoading = true;
        });
        uploadFile();
      }
    }
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    //  Reference reference = FirebaseStorage.instance.ref().child("images/");
    //  UploadTask uploadTask = reference.putFile(imageFile!);

    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    UploadTask uploadTaskk = firebaseStorageRef.putFile(imageFile!);
    try {
      TaskSnapshot snapshot = await uploadTaskk;
      imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    } on FirebaseException catch (e) {
      print(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  onSendMessage(String content, int type) {
    var documentReference = FirebaseFirestore.instance
        .collection('chat_master')
        .doc("message_list")
        .collection(widget.senderId + "-" + widget.receiverId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    firestoreInstance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        {
          'idFrom': widget.senderId,
          'idTo': widget.receiverId,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          'content': content,
          'type': "image"
        },
      );
    }).then((value) {
      var documentReference = FirebaseFirestore.instance
          .collection('chat_master')
          .doc("message_list")
          .collection(widget.receiverId + "-" + widget.senderId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      firestoreInstance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'idFrom': widget.senderId,
            'idTo': widget.receiverId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': "image"
          },
        );
      });

      updateChatHead2(content);

      _textEditingController.clear();
      focusNode.unfocus();
    });
    listScrollController.animateTo(0.0,
        duration: Duration(milliseconds: 300), curve: Curves.easeOut);
  }
  void updateChatHead2(String s) async {

    var documentReference = FirebaseFirestore.instance
        .collection('chat_master')
        .doc("chat_head")
        .collection(widget.senderId)
        .doc(widget.receiverId);
    print("s "+s+"");

    firestoreInstance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        {
          'idFrom': widget.senderId,
          'idTo': widget.receiverId,
          'msg': s.toString(),
          'timestamp': DateTime.now()
              .millisecondsSinceEpoch
              .toString(),
          'type': "image",
          'image':widget.image,
          'agent': name,
          'user':widget.name,
          'clicked': "true",
           'fcmToken': widget.fcmToken
        },
      );
  }).then((value) {
      var documentReference = FirebaseFirestore.instance
          .collection('chat_master')
          .doc("chat_head")
          .collection(widget.receiverId)
          .doc(widget.senderId);

      firestoreInstance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'idFrom': widget.senderId,
            'idTo': widget.receiverId,
            'timestamp': DateTime
                .now()
                .millisecondsSinceEpoch
                .toString(),
            'msg': s.toString(),
            'type': "image",
            'image': image,
            'agent': name,
            'user': widget.name,
            'clicked': "false",
             'fcmToken': token
          },
        );
      });
    });
    message = "";
  }




  Future sendNotification() async {
    Map<String, String> map  = new HashMap();
    map["Authorization"] = "key=AAAAtgmz2LM:APA91bHyV1VbnfG-dRXDo1cgzQDkYll-0ZRdKbeTL4Hv0hbFilEiTPLHHXkA_teNx-z9xNBqkM2a54TwJ75-mPQjCsBVlzKyuSYPc3oJHMCpFBqlSPWrClV96h5xuVQsGBEu8yVzlZdn";
    map["content-type"] = "application/json";
    var jsonRes;
    var dataJson ;
/*    Obj obj = new Obj();
    obj.title = "Hello";
    obj.body = "This is body";
    obj.time = "11:58 PM";
    print("sdasda "+obj.toJson().toString());*/
    /* var response =
    await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),body: {
      "to":"c5uZ5jc0TBOp6CfaMfmjTq:APA91bElx-DFQyUiKMARntPEcx1eZ8vf1ZJrclkcijbDpzmy-DfAnYvK6N8zNU4sJ8qDCxIlmOMUtOO5gHnL8nbA1943aKCE5K2gno1ZhvldMaJpmXmWDkck5A9KzjwYqwJwcsZlvzB7",
      "priority":"",
      "data":obj.toJson(),
    },
    headers: map);*/


    final response = await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': msg.toString(),
              'title': name
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action':
              'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
              "screen": "OPEN_NOTIFICATION",
            },
            'to': widget.fcmToken
          },
        ),
        encoding: Encoding.getByName('utf-8'),
        headers: map);


    if (response.statusCode == 200) {

      var apiObj = JsonDecoder().convert(response.body.toString());
      print(apiObj.toString()+"^^");
    } else {
      throw Exception('Failed to load album');
    }

    msg= "";
  }



}


/*

Container(
margin: EdgeInsets.only(bottom: 60, top: 10),
child: ListView.builder(
itemCount: 5,
itemBuilder: (BuildContext context, int index) {
return SingleChildScrollView(
child: Column(
crossAxisAlignment: CrossAxisAlignment.end,
children: [
Align(
alignment: Alignment.topLeft,
child: Container(
margin: EdgeInsets.only(left: 10),
decoration: BoxDecoration(
color: Color(0xffF8F7F7),
borderRadius: BorderRadius.only(
topRight: Radius.circular(10),
bottomLeft: Radius.circular(10),
bottomRight: Radius.circular(10))),
padding: const EdgeInsets.all(10.0),
child: Text('Hi, how are you?'),
),
),
Container(
margin:
EdgeInsets.only(right: 10, top: 20, bottom: 20),
decoration: BoxDecoration(
color: Color(0xffF1F0EE),
borderRadius: BorderRadius.only(
topLeft: Radius.circular(10),
bottomLeft: Radius.circular(10),
bottomRight: Radius.circular(10))),
padding: const EdgeInsets.all(10.0),
child: Text('Good, how are you?'),
)
],
),
);
}),
),*/

/*

Positioned(
left: 0,
right: 0,
bottom: 0,
child: Container(
color: Colors.white,
child: Padding(
padding: const EdgeInsets.all(8.0),
child: Container(
width: double.infinity,
child: Row(
mainAxisSize: MainAxisSize.min,
mainAxisAlignment: MainAxisAlignment.center,
children: [
Container(
// height: 50,
width: MediaQuery.of(context).size.width * .70,
child: TextField(
cursorColor: Color(0xff818181),
decoration: InputDecoration(
isDense: true,
hintText: 'Type a message',
suffixIcon: Transform.rotate(
angle: 180,
child: Icon(
Icons.attachment,
size: 30,
color: Color(0xff818181),
)),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(50),
borderSide:
BorderSide(color: Color(0xffFFBA00))),
enabledBorder: OutlineInputBorder(
borderSide:
BorderSide(color: Color(0xffE5E5E5)),
borderRadius: BorderRadius.circular(50)),
border: OutlineInputBorder(
borderSide:
BorderSide(color: Color(0xffFFBA00)),
borderRadius: BorderRadius.circular(50))),
),
),
SizedBox(
width: 10,
),
Container(
height: 50,
width: 50,
decoration: BoxDecoration(
shape: BoxShape.circle, color: Color(0xffFFBA00)),
child: Padding(
padding: const EdgeInsets.only(left: 3.0),
child: Icon(
Icons.send,
color: Colors.white,
),
),
)
],
),
),
),
),
)
*/




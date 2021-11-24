import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:roccabox_agent/agora/dialscreen/dialScreen.dart';
import 'package:roccabox_agent/agora/videoCall/videoCall.dart';
import 'package:roccabox_agent/screens/imageScreen.dart';
import 'package:roccabox_agent/screens/videoScreen.dart';
import 'package:roccabox_agent/services/APIClient.dart';
import 'package:roccabox_agent/services/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

import '../main.dart';
import 'documentScreen.dart';

class ChatScreen extends StatefulWidget {
  var senderId, receiverId, name, fcmToken, image, userType;
  ChatScreen({Key? key, this.image, this.name, this.receiverId, this.senderId, this.fcmToken, this.userType})
      : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final firestoreInstance = FirebaseFirestore.instance;
  List<QueryDocumentSnapshot> listMessage = new List.from([]);
  List<MessageList> listMessage2 = new List.from([]);
  final ScrollController listScrollController = ScrollController();
  TextEditingController _textEditingController = new TextEditingController();
  final FocusNode focusNode = FocusNode();
  var message = "";
  int _limit = 20;
  int _limitIncrement = 20;
  
  var name;
  var image;
  File? imageFile;
  File? pdfFile;
  String imageUrl = "";
  bool isLoading = false;
  FirebaseMessaging? auth;
  late FirebaseAuth mAuth;
  var token;
  User? user;
  bool sendimage = false;
  late VideoPlayerController _controller;
//  final databaseRef = FirebaseDatabase.instance.reference(); //database reference object

  @override
  void initState() {
    currentInstance = "CHAT_SCREEN";
    chatUser = widget.receiverId;
    focusNode.addListener(onFocusChange);
    listScrollController.addListener(_scrollListener);
    auth = FirebaseMessaging.instance;
    auth?.getToken().then((value){
      print("FirebaseTokenHome "+value.toString());
      token = value.toString();
      mAuth = FirebaseAuth.instance;
      user = mAuth.currentUser;
      print("user "+user!.uid.toString()+"");

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
  @override
  void dispose() {
    currentInstance = "";
    chatUser = "";
    focusNode.unfocus();
    focusNode.dispose();
    super.dispose();
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
                      onPressed: () {
                        getAccessToken(widget.receiverId.toString(), "VOICE");

                      },
                      icon: Icon(
                        Icons.phone,
                        color: Colors.black,
                      )),
                  IconButton(
                      onPressed: () {
                        getAccessToken(widget.receiverId.toString(), "VIDEO");

                      },
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
                '',

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


              Visibility(
                  visible: sendimage,
                  child: Container(width:100,height:100,child: Align(alignment:Alignment.centerRight,child: CircularProgressIndicator( color: Color(0xffFFBA00),),),)),

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
/*
  Widget buildListMessage() {
    return Flexible(
      child: widget.senderId != null && widget.receiverId != null
          ? StreamBuilder(
        stream: databaseRef.child("chat_master")
        .child("message_list")
        .child(widget.senderId)
        .child(widget.receiverId)
        .onValue,
        builder: (BuildContext context,
            AsyncSnapshot<Event> snapshot) {
          if (snapshot.hasData) {
            listMessage2.clear();
            if(snapshot.data?.snapshot.value!=null){
              Map<Object?, Object?> map = snapshot.data?.snapshot.value;
              print("listMap"+map.toString());

              map.forEach((key, value) {
                MessageList list = MessageList();
                list.timeStamp = key.toString();
                Map<Object?, Object?> childMap = value as Map<Object?, Object?>;
                print("childMapp "+childMap.toString());


                childMap.forEach((key, value) {
                  print("valueee "+childMap["content"].toString());

                  Messages messages = Messages();
                  messages.content = childMap["content"].toString();
                  messages.idFrom = childMap["idFrom"].toString();
                  messages.idTo = childMap["idTo"].toString();
                  messages.timestamp = childMap["timestamp"].toString();
                  messages.type = childMap["type"].toString();
                  list.message = messages;
                });

                listMessage2.add(list);


                print("MessageLength "+listMessage2.length.toString());
                print("MessageContent "+listMessage2[0].message!.content);

              });

            }
            List<MessageList> listMessage3 = listMessage2.reversed.toList();

            // listMessage2.addAll(snapshot.data?.snapshot.value);
            return chatMessage(listMessage3);
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
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xffFFBA00)),
                ));
          }
        },
      )
          : Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xffFFBA00)),
        ),
      ),
    );
  }
*/
/*
  Widget chatMessage(List<MessageList> listMessage) {
    print("SizeofList " + listMessage.length.toString() + "");

    return ListView.builder(
      itemCount: listMessage.length,
      reverse: true,
      itemBuilder: (BuildContext context, int index) {

        return

        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment:
            listMessage2[index].message?.idFrom.toString() == widget.senderId
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
          listMessage2[index].message?.type=="document"?GestureDetector(
                onTap: (){
                  if(listMessage2[index].message?.content!=null){
                    if(listMessage2[index].message?.content!=""){
                      print("OnTap Document");
                      Navigator.push(context, new MaterialPageRoute(builder: (context) => DocumentScreen(path: listMessage2[index].message!.content,)));

                    }
                  }
                },
                child: Material(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                      topLeft: listMessage2[index].message?.idFrom.toString() ==
                          widget.senderId
                          ? Radius.circular(30.0)
                          : Radius.circular(0.0),
                      topRight: listMessage2[index].message?.idFrom.toString() ==
                          widget.senderId
                          ? Radius.circular(0)
                          : Radius.circular(30.0)),
                  elevation: 5.0,
                  color: listMessage2[index].message?.idFrom.toString() != widget.senderId
                      ? Colors.blueAccent
                      : kPrimaryColor,
                  child:Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            height: 50,
                            width: 50,
                            child:Image.asset("assets/doc_icon.png")

                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            child:Text("Document", style: TextStyle(color:Colors.white),)

                        ),
                      ),
                    ],
                  ),
                ),
              )


                  : listMessage2[index].message!.type=="video"?GestureDetector(
                  onTap: (){
                    if(listMessage2[index].message!.content!=null){
                      if(listMessage2[index].message!.content!=""){
                        Navigator.push(context, new MaterialPageRoute(builder: (context) => VideoScreen(video: listMessage2[index].message!.content,)));

                      }
                    }
                  },
                  child:Material(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0),
                        topLeft: listMessage2[index].message?.idFrom.toString() ==
                            widget.senderId
                            ? Radius.circular(30.0)
                            : Radius.circular(0.0),
                        topRight: listMessage2[index].message?.idFrom.toString() ==
                            widget.senderId
                            ? Radius.circular(0)
                            : Radius.circular(30.0)),
                    elevation: 5.0,
                    color: listMessage2[index].message?.idFrom.toString() != widget.senderId
                        ? Colors.blueAccent
                        : kPrimaryColor,
                    child:Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              height: 50,
                              width: 50,
                              child:Image.asset("assets/play.png")

                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              child:Text("Video", style: TextStyle(color:Colors.white),)

                          ),
                        ),
                      ],
                    ),
                  )): listMessage2[index].message!.type=="image"?GestureDetector(
                onTap: (){
                  if(listMessage2[index].message!.content!=null){
                    if(listMessage2[index].message!.content!=""){
                      Navigator.push(context, new MaterialPageRoute(builder: (context) => ImageScreen(image: listMessage2[index].message!.content,)));

                    }
                  }
                },
                child: Container(
                  child: Material(
                    child: CachedNetworkImage(
                      placeholder: (con, url ){
                        return Image.asset(
                          'assets/img_not_available.png',
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.fill,
                        );
                      },
                      errorWidget:(con,url,error){
                        return Material(
                          child: Image.asset(
                            'assets/img_not_available.png',
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        );
                      },
                      imageUrl: listMessage2[index].message!.content,
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  margin: EdgeInsets.only(bottom:listMessage2[index].message?.idFrom.toString() != widget.senderId ? 20.0 : 10.0, right: 10.0),
                ),
              ):Material(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                      topLeft: listMessage2[index].message?.idFrom.toString() ==
                          widget.senderId
                          ? Radius.circular(30.0)
                          : Radius.circular(0.0),
                      topRight: listMessage2[index].message?.idFrom.toString() ==
                          widget.senderId
                          ? Radius.circular(0)
                          : Radius.circular(30.0)),
                  elevation: 5.0,
                  color: listMessage2[index].message?.idFrom.toString() != widget.senderId
                      ? Colors.blueAccent
                      : Color(0xffFFBA00),
                  child: Padding(
                    padding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child:Text(
                      listMessage2[index].message!.content,
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
*/


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
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xffFFBA00)),
                  ));
                }
              },
            )
          : Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xffFFBA00)),
              ),
            ),
    );
  }

  Future getThumbnail(param0) async {
    _controller = VideoPlayerController.network(
        param0)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        return true;
      });

  }

  void bottomSheet(){
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: new Icon(Icons.photo),
                title: new Text('Photo'),
                onTap: () {
                  getImage();
                  Navigator.pop(context);
                },
              ),

              ListTile(
                leading: new Icon(Icons.videocam),
                title: new Text('Video'),
                onTap: () {
                  getVideo();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: new Icon(Icons.picture_as_pdf),
                title: new Text('Documents'),
                onTap: () {
                  getPdf();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
  Future getVideo() async {
    await [Permission.storage].request();

    final pickedFile;

    pickedFile =  await ImagePicker.platform.getVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      print("Running VideoPicking");

      imageFile = File(pickedFile.path.toString());
      if (imageFile != null) {
        setState(() {
          isLoading = true;
        });
        uploadVideo();
      }
    }
  }


  Future uploadVideo() async {
    print("Running");
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    //  Reference reference = FirebaseStorage.instance.ref().child("images/");
    //  UploadTask uploadTask = reference.putFile(imageFile!);

    Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('Videos/$fileName');
    UploadTask uploadTaskk = firebaseStorageRef.putFile(imageFile!);
    try {
      setState(() {
        sendimage = true;
      });
      TaskSnapshot snapshot = await uploadTaskk;
      imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        sendimage = false;
        onSendMessage(imageUrl, 2);
      });
    } on FirebaseException catch (e) {
      print(e.toString());
      setState(() {
        sendimage = false;
      });

    }
  }

  Widget chatMessage(List<QueryDocumentSnapshot<Object?>> listMessage,
      List<QueryDocumentSnapshot<Object?>> docs) {
    print("SizeofList " + listMessage.length.toString() + "");

    return ListView.builder(
      itemCount: listMessage.length,
      reverse: true,
      itemBuilder: (BuildContext context, int index) {

        return docs[index].get("content")!=""?Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment:
                docs[index].get("idFrom").toString() == widget.senderId
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
            children: [
              docs[index].get("type")=="document"?GestureDetector(
                onTap: (){
                    if(docs[index].get("content")!=null){
                      if(docs[index].get("content")!=""){
                        print("OnTap Document");
                        Navigator.push(context, new MaterialPageRoute(builder: (context) => DocumentScreen(path: docs[index].get("content"),)));

                      }
                    }
                  },
                child: Material(
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
                      : kPrimaryColor,
                  child:Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              height: 50,
                              width: 50,
                              child:Image.asset("assets/doc_icon.png")

                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              child:Text("Document", style: TextStyle(color:Colors.white),)

                          ),
                        ),
                      ],
                    ),
                ),
              )


                  : docs[index].get("type")=="video"?GestureDetector(
                  onTap: (){
                    if(docs[index].get("content")!=null){
                      if(docs[index].get("content")!=""){
                        Navigator.push(context, new MaterialPageRoute(builder: (context) => VideoScreen(video: docs[index].get("content"),)));

                      }
                    }
                  },
                  child:Material(
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
                        : kPrimaryColor,
                    child:Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              height: 50,
                              width: 50,
                              child:Image.asset("assets/play.png")

                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              child:Text("Video", style: TextStyle(color:Colors.white),)

                          ),
                        ),
                      ],
                    ),
                  )): docs[index].get("type")=="image"?GestureDetector(
                onTap: (){
                  if(docs[index].get("content")!=null){
                    if(docs[index].get("content")!=""){
                      Navigator.push(context, new MaterialPageRoute(builder: (context) => ImageScreen(image: docs[index].get("content"),)));

                    }
                  }
                },
                child: Container(
                  child: Material(
                    child: CachedNetworkImage(
                      placeholder: (con, url ){
                        return Image.asset(
                          'assets/img_not_available.png',
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.fill,
                        );
                      },
                      errorWidget:(con,url,error){
                        return Material(
                          child: Image.asset(
                            'assets/img_not_available.png',
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        );
                      },
                      imageUrl: docs[index].get("content"),
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  margin: EdgeInsets.only(bottom:docs[index].get("idFrom").toString() != widget.senderId ? 20.0 : 10.0, right: 10.0),
                ),
              ):Material(
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
                    child:Text(
                      docs[index].get("content"),
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  )),
            ],
          ),
        ):SizedBox(height: 0,);
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
                          onTap: bottomSheet,
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
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          //focusNode.unfocus();
                        var  ss = _textEditingController.text.toString().trim();
                         var aa = _textEditingController.text.toString().trim();
                          _textEditingController.clear();
                          if (ss.isNotEmpty && ss.toString()!="" && ss.toString()!="null") {
                            print("SenderId " + widget.senderId + "");
                            print("Id " + widget.receiverId + "");
                            print("TextEdit " +ss);

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
                                  'content':ss,
                                  'type': "text"
                                },
                              );
                            }).then((value) {

                              print("value " + aa.toString());
                              if (aa != null && aa != "") {
                                var documentReference = FirebaseFirestore
                                    .instance
                                    .collection('chat_master')
                                    .doc("message_list")
                                    .collection(
                                    widget.receiverId + "-" + widget.senderId)
                                    .doc(DateTime
                                    .now()
                                    .millisecondsSinceEpoch
                                    .toString());
                                print("MessageNow " + aa.toString());
                                firestoreInstance
                                    .runTransaction((transaction) async {
                                  transaction.set(
                                    documentReference,
                                    {
                                      'content': aa.toString(),
                                      'idFrom': widget.senderId,
                                      'idTo': widget.receiverId,
                                      'timestamp': DateTime
                                          .now()
                                          .millisecondsSinceEpoch
                                          .toString(),

                                      'type': "text"
                                    },
                                  );
                                });
                              }

                              //updateSeccond(aa);

                              updateChatHead(aa);

                            });


                           /*  listScrollController.animateTo(0.0,
                                 duration: Duration(milliseconds: 300),
                                 curve: Curves.easeOut);*/

                            sendNotification(ss.toString());
                          }



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
void updateSeccond(String msg) {
  print("value " + msg.toString());
  if (msg != null && msg != "") {
    var documentReference = FirebaseFirestore
        .instance
        .collection('chat_master')
        .doc("message_list")
        .collection(
        widget.receiverId + "-" + widget.senderId)
        .doc(DateTime
        .now()
        .millisecondsSinceEpoch
        .toString());
    print("MessageNow " + msg.toString());
    firestoreInstance
        .runTransaction((transaction) async {
      transaction.set(
        documentReference,
        {
          'content': msg.toString(),
          'idFrom': widget.senderId,
          'idTo': widget.receiverId,
          'timestamp': DateTime
              .now()
              .millisecondsSinceEpoch
              .toString(),

          'type': "text"
        },
      );
    });
  }
}
/*
  Widget _getMessageList() {
    return Expanded(
      child: FirebaseAnimatedList(
        controller: listScrollController,
        query: databaseRef.child("chat_master").child("chat_head").child(widget.senderId).child(widget.receiverId),
        itemBuilder: (context, snapshot, animation, index) {
          final json = snapshot.value as Map<dynamic, dynamic>;
          final message = Message.fromJson(json);
          return MessageWidget(message.text, message.date);
        },
      ),
    );
  }
*/

  void updateChatHead(String s) async {
    print("messageeee " + s + "");
 print("agentName " + name + "");
 print("username " + widget.name + "");
 print("type " + widget.userType + "");
 if(s!="" && s.toString() != "null") {
   if(widget.userType=="admin"){
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
           'timestamp': DateTime
               .now()
               .millisecondsSinceEpoch
               .toString(),
           'type': "text",
           'image': widget.image,
           'agent': name,
           'admin': widget.name,
           'clicked': "true",
           'fcmToken': widget.fcmToken,
           'chatType':"agent-admin"
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
             'type': "text",
             'image': image,
             'agent': name,
             'admin': widget.name,
             'clicked': "false",
             'fcmToken': token,
             'chatType':"agent-admin"
           },
         );
       });
     });
   }else{
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
           'timestamp': DateTime
               .now()
               .millisecondsSinceEpoch
               .toString(),
           'type': "text",
           'image': widget.image,
           'agent': name,
           'user': widget.name,
           'clicked': "true",
           'fcmToken': widget.fcmToken,
           'chatType':"agent-user"
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
             'type': "text",
             'image': image,
             'agent': name,
             'user': widget.name,
             'clicked': "false",
             'fcmToken': token,
             'chatType':"agent-user"
           },
         );
       });
     });
   }

 }
/*

    Map<String,String> inputMap = new HashMap();
    inputMap = {
      'idFrom': widget.senderId,
      'idTo': widget.receiverId,
      'msg': s.toString(),
      'timestamp': DateTime.now()
          .millisecondsSinceEpoch
          .toString(),
      'type': "text",
      'image':widget.image,
      'agent': widget.name,
      'user':name,
      'clicked': "true",
      'fcmToken':widget.fcmToken
    };
    Map<String,String> inputMap2 = new HashMap();
    inputMap2 = {
      'idFrom': widget.senderId,
      'idTo': widget.receiverId,
      'msg': s.toString(),
      'timestamp': DateTime.now()
          .millisecondsSinceEpoch
          .toString(),
      'type': "text",
      'image':image,
      'agent': widget.name,
      'user':name,
      'clicked': "true",
      'fcmToken':token
    };

    databaseRef.child("chat_master").child("chat_head").child(widget.senderId).child(widget.receiverId).update(inputMap).onError((error, stackTrace) {
      print(error.toString());
    }).then((value) {
      print("Update heads realtime successfully");
    });
    databaseRef.child("chat_master").child("chat_head").child(widget.receiverId).child(widget.senderId).update(inputMap2);
*/

  }

  void getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    name = pref.getString("name");
    image = pref.getString("image");
    print("Image "+image.toString());
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




  Future getPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ["pdf"]);

    if (result != null) {
      pdfFile = File(result.files.single.path.toString());
    } else {
      // User canceled the picke
    }

      if (pdfFile != null) {
        uploadpdf();
      }
  }



  Future uploadpdf() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    //  Reference reference = FirebaseStorage.instance.ref().child("images/");
    //  UploadTask uploadTask = reference.putFile(imageFile!);

    Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('Documents/$fileName');
    UploadTask uploadTaskk = firebaseStorageRef.putFile(pdfFile!);
    try {
      setState(() {
        sendimage = true;
      });
      TaskSnapshot snapshot = await uploadTaskk;
      imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        sendimage = false;
        onSendMessage(imageUrl, 3);
      });
    } on FirebaseException catch (e) {
      print(e.toString());
      setState(() {
        sendimage = false;
      });
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
      setState(() {
        sendimage = true;
      });
      TaskSnapshot snapshot = await uploadTaskk;
      imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        sendimage = false;
        onSendMessage(imageUrl, 1);
      });
    } on FirebaseException catch (e) {
      print(e.toString());
      setState(() {
        sendimage = false;
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
          'type': type==1?"image":type==2?"video":"document"
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
            'type':type==1?"image":type==2?"video":"document"
          },
        );
      });

      _textEditingController.clear();
      focusNode.unfocus();
      updateChatHead2(content, type);

    });
    listScrollController.animateTo(0.0,
        duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    message =  type==1?"image":type==2?"video":"document";

    sendNotification(message.toString());

  }


  void updateChatHead2(String s, int type) async {
    if(widget.userType=="admin") {
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
            'msg': type == 1 ? "image" : type == 2 ? "video" : "Document",
            'timestamp': DateTime
                .now()
                .millisecondsSinceEpoch
                .toString(),
            'type': type == 1 ? "image" : type == 2 ? "video" : "document",
            'image': widget.image,
            'agent': name,
            'admin': widget.name,
            'clicked': "true",
            'fcmToken': widget.fcmToken,
            'chatType':"agent-admin"
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
              'msg': type == 1 ? "image" : type == 2 ? "video" : "Document",
              'type': type == 1 ? "image" : type == 2 ? "video" : "document",
              'image': image,
              'agent': name,
              'admin': widget.name,
              'clicked': "false",
              'fcmToken': token,
              'chatType':"agent-admin"
            },
          );
        });
      });
    }else{
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
            'msg': type == 1 ? "image" : type == 2 ? "video" : "Document",
            'timestamp': DateTime
                .now()
                .millisecondsSinceEpoch
                .toString(),
            'type': type == 1 ? "image" : type == 2 ? "video" : "document",
            'image': widget.image,
            'agent': name,
            'user': widget.name,
            'clicked': "true",
            'fcmToken': widget.fcmToken,
            'chatType':"agent-user"
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
              'msg': type == 1 ? "image" : type == 2 ? "video" : "Document",
              'type': type == 1 ? "image" : type == 2 ? "video" : "document",
              'image': image,
              'agent': name,
              'user': widget.name,
              'clicked': "false",
              'fcmToken': token,
              'chatType':"agent-user"
            },
          );
        });
      });
    }
    message = "";
  }

  Future<dynamic> getAccessToken(String id, String type) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userid = pref.getString("id");

    print("user_id "+userid.toString());
    // print(email)
        ;
    var jsonRes;
    http.Response? res;
    var request = http.post(Uri.parse(RestDatasource.AGORATOKEN),
        body: {

          "type": type,
          "user_id": userid.toString(),
          "receiver_id": id,
          "channelKey": widget.userType=="user"?"key_user":"key_admin",
          "id": "10",
          "click_action": 'FLUTTER_NOTIFICATION_CLICK',
          "time": DateTime.now().millisecondsSinceEpoch.toString()


        });

    await request.then((http.Response response) {
      res = response;

      // msg = jsonRes["message"].toString();
      // getotp = jsonRes["otp"];
      // print(getotp.toString() + '123');t
    });
    if (res!.statusCode == 200) {
      final JsonDecoder _decoder = new JsonDecoder();
      jsonRes = _decoder.convert(res!.body.toString());
      print("Response: " + res!.body.toString() + "_");
      print("ResponseJSON: " + jsonRes.toString() + "_");


      if(jsonRes["status"]==true){
        var agoraToken = jsonRes["agora_token"].toString();
        var channel = jsonRes["channelName"].toString();
        var name = jsonRes["receiver"]["name"].toString();
        var image = jsonRes["receiver"]["image"].toString();
        var time = jsonRes["time"].toString();
        var fcm = jsonRes["receiver"]["firebase_token"].toString();
        registerCall(userid.toString(),name, image, type, fcm, id, "Calling", agoraToken, channel, time);

      }

    } else {

    }
  }



  void registerCall(String userid, String nm, String img, String type, String fcmToken,String idd, String status, String agoraToken, String channel, String time) async {

    var documentReference = FirebaseFirestore.instance
        .collection('call_master')
        .doc("call_head")
        .collection(userid)
        .doc(time);


    firestoreInstance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        {
          'fcmToken': fcmToken,
          'id': idd,
          'image': img,
          'name': nm,
          'timestamp': time,
          'type': type,
          'callType':"incoming",
          'status': status

        },
      );
    }).then((value) {
      var documentReference = FirebaseFirestore.instance
          .collection('call_master')
          .doc("call_head")
          .collection(idd)
          .doc(time);

      firestoreInstance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'fcmToken': token,
            'id': userid,
            'image': image,
            'name': name,
            'timestamp': time,
            'type': type,
            'callType':"outgoing",
            'status':status
          },
        );
      });
    });
    if(type=="VIDEO"){
      Navigator.push(context, new MaterialPageRoute(builder: (context)=> VideoCall(name:nm ,image:img, channel: channel, token: agoraToken, myId: userid.toString(),time: time, senderId: idd,)));

    }else{
      Navigator.push(context, new MaterialPageRoute(builder: (context)=> DialScreen(name:nm ,image:img, channel: channel, agoraToken: agoraToken,myId: userid.toString(),time: time,receiverId: idd, )));

    }
  }





  Future sendNotification(String type) async{
  print("SenderTokenn "+widget.fcmToken);

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
              'body': type.toString(),
              'title': name,
              "channelKey": widget.userType=="admin"?"key_admin":"key_agent",
              "id": "10",
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action':
              'FLUTTER_NOTIFICATION_CLICK',
              'id': widget.senderId,
              'status': 'done',
              "screen": "CHAT_SCREEN",
              "name":widget.name,
              "image":widget.image,
              "receiverId":widget.receiverId,
              "senderid":widget.senderId,
              "fcm":widget.fcmToken,
              'body': type.toString(),
              'title': name,
              "channelKey": widget.userType=="admin"?"key_admin":"key_agent",
              "id": "10",
              "chat_type":widget.userType=="admin"?"agent-admin":"agent-user"
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

    message= "";
  }
/*  Future<File> getFileFromUrl(String url, {name}) async {
    var fileName = 'testonline';
    if (name != null) {
      fileName = name;
    }
    try {
      var data = await http.get(Uri.parse(url));
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/" + fileName + ".pdf");
      print("pathh"+dir.path);
      imageFromPdfFile(dir.path);
      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    } catch (e) {
      throw Exception("Error opening url file");
    }
  }
  imageFromPdfFile(String pdfFile) async {
    final document = await PdfDocument.openFile(pdfFile);
    final page = await document.getPage(1);
    final pageImage = await page.render(width: page.width, height: page.height);
    await page.close();
    print("ImageBytes "+pageImage!.bytes.toString());

    //... now convert
    // .... pageImage.bytes to image
  }*/






}

class MessageList{
  var timeStamp = "";
  Messages? message;
}

class Messages{
  String content = "";
  var idFrom = "";
  var idTo = "";
  var timestamp = "";
  var type = "";
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




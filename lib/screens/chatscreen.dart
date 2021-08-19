import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/img1.png'),
                  ),
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
                'Client Name',
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
          ),
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
        ],
      ),
    );
  }
}

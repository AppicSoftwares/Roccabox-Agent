


import 'package:flutter/material.dart';

class CallScreen extends StatefulWidget {
  var name;
  CallScreen({Key? key, this.name}) : super(key: key);

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(widget.name==null?"Name":widget.name),
            FloatingActionButton(
                onPressed: (){

            })
          ],
        ),
      ),
    );
  }
}

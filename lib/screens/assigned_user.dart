import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:roccabox_agent/screens/chatscreen.dart';
import 'package:roccabox_agent/services/APIClient.dart';
import 'package:shared_preferences/shared_preferences.dart';




class AssignedUser extends StatefulWidget {
  const AssignedUser({ Key? key }) : super(key: key);

  @override
  _AssignedUserState createState() => _AssignedUserState();
}

class _AssignedUserState extends State<AssignedUser> {
  bool isloading = false;

  List<UserModel> userModelList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    featuredBusinessApi();
  }






  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          color: Colors.black,
        ),
        backgroundColor: Color(0xffFFFFFF),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Assigned User',
          style: TextStyle(
              fontSize: 16,
              color: Color(0xff000000),
              fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView.separated(
        itemCount: userModelList.length,
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: Color(0xff707070),
          );
        },
        itemBuilder: (BuildContext context, int index) {
          print("Imagee "+userModelList[index].image.toString());
          return ListTile(
            // onTap: () => Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => UserDetails(
            //       P_Agency_FilterId: widget.totalUserList[index].filter_id,
            //       totalUserList: widget.totalUserList[index],
            //     ))),
            leading: userModelList[index].image.toString() == "null"
                                    ? Image.asset(
                                        'assets/avatar.png',
                                      )
                                    : CircleAvatar(
                                      radius: 30,
                                        backgroundImage: NetworkImage(userModelList[index].image),
                                      ),
            title: Text(
              userModelList[index].name,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff000000)),
            ),
            // subtitle: Text(
            //   userModelList[index].message,
            //   style: TextStyle(fontSize: 12, color: Color(0xff818181)),
            // ),
            trailing: SizedBox(
              width: 115,
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {

                        // if(!isPressed) {
                        //   getAccessToken(widget.totalUserList[index].userId
                        //       .toString(), "VOICE");

                        // }
                      },
                      child: Icon(Icons.call, color: Colors.black,size: 24)),
                  SizedBox(width: 20,),
                  GestureDetector(
                      onTap: (){

                        // if(!isPressed){
                        //   getAccessToken(widget.totalUserList[index].userId.toString(), "VIDEO");

                        // }
                      },
                      child: Icon(Icons.video_call, color: Colors.black,size: 24)),

                  SizedBox(width: 20,),
                  GestureDetector(
                      onTap: () async {
                        // SharedPreferences pref = await SharedPreferences.getInstance();
                        // var id = pref.getString("id");
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(senderId:id, receiverId: widget.totalUserList[index].userId, name:  widget.totalUserList[index].name, image: widget.totalUserList[index].image,fcmToken: widget.totalUserList[index].firebase_token,userType: "user",)));
                      },
                      child: Icon(Icons.chat, color: Colors.black,size: 24)),
                ],
              ),
            ),
          );
        },
      ),
    );
  
  }

    Future<dynamic> featuredBusinessApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print Slider: " + id.toString());
    setState(() {
      isloading = true;
    });

    var request = http.post(
        Uri.parse(
          RestDatasource.ASSIGNEDUSER_URL,
        ),
        body: {
          "agent_id": id.toString(),
        });
    String msg = "";
    var jsonArray;
    var jsonRes;
    var res;

    await request.then((http.Response response) {
      res = response;
      final JsonDecoder _decoder = new JsonDecoder();
      jsonRes = _decoder.convert(response.body.toString());
      print("Response: " + response.body.toString() + "_");
      print("ResponseJSON: " + jsonRes.toString() + "_");
      msg = jsonRes["message"].toString();
      jsonArray = jsonRes['data'];
    });

    if (res.statusCode == 200) {
      print(jsonRes["status"]);
      //nearByRestaurantList.clear();
      if (jsonRes["status"].toString() == "true") {
        for (var i = 0; i < jsonArray.length; i++) {
         UserModel modelAgentSearch = new UserModel();
          modelAgentSearch.id = jsonArray[i]["id"].toString();
          modelAgentSearch.role_id = jsonArray[i]["role_id"].toString();
          modelAgentSearch.name = jsonArray[i]["name"].toString();
          modelAgentSearch.email = jsonArray[i]["email"].toString();
          modelAgentSearch.country_code = jsonArray[i]["country_code"].toString();
          modelAgentSearch.phone = jsonArray[i]["phone"].toString();
          modelAgentSearch.image = jsonArray[i]["image"].toString();
          modelAgentSearch.email_verified_at = jsonArray[i]["email_verified_at"].toString();
          modelAgentSearch.status = jsonArray[i]["status"].toString();
          modelAgentSearch.created_at = jsonArray[i]["created_at"].toString();
      

        

          print("id: " + modelAgentSearch.id.toString());


          userModelList.add(modelAgentSearch);
        }
        setState(() {
            isloading = false;
          });
        //Navigator.pop(context);
        // ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text(jsonRes["message"].toString())));
        // sliderBannerApi();
        //Navigator.pop(context);

        // Navigator.push(context, MaterialPageRoute(builder: (context) => Banners()));

      } else {
        setState(() {
          isloading = false;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(jsonRes["message"].toString())));
        });
      }
    } else {
      setState(() {
        isloading = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please try later")));
      });
    }
  }







}






class UserModel {

  var id = "";
  var role_id = "";
  var name = "";
  var email = "";
  var country_code = "";
  var phone = "";
  var image = "";
  var email_verified_at = "";
  var firebase_token= "";
  var status = "";
  var created_at = "";
  var updated_at = "";




}
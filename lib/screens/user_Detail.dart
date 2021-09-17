import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:roccabox_agent/screens/Setting.dart';
import 'package:roccabox_agent/services/APIClient.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserDetails extends StatefulWidget {

var P_Agency_FilterId;

  

  TotalUserList totalUserList ;

  UserDetails({Key? key,  required this.totalUserList , required this.P_Agency_FilterId})
      : super(key: key);
  @override
  _NotificationDetailsState createState() => _NotificationDetailsState();
}

class _NotificationDetailsState extends State<UserDetails> {
 bool isloading = false;
 late ModelSearchProperty modelSearch = ModelSearchProperty();

 @override
  void initState() {
    print("jhuh"+widget.P_Agency_FilterId+"^^");
    super.initState();
  isloading = true;
    getData();
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFFFFFF),
        elevation: 0,
        leading: BackButton(
          color: Colors.black,
        ),
        centerTitle: true,
        title: Text(
          "Enquiry Details",
          style: TextStyle(
              fontSize: 16,
              color: Color(0xff000000),
              fontWeight: FontWeight.w600),
        ),
      ),
      body: isloading == true? Center(child: CircularProgressIndicator(),):
      modelSearch == null ? Center(child: CircularProgressIndicator(),):
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              isThreeLine: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              leading: Image.asset(
                'assets/avatar.png',
                height: 60,
                width: 60,
              ),
              title: Text(
                widget.totalUserList.name,
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff000000),
                    fontWeight: FontWeight.w600),
              ),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.totalUserList.email.toString()),
                  Text(widget.totalUserList.phone.toString()),
                ],
              )
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: modelSearch.pictureList!=null?modelSearch.pictureList.length==0?Image.asset(
                "assets/blank.png",
                filterQuality: FilterQuality.high,
                fit: BoxFit.fill,
              ): Image.network(
                modelSearch.pictureList[0].PictureURL.toString(),
                filterQuality: FilterQuality.high,
                fit: BoxFit.fill,
              ):Image.asset(
                "assets/blank.png",
                filterQuality: FilterQuality.high,
                fit: BoxFit.fill,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Text(
                'Enquiry By-Clients Name',
                style: TextStyle(
                    fontSize: 20,
                    color: Color(0xff000000),
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child:isloading
                    ? Align(
                        alignment: Alignment.center,
                        child: Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Platform.isAndroid
                                ? CircularProgressIndicator()
                                : CupertinoActivityIndicator())) : Text(
                  widget.P_Agency_FilterId=="1"
                        ? modelSearch.price == null
                            ? ""
                            : '\€' + modelSearch.price
                        : widget.P_Agency_FilterId=="5"
                            ? modelSearch.price == null
                                ? ""
                                : 'From \€' + modelSearch.price
                            : modelSearch.RentalPrice1 != null
                                ? 'From \€' +
                                    modelSearch.RentalPrice1 +
                                    " per " +
                                    modelSearch.RentalPeriod
                                : "",
                style: TextStyle(
                    fontSize: 20,
                    color: Color(0xff000000),
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: Text(
                modelSearch.pool != null ? modelSearch.pool : "0",
                style: TextStyle(
                    fontSize: 20,
                    color: Color(0xff000000),
                    fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Text(
                modelSearch.Type +
                  " in " +
                  modelSearch.location +
                  " , " +
                  modelSearch.Area,
                style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff000000),
                    fontWeight: FontWeight.w300),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: Text(
                'Description',
                style: TextStyle(
                    fontSize: 20,
                    color: Color(0xff000000),
                    fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Text(
                modelSearch.description == null
                  ? ""
                  : modelSearch.description,
              softWrap: true,
              overflow: TextOverflow.fade,
                style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff706C6C),
                    height: 1.5,
                    wordSpacing: 2),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: Text(
                'Features',
                style: TextStyle(
                    fontSize: 20,
                    color: Color(0xff000000),
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: modelSearch.features != null
                    ? modelSearch.features.length
                    : 0,
                itemBuilder: (BuildContext context, int i) {
                  String s = modelSearch.features[i].Value.join(",");
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              modelSearch.features[i].Type,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: Text(
                              s,
                              textAlign: TextAlign.start,
                            ))
                      ],
                    ),
                  );
                }),
          ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var id = pref.getString("id").toString();
    print("Idd " + id.toString() + "");
    String uri = "https://webapi.resales-online.com/V6/PropertyDetails?" +
        "P_Agency_FilterId=" +
        widget.P_Agency_FilterId +
        "&" +
        "p1=" +
        "1021981" +
        "&p2=" +
        "8f065e421ed5b1cb8001f881e6fc675578cb9220"+
        "&P_RefId=" +
        widget.totalUserList.property_Rid;

    var request =
    http.post(Uri.parse(RestDatasource.NEWURL1), body: {"url": uri});

    var jsonRes;
    var res;
    await request.then((http.Response response) {
      res = response;
      final JsonDecoder _decoder = new JsonDecoder();
      jsonRes = _decoder.convert(response.body.toString());
      print("Ress " + jsonRes.toString() + "");
    });
    // print("ResponseJSON: " + respone.toString() + "_");
    // print("status: " + jsonRes["success"].toString() + "_");
    // print("message: " + jsonRes["message"].toString() + "_");

    if (res.statusCode == 200) {
      print("Response: " + jsonRes.toString() + "_");
      print(jsonRes["transaction"]["status"]);
      if (jsonRes["transaction"]["status"].toString() == "success") {
        modelSearch = new ModelSearchProperty();

        if(jsonRes["Property"] != null){

        
    
        print("PropertyId" + jsonRes["Property"]["Reference"] + "^^");
        modelSearch.referanceId = jsonRes["Property"]["Reference"];
        modelSearch.Area = jsonRes["Property"]["Area"];
        modelSearch.country = jsonRes["Property"]["Country"];
        modelSearch.description = jsonRes["Property"]["Description"];
        modelSearch.location = jsonRes["Property"]["Location"];
        modelSearch.province = jsonRes["Property"]["Province"];
        modelSearch.originalPrice =
            jsonRes["Property"]["OriginalPrice"].toString();
        modelSearch.price = jsonRes["Property"]["Price"].toString();
        modelSearch.RentalPrice1 =
            jsonRes["Property"]["RentalPrice1"].toString();
        modelSearch.RentalPrice2 =
            jsonRes["Property"]["RentalPrice2"].toString();
        modelSearch.RentalPeriod =
            jsonRes["Property"]["RentalPeriod"].toString();
        modelSearch.Type =
            jsonRes["Property"]["PropertyType"]["Type"].toString();
        modelSearch.bathrooms = jsonRes["Property"]["Bathrooms"].toString();
        modelSearch.bedrooms = jsonRes["Property"]["Bedrooms"].toString();
        modelSearch.pool = jsonRes["Property"]["Pool"].toString();
        modelSearch.mainImage = jsonRes["Property"]["MainImage"].toString();
        try {
          var picArray = [];
          var pictureObj;
          pictureObj = jsonRes["Property"]["Pictures"] != null
              ? jsonRes["Property"]["Pictures"]
              : null;
          picArray =
          pictureObj != null ? pictureObj["Picture"] : null;

          if (picArray != null) {
            for (var j = 0; j < picArray.length; j++) {
              Pictures pictures = new Pictures();
              pictures.PictureURL = picArray[j]["PictureURL"] != null
                  ? picArray[j]["PictureURL"]
                  : null;
              modelSearch.pictureList.add(pictures);
            }
          }
        } catch (e) {
          print(e.toString());
        }

        var propFeatures = [];
        var propFeaturesObj;
        propFeaturesObj = jsonRes["Property"]["PropertyFeatures"] != null
            ? jsonRes["Property"]["PropertyFeatures"]
            : null;
        propFeatures = propFeaturesObj != null
            ? propFeaturesObj["Category"]
            : null;

        if (propFeatures != null) {
          for (var j = 0; j < propFeatures.length; j++) {
            Features pictures = new Features();
            pictures.Type = propFeatures[j]["Type"] != null
                ? propFeatures[j]["Type"]
                : null;
            pictures.Value = propFeatures[j]["Value"] != null
                ? propFeatures[j]["Value"]
                : null;
            modelSearch.features.add(pictures);
          }
        }
        setState(() {
          isloading = false;
        });

        
      } else {
        setState(() {
          isloading = false;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(jsonRes["message"].toString())));
        });
      }
      }
    } else {
      setState(() {
        isloading = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please try leter")));
      });
    }
  }
}

class ModelSearchProperty{

  String referanceId = "";
  String priceStart = "";
  String priceTill = "";
  String propertyType = "";
  String location = "";
  String Area = "";
  String province = "";
  String Type = "";
  String nameType = "";
  String bedrooms = "";
  String pool = "";
  String mainImage = "";
  String bathrooms = "";
  String currency = "";
  String price = "";
  String originalPrice = "";
  String RentalPrice1 = "";
  String RentalPrice2 = "";
  String RentalPeriod = "";
  String description = "";
  String country = "";
  String Subtype1 = "";
  String SubtypeId1 = "";
  List<Pictures> pictureList = [];
  List<Features> features = [];
 }

 class Pictures{

  String PictureURL = "";

}

class Features{

  String Type = "";
  var Value = [];

}

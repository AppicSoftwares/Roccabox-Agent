import 'package:flutter/material.dart';
import 'package:roccabox_agent/main.dart';
import 'package:roccabox_agent/screens/homenav.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Language extends StatefulWidget {
  @override
  _LanguageState createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  var lang = 'English';


  @override
  void initState() {
    super.initState();
    if(langCount==1){
      lang = 'Spanish';
    }else{
      lang = 'English';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Color(0xff000000),
        ),
        backgroundColor: Color(0xffFFFFFF),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Language Change',
          style: TextStyle(
              fontSize: 16,
              color: Color(0xff000000),
              fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(
          children: [
            Container(
              height: 60,
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffFFBA00)),
                  borderRadius: BorderRadius.circular(10),
                  color: lang == 'English' ? Color(0xffFFBA00) : Colors.white),
              child: ListTile(
                onTap: () async{
                   var pref = await SharedPreferences.getInstance();
                  pref.setInt("lang",0);
                  pref.commit();
                  setState(() {
                    lang = 'English';
                    langCount = 0;
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomeNav()));
                  });
                },
                title: Text('English',
                    style: TextStyle(
                        fontSize: 16,
                        color:
                            lang == 'English' ? Colors.white : Colors.black)),

                // trailing: Container(
                //   margin: EdgeInsets.all(3),
                //   height: 20,
                //   width: 20,
                //   decoration: BoxDecoration(
                //       shape: BoxShape.circle, color: Colors.white),
                //   child: Text(' '),
                // ),
                trailing: Radio(
                    activeColor: Colors.white,
                    value: 'English',
                    groupValue: lang,
                    onChanged: (val) async{
                      var pref = await SharedPreferences.getInstance();

                      setState(() {
                        pref.setInt("lang",0);
                        pref.commit();
                        setState(() {
                          lang = val.toString();
                          langCount = 0;
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => HomeNav()));
                        });
                      });
                    }),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 60,
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffFFBA00)),
                  borderRadius: BorderRadius.circular(10),
                  color: lang == 'Spanish' ? Color(0xffFFBA00) : Colors.white),
              child: ListTile(
                onTap: () async {
                    var pref = await SharedPreferences.getInstance();
                  pref.setInt("lang",1);
                  pref.commit();
                  setState(() {
                    lang = 'Spanish';
                    langCount = 1;
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomeNav()));
                  });
                },
                title: Text('Spanish',
                    style: TextStyle(
                        fontSize: 16,
                        color:
                            lang == 'Spanish' ? Colors.white : Colors.black)),
                trailing: Radio(
                    activeColor: Colors.white,
                    value: 'Spanish',
                    groupValue: lang,
                    onChanged: (val) async{
                      var pref = await SharedPreferences.getInstance();

                      setState(() {
                        pref.setInt("lang",1);
                        pref.commit();
                        setState(() {
                          lang = val.toString();
                          langCount = 1;
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => HomeNav()));
                        });
                      });
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Language extends StatefulWidget {
  @override
  _LanguageState createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  var lang = 'English';

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
                onTap: () {
                  setState(() {
                    lang = 'English';
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
                    onChanged: (val) {
                      setState(() {
                        lang = val.toString();
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
                onTap: () {
                  setState(() {
                    lang = 'Spanish';
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
                    onChanged: (val) {
                      setState(() {
                        lang = val.toString();
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

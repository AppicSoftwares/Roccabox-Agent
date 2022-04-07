import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';



class ImageScreeen extends StatefulWidget {
  var image;
  ImageScreeen({Key? key, this.image}) : super(key: key);

  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreeen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: BackButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        title: Text("Image Viewer"),
      ),
      body: Container(
        child: Center(
          child:  PhotoView(
            imageProvider: NetworkImage(widget.image),
            loadingBuilder: (con, e){
              return Container(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xffFFBA00)),
                ),
                width: 200.0,
                height: 200.0,
                padding: EdgeInsets.all(70.0),
              );
            },
            minScale: 1/10,
            errorBuilder: (con, i,j){
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
          ),
        ),
      ),
    );
  }
}

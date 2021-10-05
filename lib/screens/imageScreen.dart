import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';



class ImageScreen extends StatefulWidget {
  var image;
  ImageScreen({Key? key, this.image}) : super(key: key);

  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: PhotoView(
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
          initialScale: 1/3,
          minScale: 1/3,
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
    );
  }
}

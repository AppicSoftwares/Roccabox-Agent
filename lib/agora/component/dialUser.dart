import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../sizeConfig.dart';

class DialUserPic extends StatelessWidget {
  DialUserPic({
    Key? key,
    this.size = 192,
    this.image,
  }) : super(key: key);

  final double size;
  var image;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30 / 192 * size),
      height: getProportionateScreenWidth(size),
      width: getProportionateScreenWidth(size),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.white.withOpacity(0.02),
            Colors.white.withOpacity(0.05)
          ],
          stops: [.5, 1],
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(100)),
        child: image.toString()=="null"? Image.asset(
          'assets/img_not_available.png',
          width: 200.0,
          height: 200.0,
          fit: BoxFit.cover,
        ): CachedNetworkImage(
          placeholder: (con, url ){
            return Image.asset(
              'assets/placeholder.png',
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
          imageUrl: image,
          width: 200.0,
          height: 200.0,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
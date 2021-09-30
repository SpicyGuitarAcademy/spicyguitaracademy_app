import 'package:flutter/material.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';

Widget backButton(context,
    {double radius: 5,
    double size: 20,
    double minWidth: 20,
    double padding: 20}) {
  return MaterialButton(
    minWidth: minWidth,
    color: Colors.white,
    padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding - 2),
    onPressed: () {
      Navigator.pop(context);
    },
    child: new Icon(Icons.arrow_back, color: brown, size: size),
    shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(radius),
        side: BorderSide(color: Colors.white)),
  );
}

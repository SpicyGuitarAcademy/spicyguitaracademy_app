import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spicyguitaracademy_app/providers/Course.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';

Widget renderDemoCourse(Course course, context, Function callback,
    {bool showProgress = true, bool showPricings = false, addMargin = false}) {
  double width =
      addMargin ? screen(context).width * 0.9 : screen(context).width * 0.93;
  return CupertinoButton(
    onPressed: () => callback(),
    padding: EdgeInsets.symmetric(
      vertical: 10,
    ),
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      width: width,
      // height: 150,
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: width,
            height: 200,
            decoration: new BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  '$baseUrl/${course.thumbnail}',
                  // headers: {'cache-control': 'max-age=0, must-revalidate'},
                  headers: {'cache-control': 'max-age=86400'},
                ),
                fit: BoxFit.fitWidth,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
                topLeft: Radius.circular(5),
              ),
            ),
            child: SvgPicture.asset(
              "assets/imgs/icons/play_video_icon.svg",
              color: Colors.white,
              fit: BoxFit.scaleDown,
            ),
          ),
        ],
      ),
    ),
  );
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spicyguitaracademy_app/providers/Lesson.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';

Widget renderDemoLesson(Lesson lesson, context, Function callback,
    {bool courseLocked = true, bool addMargin = false}) {
  double margin = addMargin ? 5 : 0;
  double width =
      addMargin ? screen(context).width * 0.9 : screen(context).width * 0.93;
  return CupertinoButton(
    onPressed: () => (courseLocked == false) ? callback() : null,
    padding: EdgeInsets.symmetric(
      vertical: 10,
    ),
    child: Container(
      width: width,
      margin: EdgeInsets.symmetric(horizontal: margin),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10.0, spreadRadius: 2.0)
        ],
      ),
      child: Container(
        width: screen(context).width,
        height: 200,
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: NetworkImage(
              '$baseUrl/${lesson.thumbnail}',
              // headers: {'cache-control': 'max-age=0, must-revalidate'},
              headers: {'cache-control': 'max-age=86400'},
            ),
            fit: BoxFit.fitWidth,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
        ),
        child: SvgPicture.asset(
          "assets/imgs/icons/play_video_icon.svg",
          color: Colors.white,
          fit: BoxFit.scaleDown,
        ),
      ),
    ),
  );
}

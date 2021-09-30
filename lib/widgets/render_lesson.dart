import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spicyguitaracademy_app/providers/Lesson.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';

Widget renderLesson(Lesson lesson, context, Function callback,
    {bool courseLocked = true}) {
  return CupertinoButton(
    onPressed: () => (courseLocked == false) ? callback() : null,
    padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
    child: Container(
      padding: EdgeInsets.only(bottom: 20),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10.0, spreadRadius: 2.0)
        ],
      ),
      child: Column(
        children: <Widget>[
          // add the thumbnail for the lesson
          Container(
            margin: EdgeInsets.only(bottom: 10),
            width: screen(context).width,
            height: 120,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: NetworkImage('$baseUrl/${lesson.thumbnail}',
                    headers: {'cache-control': 'max-age=0, must-revalidate'}),
                fit: BoxFit.fitWidth,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: courseLocked == true
                ? SvgPicture.asset("assets/imgs/icons/lock_icon.svg",
                    color: Colors.white, fit: BoxFit.scaleDown)
                : SvgPicture.asset(
                    "assets/imgs/icons/play_video_icon.svg",
                    color: Colors.white,
                    fit: BoxFit.scaleDown,
                  ),
          ),
          Container(
              width: screen(context).width,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(children: [
                Text(
                  "${lesson.title}",
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    color: brown,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  lesson.tutor!,
                  style: TextStyle(
                    color: Color.fromRGBO(112, 112, 112, 0.5),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "${lesson.description}",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify,
                  maxLines: 3,
                  style: TextStyle(
                    color: Color.fromRGBO(112, 112, 112, 1.0),
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ])),
        ],
      ),
    ),
  );
}

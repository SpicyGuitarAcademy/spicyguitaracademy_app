import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spicyguitaracademy_app/providers/Course.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';

Widget renderCourse(Course course, context, Function callback,
    {bool showProgress = true, bool showPricings = false}) {
  return CupertinoButton(
    onPressed: () => callback(),
    padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
    child: Container(
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10.0, spreadRadius: 2.0)
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: screen(context).width * 0.28,
            height: 100,
            decoration: new BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('$baseUrl/${course.thumbnail}',
                    headers: {'cache-control': 'max-age=0, must-revalidate'}),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5), topLeft: Radius.circular(5)),
            ),
            child: course.status == false
                ? SvgPicture.asset("assets/imgs/icons/lock_icon.svg",
                    color: Colors.white, fit: BoxFit.scaleDown)
                : SvgPicture.asset(
                    "assets/imgs/icons/play_video_icon.svg",
                    color: Colors.white,
                    fit: BoxFit.scaleDown,
                  ),
          ),
          SizedBox(width: 10),
          Expanded(
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(course.tutor!,
                            style: TextStyle(
                                color: darkgrey,
                                fontWeight: FontWeight.w600,
                                fontSize: 14)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Text(course.title!,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: brown,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800))),
                            Text(
                              "${course.allLessons} lessons",
                              style: TextStyle(
                                  color: darkgrey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800),
                            )
                          ],
                        ),
                        Text(course.description!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                color: darkgrey)),
                        SizedBox(height: 5),
                        showProgress == true
                            ? Column(
                                children: [
                                  // progress indicator
                                  Stack(
                                    alignment: Alignment.topLeft,
                                    children: <Widget>[
                                      // background
                                      Container(
                                        margin: EdgeInsets.only(right: 5),
                                        child: FractionallySizedBox(
                                          widthFactor: 1.0,
                                          child: Container(
                                            height: 2.0,
                                            color: grey,
                                          ),
                                        ),
                                      ),

                                      // indicator
                                      FractionallySizedBox(
                                        widthFactor: course.completedLessons ==
                                                0
                                            ? 0.005

                                            // conditional stmt to capture when
                                            // completed lesson is greater than
                                            // all lessons
                                            : (course.completedLessons! <=
                                                    course.allLessons!
                                                ? (course.completedLessons! /
                                                    course.allLessons!)
                                                : 1),
                                        child: Container(
                                          height: 2.0,
                                          color: brown,
                                        ),
                                      )
                                    ],
                                  ),
                                  // progress note
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        "${course.completedLessons} of ${course.allLessons} lessons",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            color: darkgrey,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800),
                                      ))
                                ],
                              )
                            : SizedBox(),
                        showPricings == true
                            ?
                            // display price
                            Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "₦${course.featuredprice}",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: darkgrey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800),
                                ))
                            : SizedBox(),
                      ]))),
          SizedBox(width: 10)
        ],
      ),
    ),
  );
}

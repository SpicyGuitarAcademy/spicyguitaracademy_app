import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spicyguitaracademy_app/providers/Assignment.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';

Widget renderAssignment(context) {
  return CupertinoButton(
      onPressed: () {
        Navigator.pushNamed(context, '/assignment_page');
      },
      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
      child: Container(
          padding: EdgeInsets.all(20),
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, blurRadius: 10.0, spreadRadius: 2.0)
            ],
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  "Course Assignment",
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    color: brown,
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  Assignment.tutor ?? 'No Tutor',
                  style: TextStyle(
                    color: Color.fromRGBO(112, 112, 112, 0.5),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  Assignment.questionNote ?? 'No note',
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    color: Color.fromRGBO(112, 112, 112, 1.0),
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 10.0),
                Text('Answer Ratings', style: TextStyle(color: brown)),
                Row(
                  children: [
                    Icon(
                        Assignment.answerRating! > 0
                            ? Icons.star
                            : Icons.star_border_outlined,
                        color: brown),
                    Icon(
                        Assignment.answerRating! > 1
                            ? Icons.star
                            : Icons.star_border_outlined,
                        color: brown),
                    Icon(
                        Assignment.answerRating! > 2
                            ? Icons.star
                            : Icons.star_border_outlined,
                        color: brown),
                    Icon(
                        Assignment.answerRating! > 3
                            ? Icons.star
                            : Icons.star_border_outlined,
                        color: brown),
                    Icon(
                        Assignment.answerRating! > 4
                            ? Icons.star
                            : Icons.star_border_outlined,
                        color: brown),
                  ],
                )
              ])));
}

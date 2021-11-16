import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spicyguitaracademy_app/providers/Assignment.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';

Widget renderAssignment(context) {
  return CupertinoButton(
    onPressed: () {
      Navigator.pushNamed(context, '/assignments_page');
    },
    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
    child: Container(
      padding: EdgeInsets.all(20),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10.0, spreadRadius: 2.0)
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
          SizedBox(height: 10),
          Text(
            Assignments.assignments!.length > 0
                ? '${Assignments.assignments!.length} Course Assignments'
                : '${Assignments.assignments!.length} Course Assignment',
            overflow: TextOverflow.visible,
            style: TextStyle(
              color: Color.fromRGBO(112, 112, 112, 1.0),
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 10),
          Text('Answer Ratings', style: TextStyle(color: brown)),
          Row(
            children: [
              Icon(
                  Assignments.rating! > 0
                      ? Icons.star
                      : Icons.star_border_outlined,
                  color: brown),
              Icon(
                  Assignments.rating! > 1
                      ? Icons.star
                      : Icons.star_border_outlined,
                  color: brown),
              Icon(
                  Assignments.rating! > 2
                      ? Icons.star
                      : Icons.star_border_outlined,
                  color: brown),
              Icon(
                  Assignments.rating! > 3
                      ? Icons.star
                      : Icons.star_border_outlined,
                  color: brown),
              Icon(
                  Assignments.rating! > 4
                      ? Icons.star
                      : Icons.star_border_outlined,
                  color: brown),
            ],
          )
        ],
      ),
    ),
  );
}

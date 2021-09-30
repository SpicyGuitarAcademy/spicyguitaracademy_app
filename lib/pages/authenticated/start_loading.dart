import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spicyguitaracademy_app/providers/Courses.dart';
import 'package:spicyguitaracademy_app/providers/Lessons.dart';
import 'package:spicyguitaracademy_app/providers/Student.dart';
import 'package:spicyguitaracademy_app/providers/StudentStudyStatistics.dart';
import 'package:spicyguitaracademy_app/providers/StudentSubscription.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';
import 'package:spicyguitaracademy_app/widgets/modals.dart';

class StartLoading extends StatefulWidget {
  @override
  StartLoadingState createState() => new StartLoadingState();
}

class StartLoadingState extends State<StartLoading> {
  @override
  void initState() {
    super.initState();
    // _initializeTimer();
  }

  bool? hasInit = false;

  // void _initializeTimer() {
  //   Timer(const Duration(seconds: 3),
  //       () => Navigator.pushReplacementNamed(context, "/dashboard"));
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<Student>(builder: (BuildContext context, student, child) {
      return Consumer<StudentSubscription>(
          builder: (BuildContext context, studentSubscription, child) {
        return Consumer<StudentStudyStatistics>(
            builder: (BuildContext context, studentStats, child) {
          return Consumer<Courses>(
              builder: (BuildContext context, courses, child) {
            return Consumer<Lessons>(
                builder: (BuildContext context, lessons, child) {
              if (!hasInit!) {
                try {
                  hasInit = true;
                  courses.getStudyingCourses();
                  courses.getAllCourses();
                  courses.getBoughtCourses();
                  courses.getFeaturedCourses();
                  lessons.getFreeLessons();
                  Navigator.pushReplacementNamed(context, "/dashboard");
                } catch (e) {
                  error(context, stripExceptions(e));
                }
              }

              return Scaffold(
                backgroundColor: grey,
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset("assets/imgs/icons/loading_icon.gif"),
                      Container(
                          margin: EdgeInsets.only(top: 30.0),
                          child: Text(
                            "Loading...",
                            style: TextStyle(color: brown, fontSize: 20),
                          ))
                    ],
                  ),
                ),
              );
            });
          });
        });
      });
    });
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spicyguitaracademy_app/providers/Courses.dart';
import 'package:spicyguitaracademy_app/providers/Lessons.dart';
import 'package:spicyguitaracademy_app/providers/StudentNotifications.dart';
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
    _initializeCoursesAndLessons();
  }

  void _initializeCoursesAndLessons() async {
    try {
      // initialize
      Courses courses = context.read<Courses>();
      StudentSubscription studentSubscription =
          context.read<StudentSubscription>();
      StudentStudyStatistics studentStats =
          context.read<StudentStudyStatistics>();
      Lessons lessons = context.read<Lessons>();
      StudentNotifications studentNotifications =
          context.read<StudentNotifications>();

      // get all courses
      await courses.getAllCourses();
      if (studentSubscription.isSubscribed == true &&
          studentStats.studyingCategory != 0) {
        await courses.getStudyingCourses();
      }

      // get featured and bought courses
      await courses.getBoughtCourses();
      if (courses.featuredCourses.length == 0)
        await courses.getFeaturedCourses();

      // get free lessons
      await lessons.getFreeLessons();

      await lessons
          .getCourseLessonsForStudyingCategory(studentStats.studyingCategory);

      // get notifications
      await studentNotifications.getNotifications();

      // Student.isLoaded = true;

      // route to dashboard
      Navigator.pushReplacementNamed(context, "/dashboard");
    } catch (e) {
      Navigator.pop(context);
      error(context, stripExceptions(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentNotifications>(
        builder: (BuildContext context, studentNotifications, child) {
      return Consumer<StudentSubscription>(
          builder: (BuildContext context, studentSubscription, child) {
        return Consumer<StudentStudyStatistics>(
            builder: (BuildContext context, studentStats, child) {
          return Consumer<Courses>(
              builder: (BuildContext context, courses, child) {
            return Consumer<Lessons>(
                builder: (BuildContext context, lessons, child) {
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

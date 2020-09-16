import 'package:flutter/material.dart';
import 'dart:async';

import 'package:spicyguitaracademy/services/app.dart';

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
    {
      var resp = await request('GET', allCourses);
      if (resp == false) Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      Map<String, dynamic> json = resp;
      Courses.allCourses = json;
    }
    {
      var resp = await request('GET', studyingCourses);
      if (resp == false) Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      List<dynamic> json = resp['courses'];
      Courses.studyingCourses = json;
    }
    {
      var resp = await request('GET', quickLessons);
      if (resp == false) Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      Map<String, dynamic> json = resp;
      Courses.quickLessons = json;
    }
    {
      var resp = await request('GET', freeLessons);
      if (resp == false) Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      List<dynamic> json = resp['lessons'];
      Courses.freeLessons = json;
    }
    Navigator.pushReplacementNamed(context, "/dashboard");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 243, 243, 1.0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/imgs/icons/loading_icon.png"),
            Container(
                margin: EdgeInsets.only(top: 30.0),
                child: Text(
                  "Loading...",
                  style: TextStyle(
                      color: Color.fromRGBO(107, 43, 20, 1.0), fontSize: 20),
                ))
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spicyguitaracademy_app/providers/StudentSubscription.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';

class NoFeaturedCoursesPage extends StatefulWidget {
  NoFeaturedCoursesPage();

  @override
  NoFeaturedCoursesPageState createState() => new NoFeaturedCoursesPageState();
}

class NoFeaturedCoursesPageState extends State<NoFeaturedCoursesPage> {
  NoFeaturedCoursesPageState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentSubscription>(
        builder: (BuildContext context, studentSubscription, child) {
      return Scaffold(
          body: SingleChildScrollView(
        child: Center(
          child: Column(children: <Widget>[
            SizedBox(height: 50),
            Text(
              "No Courses!",
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                  fontSize: 25.0, color: brown, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
            Text(
              studentSubscription.isSubscribed == false
                  ? "Choose a subscription plan"
                  : "Buy a course from the Pick Courses tab.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20.0, color: darkgrey, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 10),
            studentSubscription.isSubscribed == false
                ? MaterialButton(
                    minWidth: 15,
                    color: brown,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    onPressed: () => setState(() {
                      if (studentSubscription.isSubscribed == false) {
                        Navigator.pushNamed(context, '/choose_plan');
                      }
                    }),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 25.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  )
                : Container(),
          ]),
        ),
      ));
    });
  }
}

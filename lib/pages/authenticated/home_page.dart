import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:spicyguitaracademy_app/providers/Courses.dart';
import 'package:spicyguitaracademy_app/providers/Lesson.dart';
import 'package:spicyguitaracademy_app/providers/Lessons.dart';
import 'package:spicyguitaracademy_app/providers/Student.dart';
import 'package:spicyguitaracademy_app/providers/StudentStudyStatistics.dart';
import 'package:spicyguitaracademy_app/providers/StudentSubscription.dart';
import 'package:spicyguitaracademy_app/providers/Tutorial.dart';
import 'package:spicyguitaracademy_app/providers/Ui.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';
import 'package:spicyguitaracademy_app/widgets/render_demo_lesson.dart';
import 'package:spicyguitaracademy_app/widgets/render_lesson.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  List<Widget> renderRandomizedLessons(
      Student student,
      StudentStudyStatistics studentStats,
      StudentSubscription studentSubscription,
      Lessons lessons,
      Tutorial tutorial) {
    List<Widget> vids = [];

    Random rand = Random(400);
    lessons.studyingCateogryLessons!.shuffle(rand);

    lessons.studyingCateogryLessons!.forEach((lesson) {
      vids.add(
        renderDemoLesson(lesson, context, () {},
            addMargin: true, courseLocked: false),
      );
    });

    return vids;
  }

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
              return Consumer<Tutorial>(
                  builder: (BuildContext context, tutorial, child) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // welcome & search
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hi, ${student.firstname}",
                                style: TextStyle(
                                  color: brown,
                                  fontSize: 35.0,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text("Welcome"),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.search, color: brown),
                            iconSize: 30,
                            onPressed: () {
                              Navigator.pushNamed(context, '/search_page');
                            },
                          )
                        ],
                      ),
                      SizedBox(height: 20),

                      studentStats.studyingCategory! > 0
                          ?
                          // studying courses
                          Container(
                              width: screen(context).width,
                              height: 200,
                              child: ListView(
                                // This next line does the trick.
                                scrollDirection: Axis.horizontal,
                                children: renderRandomizedLessons(
                                    student,
                                    studentStats,
                                    studentSubscription,
                                    lessons,
                                    tutorial),
                              ),
                            )
                          :
                          // current category thumbnail
                          Container(
                              width: screen(context).width,
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                image: DecorationImage(
                                  image: AssetImage(defaultThumbnail),
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),

                      SizedBox(height: 10),

                      // subscription plan
                      studentSubscription.subscriptionPlan == '0'
                          ? ElevatedButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/choose_plan'),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Choose Subscription Plan",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(width: 10.0),
                                  Icon(Icons.arrow_forward),
                                ],
                              ),
                            )
                          : Column(
                              children: [
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.history, color: brown),
                                    SizedBox(width: 10),
                                    Text("Subscription Plan",
                                        style: TextStyle(
                                            color: brown,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                                SizedBox(height: 10),
                                Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(children: [
                                          Icon(Icons.bookmark,
                                              color: Color(0xFFDAA520)),
                                          SizedBox(width: 10),
                                          Text(
                                              "${studentSubscription.subscriptionPlanLabel}")
                                        ]),
                                        Text(
                                            "${studentSubscription.daysRemaining} day${studentSubscription.daysRemaining! > 1 ? 's' : ''} remaining"),
                                      ],
                                    )),
                              ],
                            ),

                      SizedBox(height: 5),

                      // current category details
                      studentStats.studyingCategory == 0
                          ? ElevatedButton(
                              onPressed: () => Navigator.pushNamed(
                                  context, '/choose_category'),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Choose a Category",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(Icons.arrow_forward),
                                ],
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(children: [
                                    Icon(Icons.bookmark,
                                        color: Color(0xFFDAA520)),
                                    SizedBox(width: 10),
                                    Text(
                                        "${studentStats.studyingCategoryLabel}")
                                  ]),
                                  Text(
                                      "${((studentStats.takenLessons! / studentStats.allLessons!) * 100).floor()}% Completed"),
                                ],
                              ),
                            ),

                      SizedBox(height: 5),

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(width: 3),
                                SvgPicture.asset(
                                  "assets/imgs/icons/spicyunit.svg",
                                  width: 20,
                                  matchTextDirection: true,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  '${student.referralUnits} Spicy Units',
                                  style: TextStyle(
                                      // fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: brown),
                                ),
                              ],
                            ),
                            MaterialButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/contact_for_spicyunits');
                              },
                              color: brown,
                              textColor: Colors.white,
                              child: Text(
                                'Buy more',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 30),

                      // last watched lesson

                      // free lessons
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "FREE LESSONS",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: brown,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      SizedBox(
                        width: screen(context).width,
                        child: Column(
                          children:
                              _loadFreeLessons(courses, lessons, tutorial),
                        ),
                      )
                    ],
                  ),
                );
              });
            });
          });
        });
      });
    });
  }

  List<Widget> _loadFreeLessons(
      Courses courses, Lessons lessons, Tutorial tutorial) {
    List<Lesson> freeLessons = lessons.freeLessons!;

    // tutorial lessons
    tutorial.tutorialLessons = freeLessons;

    lessons.source = LessonSource.free;
    List<Widget> vids = [];

    freeLessons.forEach((lesson) {
      vids.add(renderLesson(
        lesson,
        context,
        () {
          tutorial.setCurrentTutorial(lesson);
          Navigator.pushNamed(context, "/tutorial_page");
        },
        courseLocked: false,
      ));
    });

    return vids;
  }
}

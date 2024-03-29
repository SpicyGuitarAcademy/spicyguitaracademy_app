import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spicyguitaracademy_app/providers/Auth.dart';
import 'package:spicyguitaracademy_app/providers/Course.dart';
import 'package:spicyguitaracademy_app/providers/Courses.dart';
import 'package:spicyguitaracademy_app/providers/Lesson.dart';
import 'package:spicyguitaracademy_app/providers/Lessons.dart';
import 'package:spicyguitaracademy_app/providers/Student.dart';
import 'package:spicyguitaracademy_app/providers/StudentStudyStatistics.dart';
import 'package:spicyguitaracademy_app/providers/StudentSubscription.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';
import 'package:spicyguitaracademy_app/widgets/modals.dart';
import 'package:spicyguitaracademy_app/widgets/render_course.dart';
import 'package:spicyguitaracademy_app/widgets/render_lesson.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool authenticated = false;

  @override
  void initState() {
    super.initState();
    initiatePage();
  }

  bool fetchFeaturedCourses = false;
  bool fetchFreeLessons = false;

  Future initiatePage() async {
    try {
      Student student = context.read<Student>();
      Courses courses = context.read<Courses>();
      Lessons lessons = context.read<Lessons>();

      await student.canAuthWithCachedData();

      await courses.getFeaturedCourses();
      setState(() => fetchFeaturedCourses = true);
      await lessons.getFreeLessons();
      setState(() => fetchFreeLessons = true);
    } catch (e) {
      error(context, stripExceptions(e));
    }
  }

  List<Widget> renderFeaturedCourses(
      Student student,
      StudentStudyStatistics studentStats,
      StudentSubscription studentSubscription,
      Courses courses) {
    List<Widget> vids = [];
    List<int> indexes = [];

    Random rand = Random(10);
    if (courses.featuredCourses.length > 10) {
      while (vids.length < 10) {
        int index = rand.nextInt(courses.featuredCourses.length);

        if (!indexes.contains(index)) {
          Course course = courses.featuredCourses[index];

          vids.add(
            renderCourse(course, context, () async {
              if (Auth.authenticated == true) {
                await signInWithCachedData(
                    student, studentStats, studentSubscription);
              } else {
                Navigator.pushNamed(context, '/login');
              }
            }, showProgress: false, showPricings: false, addMargin: true),
          );

          indexes.add(index);
        }
      }
    } else {
      courses.featuredCourses.forEach((course) {
        vids.add(renderCourse(course, context, () async {
          if (Auth.authenticated == true) {
            await signInWithCachedData(
                student, studentStats, studentSubscription);
          } else {
            Navigator.pushNamed(context, '/login');
          }
        }));
      });
    }

    return vids;
  }

  List<Widget> renderFreeLessons(
      Student student,
      StudentStudyStatistics studentStats,
      StudentSubscription studentSubscription,
      Lessons lessons) {
    List<Widget> vids = [];
    List<int> indexes = [];

    Random rand = Random(10);
    if (lessons.freeLessons!.length > 10) {
      while (vids.length < 10) {
        int index = rand.nextInt(lessons.freeLessons!.length);

        if (!indexes.contains(index)) {
          Lesson lesson = lessons.freeLessons![index];

          vids.add(
            renderLesson(
              lesson,
              context,
              () {
                if (Auth.authenticated == true) {
                  signInWithCachedData(
                      student, studentStats, studentSubscription);
                } else {
                  Navigator.pushNamed(context, '/login');
                }
              },
            ),
          );

          indexes.add(index);
        }
      }
    } else {
      lessons.freeLessons!.forEach((lesson) {
        vids.add(
          renderLesson(lesson, context, () async {
            if (Auth.authenticated == true) {
              await signInWithCachedData(
                  student, studentStats, studentSubscription);
            } else {
              Navigator.pushNamed(context, '/login');
            }
          }, addMargin: true, courseLocked: false),
        );
      });
    }

    return vids;
  }

  Future signInWithCachedData(
      Student student,
      StudentStudyStatistics studentStats,
      StudentSubscription studentSubscription) async {
    try {
      loading(context);
      await student.signinWithCachedData();

      dynamic resp = await student.verifyDevice();
      if (resp['status'] == false) {
        Navigator.pop(context);
        Navigator.pushNamed(context, '/verify-device');
        error(context, resp['message']);
      } else {
        await studentSubscription.getStudentSubscriptionStatus();
        await studentStats.getStudentCategoryAndStats(studentSubscription);
        Navigator.pop(context);
        if (student.status != 'active') {
          Navigator.pushNamed(context, "/verify");
        } else {
          Navigator.pushNamed(context, "/welcome_note");
        }
      }
    } catch (e) {
      Navigator.pop(context);
      error(context, stripExceptions(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Student>(builder: (context, student, child) {
      return Consumer<StudentSubscription>(
          builder: (context, studentSubscription, child) {
        return Consumer<StudentStudyStatistics>(
            builder: (context, studentStats, child) {
          return Consumer<Courses>(builder: (context, courses, child) {
            return Consumer<Lessons>(builder: (context, lessons, child) {
              return Scaffold(
                  backgroundColor: Color.fromRGBO(107, 43, 20, 0.5),
                  body: Stack(children: <Widget>[
                    ShaderMask(
                      shaderCallback: (rect) {
                        return LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.bottomCenter,
                          colors: [
                            // Colors.accents,
                            Colors.black.withOpacity(0.7),
                            Colors.black.withOpacity(0.9),
                            Colors.black.withOpacity(1.0)
                          ],
                        ).createShader(
                            Rect.fromLTRB(0, 0, rect.width, rect.height));
                      },
                      blendMode: BlendMode.srcOver,
                      child: Container(
                        decoration: BoxDecoration(
                          // color: brown,
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/imgs/pictures/welcome_picture.jpg'),
                            fit: BoxFit.cover,
                            alignment: Alignment(-0.5, 6.0),
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: new Column(
                        children: <Widget>[
                          SizedBox(height: 50),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Hi, Welcome to Spicy Guitar Academy",
                              style: TextStyle(
                                color: grey,
                                fontSize: 25,
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          Auth.authenticated == false
                              ? Column(
                                  children: [
                                    SizedBox(
                                      width: screen(context).width,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, "/login");
                                        },
                                        child: Text('Login'),
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    SizedBox(
                                      width: screen(context).width,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, "/register");
                                        },
                                        child: Text('Sign Up'),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    SizedBox(
                                      width: screen(context).width,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          await signInWithCachedData(
                                              student,
                                              studentStats,
                                              studentSubscription);
                                        },
                                        child: Text(
                                            "Continue as ${student.firstname ?? 'Guest'}"),
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    SizedBox(
                                      width: screen(context).width,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          await student.signout();
                                        },
                                        child: Text('Sign Out'),
                                      ),
                                    ),
                                  ],
                                ),
                          SizedBox(height: 30),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Featured Courses",
                              style: TextStyle(
                                color: grey,
                                fontSize: 25,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          fetchFeaturedCourses
                              ? SizedBox(
                                  height: 120,
                                  width: screen(context).width,
                                  child: ListView(
                                    // This next line does the trick.
                                    scrollDirection: Axis.horizontal,
                                    children: renderFeaturedCourses(
                                        student,
                                        studentStats,
                                        studentSubscription,
                                        courses),
                                  ),
                                )
                              : Center(
                                  child: CircularProgressIndicator(
                                    color: brown,
                                  ),
                                ),
                          SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Free Lessons",
                              style: TextStyle(
                                color: grey,
                                fontSize: 25,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          fetchFreeLessons
                              ? SizedBox(
                                  height: 300,
                                  width: screen(context).width,
                                  child: ListView(
                                    // This next line does the trick.
                                    scrollDirection: Axis.horizontal,
                                    children: renderFreeLessons(
                                        student,
                                        studentStats,
                                        studentSubscription,
                                        lessons),
                                  ),
                                )
                              : Center(
                                  child: CircularProgressIndicator(
                                    color: brown,
                                  ),
                                ),
                        ],
                      ),
                    )
                  ]));
            });
          });
        });
      });
    });
  }
}

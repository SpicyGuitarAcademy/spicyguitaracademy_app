import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:spicyguitaracademy_app/providers/Assignment.dart';
import 'package:spicyguitaracademy_app/providers/Courses.dart';
import 'package:spicyguitaracademy_app/providers/Lessons.dart';
import 'package:spicyguitaracademy_app/providers/StudentStudyStatistics.dart';
import 'package:spicyguitaracademy_app/providers/Tutorial.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';
import 'package:spicyguitaracademy_app/widgets/modals.dart';
import 'package:spicyguitaracademy_app/widgets/render_assignment.dart';
import 'package:spicyguitaracademy_app/widgets/render_lesson.dart';

class LessonsPage extends StatefulWidget {
  @override
  LessonsPageState createState() => new LessonsPageState();
}

class LessonsPageState extends State<LessonsPage> {
  // properties
  bool courseLocked = false;

  @override
  void initState() {
    super.initState();
  }

  Widget assignmentWidget = Container();
  var courseId = 0;

  List<Widget> _loadLessons(StudentStudyStatistics studentStats,
      Courses courses, Lessons lessons, Tutorial tutorial) {
    // tutorial lessons
    tutorial.tutorialLessons = lessons.courseLessons;
    lessons.source = LessonSource.normal;
    List<Widget> vids = [];
    lessons.courseLessons?.forEach((lesson) {
      vids.add(renderLesson(lesson, context, () async {
        try {
          loading(context);
          tutorial.setCurrentTutorial(lesson);
          if (lessons.source == LessonSource.normal)
            await lessons.activateLesson(studentStats, courses);
          else if (lessons.source == LessonSource.featured)
            await lessons.activateFeaturedLesson(courses);
          Navigator.pop(context);
          Navigator.pushNamed(context, "/tutorial_page");
        } catch (e) {
          Navigator.pop(context);
          error(context, stripExceptions(e));
        }
      }, courseLocked: courseLocked));
    });

    // add asignment
    if (Assignment.status == true) {
      vids.add(renderAssignment(context));
    }

    return vids;
  }

  @override
  Widget build(BuildContext context) {
    final Map args = getRouteArgs(context);
    String courseTitle = args['courseTitle'] ?? "No Title";
    courseLocked = !args['courseActive'];
    courseId = args['courseId'];

    return Consumer<StudentStudyStatistics>(
        builder: (BuildContext context, studentStats, child) {
      return Consumer<Courses>(builder: (BuildContext context, courses, child) {
        return Consumer<Lessons>(
            builder: (BuildContext context, lessons, child) {
          return Consumer<Tutorial>(
              builder: (BuildContext context, tutorial, child) {
            return Scaffold(
                appBar: AppBar(
                    toolbarHeight: 70,
                    title: Row(children: [
                      Expanded(
                        child: Text("$courseTitle",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            )),
                      ),
                      Container(
                          padding: EdgeInsets.all(15),
                          color: darkbrown,
                          child: Text("${lessons.courseLessons?.length}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)))
                    ])),
                body: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                        children: _loadLessons(
                            studentStats, courses, lessons, tutorial))));
          });
        });
      });
    });
  }
}

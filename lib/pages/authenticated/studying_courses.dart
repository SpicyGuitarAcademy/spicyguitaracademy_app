import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spicyguitaracademy_app/providers/Courses.dart';
import 'package:spicyguitaracademy_app/providers/Lessons.dart';
import 'package:spicyguitaracademy_app/providers/StudentAssignments.dart';
import 'package:spicyguitaracademy_app/providers/StudentStudyStatistics.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';
import 'package:spicyguitaracademy_app/widgets/modals.dart';
import 'package:spicyguitaracademy_app/widgets/render_course.dart';

class StudyingCoursesPage extends StatefulWidget {
  @override
  StudyingCoursesPageState createState() => new StudyingCoursesPageState();
}

class StudyingCoursesPageState extends State<StudyingCoursesPage> {
  String _sortValue = "Order";
  int _courseCategory = 0;

  bool? initPage = false;

  @override
  void initState() {
    super.initState();
  }

  void _sortCourses(Courses courses) {
    switch (_sortValue) {
      case 'Order':
        setState(() {
          courses.sortCoursesByOrder(courses.studyingCourses);
        });
        break;
      case 'Tutor':
        setState(() {
          courses.sortCoursesByTutor(courses.studyingCourses);
        });
        break;
      case 'Title':
        setState(() {
          courses.sortCoursesByTitle(courses.studyingCourses);
        });
        break;
      default:
        setState(() {
          courses.sortCoursesByOrder(courses.studyingCourses);
        });
        break;
    }
  }

  Widget _loadCourses(StudentStudyStatistics studentStats, Courses courses,
      Lessons lessons, StudentAssignments studentAssignments) {
    List<Widget> vids = [];

    // add the image for the category
    vids.add(Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: screen(context).width,
      height: 120,
      decoration: new BoxDecoration(
        border:
            Border.all(color: darkgrey, width: 1.0, style: BorderStyle.solid),
        image: new DecorationImage(
          image: ExactAssetImage(getStudentCategoryThumbnail(studentStats,
              category: _courseCategory)),
          fit: BoxFit.fitWidth,
        ),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
    ));

    if (courses.studyingCourses.length > 0) {
      courses.studyingCourses.forEach((course) {
        vids.add(renderCourse(course, context, () async {
          try {
            // get the lessons on this course
            // and the assignments for the course
            lessons.source = LessonSource.normal;
            courses.currentCourse = course;
            loading(context);
            await courses.activateCourse(context);
            await lessons.getCourseLessons(context, course.id);
            await studentAssignments.getAssigment(course.id);

            Navigator.pop(context);
            Navigator.pushNamed(context, "/lessons_page", arguments: {
              'courseTitle': courses.currentCourse!.title,
              'courseActive': courses.currentCourse!.status,
              'courseId': courses.currentCourse!.id,
            });
          } catch (e) {
            Navigator.pop(context);
            error(context, stripExceptions(e));
          }
        }));
      });
    } else {
      vids.add(new Container(
          child: Text("Sorry, there are no courses at the moment")));
    }

    return new Column(children: vids);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentStudyStatistics>(
        builder: (BuildContext context, studentStats, child) {
      return Consumer<Courses>(builder: (BuildContext context, courses, child) {
        return Consumer<Lessons>(
            builder: (BuildContext context, lessons, child) {
          return Consumer<StudentAssignments>(
              builder: (BuildContext context, studentAssignments, child) {
            if (!initPage!) {
              initPage = true;
              if (courses.studyingCourses.length > 0) {
                _courseCategory = courses.studyingCourses[0].category ?? 1;
                // courses = studyingCourses;
              }
            }

            return SingleChildScrollView(
                child: Column(children: <Widget>[
              // The top text
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // description text
                    Text(
                      "Your\nCourses",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 30.0,
                          color: brown,
                          fontWeight: FontWeight.w500),
                    ),

                    // the sort button
                    Container(
                      // margin: EdgeInsets.only(top: 10, right: 5),
                      child: MaterialButton(
                        minWidth: 30,
                        color: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        onPressed: () {
                          List<String> sortValues = ['Order', 'Title', 'Tutor'];
                          setState(() {
                            _sortValue = _sortValue == 'Tutor'
                                ? 'Order'
                                : sortValues[
                                    sortValues.indexOf(_sortValue) + 1];
                            _sortCourses(courses);
                          });
                        },
                        child: Row(children: [
                          Text(
                            "$_sortValue",
                            style: TextStyle(color: brown, fontSize: 16),
                          ),
                          Icon(
                            Icons.sort,
                            color: brown,
                          ),
                        ]),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                      ),
                    )
                  ],
                ),
              ),

              _loadCourses(studentStats, courses, lessons, studentAssignments)
            ]));
          });
        });
      });
    });
  }
}

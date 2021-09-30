// import 'package:flutter/gestures.dart';
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

class BoughtCoursesPage extends StatefulWidget {
  @override
  BoughtCoursesPageState createState() => new BoughtCoursesPageState();
}

class BoughtCoursesPageState extends State<BoughtCoursesPage> {
  String _sortValue = "Order";
  int _courseCategory = 0;
  // dynamic courses;

  @override
  void initState() {
    super.initState();
  }

  void _sortCourses(Courses courses) {
    switch (_sortValue) {
      case 'Order':
        setState(() {
          courses.sortCoursesByOrder(courses.boughtCourses);
        });
        break;
      case 'Tutor':
        setState(() {
          courses.sortCoursesByTutor(courses.boughtCourses);
        });
        break;
      case 'Title':
        setState(() {
          courses.sortCoursesByTitle(courses.boughtCourses);
        });
        break;
      default:
        setState(() {
          courses.sortCoursesByOrder(courses.boughtCourses);
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

    if (courses.boughtCourses.length > 0) {
      courses.boughtCourses.forEach((course) {
        vids.add(renderCourse(course, context, () async {
          try {
            // get the lessons on this course
            // and the assignments for the course
            loading(context);
            // await Lessons.getLessons(context, course.id);
            await lessons.getFeaturedLessons(context, course.id);
            await studentAssignments.getAssigment(course.id);
            lessons.source = LessonSource.featured;
            courses.currentCourse = course;
            Navigator.pop(context);
            Navigator.pushNamed(context, "/lessons_page", arguments: {
              'courseTitle': course.title,
              'courseActive': course.status,
              'courseId': course.id,
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
            return SingleChildScrollView(
                child: Column(children: <Widget>[
              // The top text
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // description text
                    Text(
                      "Bought\nCourses",
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

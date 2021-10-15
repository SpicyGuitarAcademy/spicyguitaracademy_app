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

class FeaturedCourses extends StatefulWidget {
  @override
  FeaturedCoursesState createState() => new FeaturedCoursesState();
}

class FeaturedCoursesState extends State<FeaturedCourses> {
  @override
  void initState() {
    super.initState();
  }

  int _courseCategory = 1;
  String _sortValue = "Order";

  // function to sort the courses either by tutor or by title
  void _sortCourses(Courses courses) {
    switch (_sortValue) {
      case 'Order':
        setState(() {
          courses.sortCoursesByOrder(courses.featuredCourses);
        });
        break;
      case 'Tutor':
        setState(() {
          courses.sortCoursesByTutor(courses.featuredCourses);
        });
        break;
      case 'Title':
        setState(() {
          courses.sortCoursesByTitle(courses.featuredCourses);
        });
        break;
      default:
        setState(() {
          courses.sortCoursesByOrder(courses.featuredCourses);
        });
        break;
    }
  }

  Widget _loadCourses(StudentStudyStatistics studentStats, Courses courses,
      Lessons lessons, StudentAssignments studentAssignments) {
    List<Widget> vids = [];

    // add the image for the category
    vids.add(Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
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

    courses.featuredCourses.forEach((course) {
      vids.add(renderCourse(course, context, () async {
        try {
          loading(context);
          if (course.status == true) {
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
          } else {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/coursepreview_page',
                arguments: {'course': course});
          }
        } catch (e) {
          Navigator.pop(context);
          error(context, stripExceptions(e));
        }
      }, showProgress: false, showPricings: true));
    });

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // description text
                  Text(
                    "Buy\nCourses",
                    // "Featured\nCourses",
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
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      onPressed: () {
                        List<String> sortValues = ['Order', 'Title', 'Tutor'];
                        setState(() {
                          _sortValue = _sortValue == 'Tutor'
                              ? 'Order'
                              : sortValues[sortValues.indexOf(_sortValue) + 1];
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

              _loadCourses(studentStats, courses, lessons, studentAssignments)
            ]));
          });
        });
      });
    });
  }
}

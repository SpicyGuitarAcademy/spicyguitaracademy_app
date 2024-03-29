import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spicyguitaracademy_app/providers/Course.dart';
import 'package:spicyguitaracademy_app/providers/Courses.dart';
import 'package:spicyguitaracademy_app/providers/Lessons.dart';
import 'package:spicyguitaracademy_app/providers/StudentAssignments.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';
import 'package:spicyguitaracademy_app/widgets/modals.dart';
import 'package:spicyguitaracademy_app/widgets/render_course.dart';

class SearchPage extends StatefulWidget {
  @override
  SearchPageState createState() => new SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  // properties
  List<Widget> _searchResult = [];
  TextEditingController _search = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _searchCourses(value, Courses courses, Lessons lessons,
      StudentAssignments studentAssignments) {
    List<Widget> result = [];
    value = value.trim().toLowerCase();

    if (value.trim().isEmpty) return;

    [
      ...courses.beginnersCourses,
      ...courses.amateurCourses,
      ...courses.intermediateCourses,
      ...courses.advancedCourses
    ].forEach((Course course) {
      // allCourses.forEach((Course course) {
      var title = course.title!.trim().toLowerCase();
      var description = course.description!.trim().toLowerCase();
      var tutor = course.tutor!.trim().toLowerCase();

      if (title.contains(value) ||
          description.contains(value) ||
          tutor.contains(value)) {
        // print("r: " + course.title);
        result.add(renderCourse(course, context, () async {
          try {
            if (course.status == true) {
              loading(context);
              await lessons.getCourseLessons(context, course.id);
              await studentAssignments.getAssigment(course.id);
              lessons.source = LessonSource.normal;
              Navigator.pop(context);
              Navigator.pushNamed(context, "/lessons_page", arguments: {
                'courseTitle': course.title,
                'courseActive': course.status,
                'courseId': course.id,
              });
            }
          } catch (e) {
            Navigator.pop(context);
            error(context, stripExceptions(e));
          }
        }, showProgress: false));
      }
    });

    setState(() {
      if (result.isEmpty) {
        result.add(Container(child: Text("No result.")));
      }
      _searchResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Courses>(builder: (BuildContext context, courses, child) {
      return Consumer<Lessons>(builder: (BuildContext context, lessons, child) {
        return Consumer<StudentAssignments>(
            builder: (BuildContext context, studentAssignments, child) {
          return new Scaffold(
            backgroundColor: grey,
            appBar: AppBar(
              toolbarHeight: 70,
              iconTheme: IconThemeData(color: brown),
              backgroundColor: grey,
              centerTitle: true,
              title: Text(
                'Search',
                style: TextStyle(
                    color: brown,
                    fontSize: 30,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.normal),
              ),
              elevation: 0,
            ),
            body: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(children: <Widget>[
                  // Search container
                  Container(
                      padding: EdgeInsets.all(5),
                      width: screen(context).width,
                      decoration: BoxDecoration(
                        color: grey,
                      ),
                      child: TextField(
                          controller: _search,
                          autocorrect: true,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (value) => _searchCourses(
                              value, courses, lessons, studentAssignments),
                          style: TextStyle(fontSize: 20.0, color: brown),
                          decoration: InputDecoration(
                              hintText: "Search courses",
                              suffix: IconButton(
                                  onPressed: () {
                                    // _searchCourses(_search.text);
                                  },
                                  icon: Icon(
                                    Icons.search,
                                    color: brown,
                                  ))))),

                  Column(
                    children: _searchResult,
                  )
                ])),
          );
        });
      });
    });
  }
}

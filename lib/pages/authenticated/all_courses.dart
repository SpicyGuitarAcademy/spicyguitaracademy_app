import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spicyguitaracademy_app/providers/Courses.dart';
import 'package:spicyguitaracademy_app/providers/StudentStudyStatistics.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';
import 'package:spicyguitaracademy_app/widgets/render_course.dart';

class AllCoursesPage extends StatefulWidget {
  @override
  AllCoursesPageState createState() => new AllCoursesPageState();
}

class AllCoursesPageState extends State<AllCoursesPage> {
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
          courses.sortCoursesByOrder(courses.beginnersCourses);
          courses.sortCoursesByOrder(courses.amateurCourses);
          courses.sortCoursesByOrder(courses.intermediateCourses);
          courses.sortCoursesByOrder(courses.advancedCourses);
        });
        break;
      case 'Tutor':
        setState(() {
          courses.sortCoursesByTutor(courses.beginnersCourses);
          courses.sortCoursesByTutor(courses.amateurCourses);
          courses.sortCoursesByTutor(courses.intermediateCourses);
          courses.sortCoursesByTutor(courses.advancedCourses);
        });
        break;
      case 'Title':
        setState(() {
          courses.sortCoursesByTitle(courses.beginnersCourses);
          courses.sortCoursesByTitle(courses.amateurCourses);
          courses.sortCoursesByTitle(courses.intermediateCourses);
          courses.sortCoursesByTitle(courses.advancedCourses);
        });
        break;
      default:
        setState(() {
          courses.sortCoursesByOrder(courses.beginnersCourses);
          courses.sortCoursesByOrder(courses.amateurCourses);
          courses.sortCoursesByOrder(courses.intermediateCourses);
          courses.sortCoursesByOrder(courses.advancedCourses);
        });
        break;
    }
  }

  Widget _loadCourses(StudentStudyStatistics studentStats, Courses courses) {
    List<Widget> vids = [];
    List<dynamic> videos;

    switch (_courseCategory) {
      case 1:
        videos = courses.beginnersCourses;
        break;
      case 2:
        videos = courses.amateurCourses;
        break;
      case 3:
        videos = courses.intermediateCourses;
        break;
      case 4:
        videos = courses.advancedCourses;
        break;
      default:
        videos = courses.beginnersCourses;
        break;
    }

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

    videos.forEach((course) {
      vids.add(renderCourse(course, context, () => {}, showProgress: false));
    });

    return new Column(children: vids);
  }

  Widget categoryIdentification(category, categoryLabel) {
    return InkWell(
      onTap: () {
        setState(() {
          _courseCategory = category;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$categoryLabel',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: _courseCategory == category ? brown : darkgrey,
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 5),
                width: 40,
                height: 5,
                color: _courseCategory == category ? brown : Colors.transparent)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentStudyStatistics>(
        builder: (BuildContext context, studentStats, child) {
      return Consumer<Courses>(builder: (BuildContext context, courses, child) {
        return SingleChildScrollView(
            child: Column(children: <Widget>[
          // The top text
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // description text
              Text(
                "Find Amazing\nCourses",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 30.0, color: brown, fontWeight: FontWeight.w500),
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

          // the category identification

          Container(
            width: screen(context).width,
            height: 50,
            padding: EdgeInsets.symmetric(vertical: 5),
            child: ListView(
              // This next line does the trick.
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                categoryIdentification(1, 'Beginners'),
                categoryIdentification(2, 'Amateurs'),
                categoryIdentification(3, 'Intermediates'),
                categoryIdentification(4, 'Advanced')
              ],
            ),
          ),

          _loadCourses(studentStats, courses)
        ]));
      });
    });
  }
}

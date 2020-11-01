// import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math';
import '../../services/app.dart';

// import the all and the studying
// import './all_courses.dart';
// import './studying_courses.dart';

class StyudyingCoursesPage extends StatefulWidget {
  StyudyingCoursesPage();

  @override
  StyudyingCoursesPageState createState() => new StyudyingCoursesPageState();
}

class SCourses {
  // the properties on the class
  String thumbnail, tutor, title, description;
  num courseId, completedLessons, allLessons;
  bool courseStatus;
  // the constructor
  SCourses(
      this.courseId,
      this.thumbnail,
      this.tutor,
      this.title,
      this.description,
      this.completedLessons,
      this.allLessons,
      this.courseStatus);
  // constructing from json
  SCourses.fromJson(Map<String, dynamic> json) {
    courseId = int.parse(json['id']);
    thumbnail = json['thumbnail'];
    tutor = json['tutor'];
    title = json['course'];
    description = json['description'];
    completedLessons = int.parse(json['done']);
    allLessons = int.parse(json['total']);
    courseStatus = json['status'] == '1' || json['status'] == '2';
  }
}

parseCourses(_courses) {
  var courses = <dynamic>[];
  for (var course in _courses) {
    courses.add(new SCourses.fromJson(course));
  }
  return courses;
}

getLessons(courseId) async {
  var resp = await request('GET', courseLessons(courseId));
  if (resp == false) return [];
  List<dynamic> json = resp['lessons'];
  return json;
}

class StyudyingCoursesPageState extends State<StyudyingCoursesPage> {
  StyudyingCoursesPageState();

  @override
  void initState() {
    super.initState();
  }

  final courses = parseCourses(Courses.studyingCourses);

  final categoryThumbnails = [
    "assets/imgs/pictures/beginners_thumbnail.jpg",
    "assets/imgs/pictures/amateur_thumbnail.jpg",
    "assets/imgs/pictures/intermediate_thumbnail.jpg",
    "assets/imgs/pictures/advanced_thumbnail.jpg"
  ];

  String _sortValue = "Tutor";
  num _courseCategory = int.parse(Courses.studyingCourses[0]["category"]) ?? 1;

  // function to sort the courses either by tutor or by title
  void _sortCourses() {
    if (_sortValue == "Tutor") {
      setState(() {
        courses.sort((a, b) => a.tutor.compareTo(b.tutor));
        _sortValue = "Title";
      });
    } else {
      setState(() {
        courses.sort((a, b) => a.title.compareTo(b.title));
        _sortValue = "Tutor";
      });
    }
  }

  Widget _loadCourses(Orientation orientation) {
    List<Widget> vids = new List<Widget>();

    // Map<String, dynamic> lessonsParsed = json.jsonDecode(lessonsJson);
    // Lessons lessons = Lessons.fromJson(lessonsParsed);

    var videos;
    // _sortCourses();
    videos = courses;

    // add the image for the category
    vids.add(Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      width: MediaQuery.of(context).copyWith().size.width,
      height: 200.00,
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: ExactAssetImage(categoryThumbnails[_courseCategory - 1]),
          fit: BoxFit.fitWidth,
        ),
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
    ));

    videos.forEach((course) {
      vids.add(new Container(
        margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        child: CupertinoButton(
            onPressed: () async {
              List<dynamic> lessons = await getLessons(course.courseId);
              Navigator.pushNamed(context, "/studying_courses_lessons",
              arguments: {
                    'courseLessons': lessons,
                    'courseTitle': course.title,
                    'noLessons': course.allLessons ?? 0
                  });
            },
            child: Stack(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(left: 70),
                    width: MediaQuery.of(context).copyWith().size.width - 100,
                    height: 160.00,
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10.0,
                            spreadRadius: 2.0)
                      ],
                    ),
                    child: Container(
                        margin: EdgeInsets.only(
                            left: 60, right: 3, top: 20, bottom: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            // tutor
                            Text(
                              course.tutor,
                              style: TextStyle(
                                color: Color.fromRGBO(112, 112, 112, 1.0),
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            // Title
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: orientation == Orientation.portrait
                                      ? MediaQuery.of(context)
                                              .copyWith()
                                              .size
                                              .width -
                                          300
                                      : MediaQuery.of(context)
                                              .copyWith()
                                              .size
                                              .width -
                                          300,
                                  child: Text(
                                    course.title,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Color.fromRGBO(107, 43, 20, 1.0),
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: Text(
                                    course.allLessons.toString() + " lessons",
                                    style: TextStyle(
                                      color: Color.fromRGBO(112, 112, 112, 1.0),
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                )
                              ],
                            ),

                            // description
                            Text(
                              course.description,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                color: Color.fromRGBO(112, 112, 112, 1.0),
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),

                            // progress indicator
                            Stack(
                              alignment: Alignment.topLeft,
                              // fit: StackFit.passthrough,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(right: 5),
                                  child: FractionallySizedBox(
                                    widthFactor: 1.0,
                                    child: Container(
                                      height: 2.0,
                                      color: Color.fromRGBO(112, 112, 112, 0.3),
                                    ),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: course.completedLessons == 0
                                      ? 0.005
                                      : (course.completedLessons /
                                          course.allLessons),
                                  child: Container(
                                    height: 2.0,
                                    color: Color.fromRGBO(107, 43, 20, 1.0),
                                  ),
                                )
                              ],
                            ),

                            // progress note
                            Container(
                                alignment: Alignment.centerRight,
                                margin: EdgeInsets.only(right: 5),
                                child: Text(
                                    course.completedLessons.toString() +
                                        " of " +
                                        course.allLessons.toString() +
                                        " Lessons",
                                    style: TextStyle(
                                      color: Color.fromRGBO(112, 112, 112, 1.0),
                                      fontSize: 12.0,
                                    )))
                          ],
                        ))),

                // course thumbnail
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  width: 120.00,
                  height: 120.00,
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      // image: ExactAssetImage(course.thumbnail),
                      image: NetworkImage('${App.appurl}/${course.thumbnail}'),
                      fit: BoxFit.fitHeight,
                      colorFilter: course.courseStatus == true
                          ? null
                          : ColorFilter.mode(Colors.black87, BlendMode.overlay),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 7.0,
                          spreadRadius: 5.0)
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  child: course.courseStatus == true
                      ? null
                      : SvgPicture.asset("assets/imgs/icons/lock_icon.svg",
                          color: Colors.white,
                          // color: Color.fromRGBO(107, 43, 20, 1.0),
                          fit: BoxFit.scaleDown),
                ),
              ],
            )),
      ));
    });

    return new Column(children: vids);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Color.fromRGBO(243, 243, 243, 1.0),
        body: OrientationBuilder(builder: (context, orientation) {
          // All Page
          return SingleChildScrollView(
            child: Column(children: <Widget>[
              // The top text
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // description text
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 5),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Your",
                              textAlign: TextAlign.start,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 30.0,
                                  color: Color.fromRGBO(107, 43, 20, 1.0),
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "Courses",
                              textAlign: TextAlign.start,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 30.0,
                                  color: Color.fromRGBO(107, 43, 20, 1.0),
                                  fontWeight: FontWeight.w500),
                            ),
                          ]),
                    ),

                    // the sort button
                    Container(
                      margin: EdgeInsets.only(top: 10, right: 5),
                      child: MaterialButton(
                        minWidth: 15,
                        color: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        onPressed: () => setState(() {
                          _sortCourses();
                        }),
                        child: Transform.rotate(
                          angle: pi / 2,
                          child: Icon(
                            Icons.tune,
                            color: Color.fromRGBO(107, 43, 20, 1.0),
                            size: 25.0,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          // side: BorderSide(color: Color.fromRGBO(107, 43, 20, 1.0))
                        ),
                      ),
                    )
                  ],
                ),
              ),

              _loadCourses(orientation)
            ]),
          );
        }));
  }
}

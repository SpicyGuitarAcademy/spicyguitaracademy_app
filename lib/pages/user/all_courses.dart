// import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import '../../services/app.dart';

// import the all and the studying
// import './all_courses.dart';
// import './studying_courses.dart';

class AllCoursesPage extends StatefulWidget{

  AllCoursesPage();

  @override
  AllCoursesPageState createState() => new AllCoursesPageState();
}

class Courses
{
  // the properties on the class
  String thumbnail, tutor, title, description, lessons;
  num courseId;

  // the constructor
  Courses(this.courseId, this.thumbnail, this.tutor, this.title, this.description, this.lessons);
  // constructing from json
  Courses.fromJson(Map <String, dynamic> json) {
    thumbnail = json['courseId'];
    thumbnail = json['thumbnail'];
    tutor = json['tutor'];
    title = json['title'];
    description = json['description'];
    lessons = json['lessons'];
  }
}

class AllCoursesPageState extends State<AllCoursesPage> {

  AllCoursesPageState();

  @override
  void initState() {
    super.initState();
  }

  final beginnersCourses = [
    new Courses(1, "assets/imgs/pictures/course_img_default.jpg", "Ebuka Odini", "Beginners Chords", "Learn how to play open chords from scratch.", "12"),
    new Courses(2, "assets/imgs/pictures/course_img_default.jpg", "Oc Omofuma", "G Chords", "Learn how to play G chords from scratch.", "42"),
    new Courses(3, "assets/imgs/pictures/course_img_default.jpg", "Samuel Kalu", "Bar Chords", "Learn how to play bar chords from scratch.", "35"),
    new Courses(4, "assets/imgs/pictures/course_img_default.jpg", "Lionel Lionel", "Strumming", "Learn how to strum strings easily.", "28"),
  ];

  final amateurCourses = [
    new Courses(1, "assets/imgs/pictures/course_img_default.jpg", "Ebuka Odini", "Amateur Chords", "Learn how to play open chords from scratch. Learn how to play open chords from scratch.", "12"),
    new Courses(2, "assets/imgs/pictures/course_img_default.jpg", "Oc Omofuma", "G Chords", "Learn how to play G chords from scratch.", "42"),
    new Courses(3, "assets/imgs/pictures/course_img_default.jpg", "Samuel Kalu", "Bar Chords", "Learn how to play bar chords from scratch.", "35"),
    new Courses(4, "assets/imgs/pictures/course_img_default.jpg", "Lionel Lionel", "Strumming", "Learn how to strum strings easily.", "28"),
  ];

  final intermediateCourses = [
    new Courses(1, "assets/imgs/pictures/course_img_default.jpg", "Ebuka Odini", "Intermediate Chords", "Learn how to play open chords from scratch.", "12"),
    new Courses(2, "assets/imgs/pictures/course_img_default.jpg", "Oc Omofuma", "G Chords", "Learn how to play G chords from scratch.", "42"),
    new Courses(3, "assets/imgs/pictures/course_img_default.jpg", "Samuel Kalu", "Bar Chords", "Learn how to play bar chords from scratch.", "35"),
    new Courses(4, "assets/imgs/pictures/course_img_default.jpg", "Lionel Lionel", "Strumming", "Learn how to strum strings easily.", "28"),
  ];

  final advancedCourses = [
    new Courses(1, "assets/imgs/pictures/course_img_default.jpg", "Ebuka Odini", "Advanced Chords", "Learn how to play open chords from scratch.", "12"),
    new Courses(2, "assets/imgs/pictures/course_img_default.jpg", "Oc Omofuma", "G Chords", "Learn how to play G chords from scratch.", "42"),
    new Courses(3, "assets/imgs/pictures/course_img_default.jpg", "Samuel Kalu", "Bar Chords", "Learn how to play bar chords from scratch.", "35"),
    new Courses(4, "assets/imgs/pictures/course_img_default.jpg", "Lionel Lionel", "Strumming", "Learn how to strum strings easily.", "28"),
  ];

  final categoryThumbnails = [];
  String beginnersCategoryThumbnails = "assets/imgs/pictures/beginners_thumbnail.jpg";
  String amateurCategoryThumbnails = "assets/imgs/pictures/amateur_thumbnail.jpg";
  String intermediaryCategoryThumbnails = "assets/imgs/pictures/intermediate_thumbnail.jpg";
  String advancedCategoryThumbnails = "assets/imgs/pictures/advanced_thumbnail.jpg";

  String _sortBeginnersValue = "Tutor";
  String _sortAmateurValue = "Tutor";
  String _sortIntermediateValue = "Tutor";
  String _sortAdvancedValue = "Tutor";
  int _courseCategory = 0;

  // function to sort the courses either by tutor or by title
  void _sortCourses() {

      switch (_courseCategory) {
        case 0:
          if (_sortBeginnersValue == "Tutor") {
            setState(() {
              beginnersCourses.sort((a, b) => a.tutor.compareTo(b.tutor));
              _sortBeginnersValue = "Title";
            });
          } else {
            setState(() {
              beginnersCourses.sort((a, b) => a.title.compareTo(b.title));
              _sortBeginnersValue = "Tutor";
            });
          }
          break;
        case 1:
          if (_sortAmateurValue == "Tutor") {
            setState(() {
              amateurCourses.sort((a, b) => a.tutor.compareTo(b.tutor));
              _sortAmateurValue = "Title";
            });
          } else {
            setState(() {
              amateurCourses.sort((a, b) => a.title.compareTo(b.title));
              _sortAmateurValue = "Tutor";
            });
          }
          break;
        case 2:
          if (_sortIntermediateValue == "Tutor") {
            setState(() {
              intermediateCourses.sort((a, b) => a.tutor.compareTo(b.tutor));
              _sortIntermediateValue = "Title";
            });
          } else {
            setState(() {
              intermediateCourses.sort((a, b) => a.title.compareTo(b.title));
              _sortIntermediateValue = "Tutor";
            });
          }
          break;
        case 3:
          if (_sortAdvancedValue == "Tutor") {
            setState(() {
              advancedCourses.sort((a, b) => a.tutor.compareTo(b.tutor));
              _sortAdvancedValue = "Title";
            });
          } else {
            setState(() {
              advancedCourses.sort((a, b) => a.title.compareTo(b.title));
              _sortAdvancedValue = "Tutor";
            });
          }
          break;
        default:
      }

    // });
  }

  Widget _loadCourses(Orientation orientation) {
    List <Widget> vids = new List<Widget>();

    // Map<String, dynamic> lessonsParsed = json.jsonDecode(lessonsJson);
    // Lessons lessons = Lessons.fromJson(lessonsParsed);

    var videos;
    // _sortCourses();

    switch (_courseCategory) {
      case 0:
        videos = beginnersCourses;
        break;
      case 1:
        videos = amateurCourses;
        break;
      case 2:
        videos = intermediateCourses;
        break;
      case 3:
        videos = advancedCourses;
        break;
      default:
    }

    var thumbnail;
    switch (_courseCategory) {
      case 0:
        thumbnail = beginnersCategoryThumbnails;
        break;
      case 1:
        thumbnail = amateurCategoryThumbnails;
        break;
      case 2:
        thumbnail = intermediaryCategoryThumbnails;
        break;
      case 3:
        thumbnail = advancedCategoryThumbnails;
        break;
      default:
    }

    // add the image for the category
    vids.add(
      Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        width: MediaQuery.of(context).copyWith().size.width,
        height: 200.00,
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: ExactAssetImage(thumbnail),
            fit: BoxFit.fitWidth,
          ),
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        
      )
    );

    videos.forEach((course){

      vids.add(
        new Container(
          margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          child: CupertinoButton(
            onPressed: (){ Navigator.pushNamed(context, "/allcourses_lessons"); },
            child: Stack(
              children: <Widget>[

                Container(
                  margin: EdgeInsets.only(left:70),
                  width: MediaQuery.of(context).copyWith().size.width - 100,
                  height: 160.00,
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 10.0, spreadRadius: 2.0 )
                    ],
                  ),
                  
                  child: 
                  Container(
                    margin: EdgeInsets.only(left: 60, right: 3, top: 30, bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        
                        Text(course.tutor,
                          style: TextStyle(
                            color: Color.fromRGBO(112, 112, 112, 1.0),
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: orientation == Orientation.portrait ? MediaQuery.of(context).copyWith().size.width - 300 : MediaQuery.of(context).copyWith().size.width - 300 ,
                              child:
                              Text(course.title, 
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Color.fromRGBO(107, 43, 20, 1.0),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
    
                            ), 
                            
                            Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Text(course.lessons + " lessons", 
                                style: TextStyle(
                                  color: Color.fromRGBO(112, 112, 112, 1.0),
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            )
                            
                          ],
                        
                        ),
                        
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

                      ],
                    )
                  )

                ),

                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  width: 120.00,
                  height: 120.00,
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image: ExactAssetImage(course.thumbnail),
                      fit: BoxFit.fitHeight,
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 7.0, spreadRadius: 5.0 )
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  
                ),

              ],
            )
          ),
        )
      );
    
    });
      
    return new Column(children: vids);
  }

  @override
  Widget build(BuildContext context) {
    
    return new Scaffold(
      backgroundColor: Color.fromRGBO(243, 243, 243, 1.0),
      body: OrientationBuilder(
        
        builder: (context, orientation) {
          
          // All Page
          return 
          SingleChildScrollView(
            child: Column(
              
              children: <Widget>[

                // The top text
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[

                    // description text
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 5),
                      child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Find Amazing",
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 30.0,
                              color: Color.fromRGBO(107, 43, 20, 1.0),
                              fontWeight: FontWeight.w500
                            ),
                          ),
                          Text(
                            "Courses",
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 30.0,
                              color: Color.fromRGBO(107, 43, 20, 1.0),
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ]
                      ),
                    ),
                    
                    // the sort button
                    Container(
                      margin: EdgeInsets.only(top: 10, right: 5),
                      child: 
                      MaterialButton(
                        minWidth: 15, 
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        onPressed: () => setState(() {
                          _sortCourses();
                        }),
                        child: Transform.rotate(
                          angle: pi/2,
                          child: Icon(Icons.tune, color: Color.fromRGBO(107, 43, 20, 1.0), size: 25.0,),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          // side: BorderSide(color: Color.fromRGBO(107, 43, 20, 1.0))
                        ),
                      ),
                    )

                  ],
                ),

                // the category identification
                Container(
                  margin: EdgeInsets.symmetric(vertical: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[

                      MaterialButton(
                        onPressed: () => setState(() {
                          _courseCategory = 0;
                          // _loadCourses();
                        }),
                        child: 
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Beginners",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: _courseCategory == 0 ? 15 : 12,
                                color: _courseCategory == 0 ? Color.fromRGBO(107, 43, 20, 1.0) : Color.fromRGBO(112, 112, 112, 1.0),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 6,
                              width: 20,
                              color: _courseCategory == 0 ? Color.fromRGBO(107, 43, 20, 1.0) : Colors.transparent,
                            )
                          ],
                        )
                        
                      ),
                      
                      MaterialButton(
                        onPressed: () => setState(() {
                          _courseCategory = 1;
                          // _loadCourses();
                        }),
                        child: 
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Amateur",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: _courseCategory == 1 ? 15 : 12,
                                color: _courseCategory == 1 ? Color.fromRGBO(107, 43, 20, 1.0) : Color.fromRGBO(112, 112, 112, 1.0),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 6,
                              width: 20,
                              color: _courseCategory == 1 ? Color.fromRGBO(107, 43, 20, 1.0) : Colors.transparent,
                            )
                          ],
                        )
                        
                      ),
                      
                      MaterialButton(
                        minWidth: 10.0,
                        onPressed: () => setState(() {
                          _courseCategory = 2;
                          // _loadCourses();
                        }),
                        child: 
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Intermediate",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: _courseCategory == 2 ? 15 : 12,
                                color: _courseCategory == 2 ? Color.fromRGBO(107, 43, 20, 1.0) : Color.fromRGBO(112, 112, 112, 1.0),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 6,
                              width: 20,
                              color: _courseCategory == 2 ? Color.fromRGBO(107, 43, 20, 1.0) : Colors.transparent,
                            )
                          ],
                        )
                        
                      ),
                      
                      MaterialButton(
                        padding: EdgeInsets.all(0.0),
                        onPressed: () => setState(() {
                          _courseCategory = 3;
                          // _loadCourses();
                        }),
                        child: 
                        Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                  Text(
                                    "Advanced",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: _courseCategory == 3 ? 15 : 12,
                                      color: _courseCategory == 3 ? Color.fromRGBO(107, 43, 20, 1.0) : Color.fromRGBO(112, 112, 112, 1.0),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    height: 6,
                                    width: 20,
                                    color: _courseCategory == 3 ? Color.fromRGBO(107, 43, 20, 1.0) : Colors.transparent,
                                  )
                                
                              ],
                            )
                        
                      ),
                      
                    ]

                  ),
                ),
                
                _loadCourses(orientation)

              ]
          
            ),
          );
 
        }
      )
    );
  }

}

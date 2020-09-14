import 'package:flutter/material.dart';
import '../../services/app.dart';

class AllCoursesLessons extends StatefulWidget{

  AllCoursesLessons();

  @override
  AllCoursesLessonsState createState() => new AllCoursesLessonsState();
}

class Lessons
{
  // the properties on the class
  String thumbnail, tutor, title, description, lessons;
  // the constructor
  Lessons(this.thumbnail, this.tutor, this.title, this.description);

  // constructing from json
  Lessons.fromJson(Map <String, dynamic> json) {
    thumbnail = json['thumbnail'];
    tutor = json['tutor'];
    title = json['title'];
    description = json['description'];
  }
}

class AllCoursesLessonsState extends State<AllCoursesLessons>{

  // properties

  @override
  void initState() {
    super.initState();
  }

  
  final courseLessons = [
    new Lessons("assets/imgs/pictures/course_img_default.jpg", "Ebuka Odini", "Beginners Chords", "Learn how to play open chords from scratch."),
    new Lessons("assets/imgs/pictures/course_img_default.jpg", "Oc Omofuma", "G Chords", "Learn how to play G chords from scratch."),
    new Lessons("assets/imgs/pictures/course_img_default.jpg", "Samuel Kalu", "Bar Chords", "Learn how to play bar chords from scratch."),
    new Lessons("assets/imgs/pictures/course_img_default.jpg", "Lionel Lionel", "Strumming", "Learn how to strum strings easily."),
    new Lessons("assets/imgs/pictures/course_img_default.jpg", "Oc Omofuma", "G Chords", "Learn how to play G chords from scratch."),
    new Lessons("assets/imgs/pictures/course_img_default.jpg", "Samuel Kalu", "Bar Chords", "Learn how to play bar chords from scratch."),
    new Lessons("assets/imgs/pictures/course_img_default.jpg", "Lionel Lionel", "Strumming", "Learn how to strum strings easily."),
  ];

  Widget _loadLessons(orientation) {
    List <Widget> vids = new List<Widget>();
    int count = 0;
    courseLessons.forEach((lesson){
      count++;
      vids.add(
        new 
        Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Text(
                  count.toString() + ".", 
                  textAlign: TextAlign.left,
                  // overflow: TextOverflow.visible,
                  style: TextStyle(
                    color: Color.fromRGBO(112, 112, 112, 0.5),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[

                  Container(
                    width: orientation == Orientation.portrait ? 300 : 650,
                    child: Text(
                      lesson.title, 
                      // textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color.fromRGBO(107, 43, 20, 1.0),
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                  ),

                  Container(
                    margin: EdgeInsets.only(top: 3, bottom: 10),
                    child: Text(
                      lesson.tutor,
                      // textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color.fromRGBO(112, 112, 112, 0.5),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  Container(
                    width: orientation == Orientation.portrait ? 300 : 650,
                    child: Text(
                      lesson.description, 
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        color: Color.fromRGBO(112, 112, 112, 1.0),
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  
                ],
              )

            ],
          ),
        ),
      );

    });
      
    return new Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: vids);
  }

  @override
  Widget build(BuildContext context) {
    
    return new Scaffold(
      backgroundColor: Color.fromRGBO(243, 243, 243, 1.0),
      body: OrientationBuilder(
        
        builder: (context, orientation) {
          return 
          SafeArea(
            minimum: EdgeInsets.only(top: 20),
            child: SingleChildScrollView(
              child: 
              Column(
                children: <Widget>[

                  // back button
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(top: 20, left: 17, bottom: 30),
                    child: MaterialButton(
                      minWidth: 20,
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      onPressed: (){ Navigator.pop(context);},
                      child: new Icon(Icons.arrow_back_ios, color: Color.fromRGBO(107, 43, 20, 1.0), size: 20.0,),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(15.0),
                        side: BorderSide(color: Colors.white)
                      ),
                    ),
                    
                  ),

                  // course title and the number of lessons
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.all(Radius.circular(20)),
                      color: Color.fromRGBO(107, 43, 20, 1.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        
                        // Number of Lessons
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: new BorderRadius.all(Radius.circular(20)),
                            color: Color.fromRGBO(71, 29, 14, 1.0),
                          ),
                          child: Text(
                            "18",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            )
                          ),
                        ),

                        // Lesson Title
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            child: 
                            Text(
                              "Open Chords",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              )
                            ),
                          ),
                        )

                      ],
                    ),
                  ),

                  // the course list
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(top: 20, right: 15, left: 15),
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 35),
                    // height: orientation == Orientation.portrait ? MediaQuery.of(context).copyWith().size.height : 600,
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.only(topLeft: Radius.circular(45), topRight: Radius.circular(45)),
                      color: Colors.white,
                    ),

                    child: _loadLessons(orientation),

                  ),


                ],
              )
              
            )
          );
        }
      )
    );

  }

}
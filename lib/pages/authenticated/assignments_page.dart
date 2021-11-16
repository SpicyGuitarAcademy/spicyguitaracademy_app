import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:spicyguitaracademy_app/providers/Assignment.dart';
import 'package:spicyguitaracademy_app/providers/Courses.dart';
import 'package:spicyguitaracademy_app/providers/Lessons.dart';
import 'package:spicyguitaracademy_app/providers/StudentAssignments.dart';
import 'package:spicyguitaracademy_app/providers/StudentStudyStatistics.dart';
import 'package:spicyguitaracademy_app/providers/Tutorial.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';

class AssignmentsPage extends StatefulWidget {
  @override
  AssignmentsPageState createState() => new AssignmentsPageState();
}

class AssignmentsPageState extends State<AssignmentsPage> {
  @override
  void initState() {
    super.initState();
  }

  List<Widget> _loadAssignments(
      StudentAssignments studentAssignments, Courses courses) {
    List<Widget> assignments = [];
    Assignments.assignments!.forEach((Assignment assignment) {
      assignments.add(CupertinoButton(
        onPressed: () async {
          await studentAssignments.getAssignmentAnswers(courses, assignment);
          Navigator.pushNamed(
            context,
            '/assignment_page',
            arguments: {'assignment': assignment},
          );
        },
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, blurRadius: 10.0, spreadRadius: 2.0)
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                "Assignment ${assignment.assignmentNumber!}",
                overflow: TextOverflow.clip,
                style: TextStyle(
                  color: brown,
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              Text(
                Assignments.assignments!.length > 0
                    ? '${assignment.questions!.length} Assignment Questions'
                    : '${assignment.questions!.length} Assignment Question',
                overflow: TextOverflow.visible,
                style: TextStyle(
                  color: Color.fromRGBO(112, 112, 112, 1.0),
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 10),
              Text('Answer Ratings', style: TextStyle(color: brown)),
              Row(
                children: [
                  Icon(
                      assignment.rating! > 0
                          ? Icons.star
                          : Icons.star_border_outlined,
                      color: brown),
                  Icon(
                      assignment.rating! > 1
                          ? Icons.star
                          : Icons.star_border_outlined,
                      color: brown),
                  Icon(
                      assignment.rating! > 2
                          ? Icons.star
                          : Icons.star_border_outlined,
                      color: brown),
                  Icon(
                      assignment.rating! > 3
                          ? Icons.star
                          : Icons.star_border_outlined,
                      color: brown),
                  Icon(
                      assignment.rating! > 4
                          ? Icons.star
                          : Icons.star_border_outlined,
                      color: brown),
                ],
              )
            ],
          ),
        ),
      ));
    });
    return assignments;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentStudyStatistics>(
        builder: (BuildContext context, studentStats, child) {
      return Consumer<Courses>(builder: (BuildContext context, courses, child) {
        return Consumer<StudentAssignments>(
            builder: (BuildContext context, studentAssignments, child) {
          return Consumer<Lessons>(
              builder: (BuildContext context, lessons, child) {
            return Consumer<Tutorial>(
                builder: (BuildContext context, tutorial, child) {
              return Scaffold(
                appBar: AppBar(
                  toolbarHeight: 70,
                  title: Row(
                    children: [
                      Expanded(
                        child: Text("Assignments",
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
                        child: Text(
                          "${Assignments.assignments!.length}",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
                body: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: _loadAssignments(studentAssignments, courses),
                  ),
                ),
              );
            });
          });
        });
      });
    });
  }
}

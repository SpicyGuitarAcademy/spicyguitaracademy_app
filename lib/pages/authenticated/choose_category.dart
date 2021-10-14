import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spicyguitaracademy_app/providers/Student.dart';
import 'package:spicyguitaracademy_app/providers/StudentStudyStatistics.dart';
import 'package:spicyguitaracademy_app/providers/StudentSubscription.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';
import 'package:spicyguitaracademy_app/widgets/modals.dart';

class ChooseCategory extends StatefulWidget {
  @override
  ChooseCategoryState createState() => new ChooseCategoryState();
}

class ChooseCategoryState extends State<ChooseCategory> {
  // properties
  String? _selectedCategory = "";
  bool? canChooseAnotherCategory = false;

  @override
  void initState() {
    super.initState();
    initiatePage();
  }

  Future initiatePage() async {
    StudentStudyStatistics studentStats =
        context.read<StudentStudyStatistics>();
    StudentSubscription studentSubscription =
        context.read<StudentSubscription>();

    _selectedCategory = studentStats.studyingCategoryLabel;
    if (_selectedCategory != "" && studentSubscription.isSubscribed == true) {
      canChooseAnotherCategory =
          (studentStats.takenCourses! > 0 && studentStats.takenLessons! > 0) &&
              (studentStats.takenCourses == studentStats.allCourses &&
                  studentStats.takenLessons == studentStats.allLessons);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Student>(builder: (BuildContext context, student, child) {
      return Consumer<StudentSubscription>(
          builder: (BuildContext context, studentSubscription, child) {
        return Consumer<StudentStudyStatistics>(
            builder: (BuildContext context, studentStats, child) {
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 70,
              iconTheme: IconThemeData(color: brown),
              backgroundColor: grey,
              centerTitle: true,
              title: Text(
                'Choose a Category',
                style: TextStyle(
                    color: brown,
                    fontSize: 30,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.normal),
              ),
              elevation: 0,
            ),
            body: SingleChildScrollView(
                child: Column(children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.only(top: 60.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                    vertical: 20,
                                    horizontal: 30,
                                  ),
                                ),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                ),
                                side: MaterialStateProperty.all(
                                  BorderSide(
                                    color: brown,
                                    width: 2,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                  _selectedCategory == "Beginner"
                                      ? brown
                                      : Colors.white,
                                ),
                                foregroundColor: MaterialStateProperty.all(
                                  _selectedCategory == "Beginner"
                                      ? Colors.white
                                      : brown,
                                ),
                              ),
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 30.0),
                                child: Text("Beginner",
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600)),
                              ),
                              onPressed: () => studentStats.studyingCategory ==
                                          0 &&
                                      studentSubscription.isSubscribed == true
                                  ? setState(
                                      () => _selectedCategory = "Beginner")
                                  : canChooseAnotherCategory == true
                                      ? setState(
                                          () => _selectedCategory = "Beginner")
                                      : null,
                            ),
                          ),
                          Container(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                    vertical: 20,
                                    horizontal: 30,
                                  ),
                                ),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                ),
                                side: MaterialStateProperty.all(
                                  BorderSide(
                                    color: brown,
                                    width: 2,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                  _selectedCategory == "Amateur"
                                      ? brown
                                      : Colors.white,
                                ),
                                foregroundColor: MaterialStateProperty.all(
                                  _selectedCategory == "Amateur"
                                      ? Colors.white
                                      : brown,
                                ),
                              ),
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 30.0),
                                child: Text("Amateur",
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600)),
                              ),
                              onPressed: () => studentStats.studyingCategory ==
                                          0 &&
                                      studentSubscription.isSubscribed == true
                                  ? setState(
                                      () => _selectedCategory = "Amateur")
                                  : canChooseAnotherCategory == true
                                      ? setState(
                                          () => _selectedCategory = "Amateur")
                                      : null,
                            ),
                          )
                        ],
                      )),
                  SizedBox(height: 40),
                  Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 16,
                              ),
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                            ),
                            side: MaterialStateProperty.all(
                              BorderSide(
                                color: brown,
                                width: 2,
                                style: BorderStyle.solid,
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                              _selectedCategory == "Intermediate"
                                  ? brown
                                  : Colors.white,
                            ),
                            foregroundColor: MaterialStateProperty.all(
                              _selectedCategory == "Intermediate"
                                  ? Colors.white
                                  : brown,
                            ),
                          ),
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 30.0),
                            child: Text("Intermediate",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600)),
                          ),
                          onPressed: () => studentStats.studyingCategory == 0 &&
                                  studentSubscription.isSubscribed == true
                              ? setState(
                                  () => _selectedCategory = "Intermediate")
                              : canChooseAnotherCategory == true
                                  ? setState(
                                      () => _selectedCategory = "Intermediate")
                                  : null,
                        ),
                      ),
                      Container(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 25,
                              ),
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                            ),
                            side: MaterialStateProperty.all(
                              BorderSide(
                                color: brown,
                                width: 2,
                                style: BorderStyle.solid,
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                              _selectedCategory == "Advanced"
                                  ? brown
                                  : Colors.white,
                            ),
                            foregroundColor: MaterialStateProperty.all(
                              _selectedCategory == "Advanced"
                                  ? Colors.white
                                  : brown,
                            ),
                          ),
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 30.0),
                            child: Text("Advanced",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600)),
                          ),
                          onPressed: () => studentStats.studyingCategory == 0 &&
                                  studentSubscription.isSubscribed == true
                              ? setState(() => _selectedCategory = "Advanced")
                              : canChooseAnotherCategory == true
                                  ? setState(
                                      () => _selectedCategory = "Advanced")
                                  : null,
                        ),
                      )
                    ],
                  )),
                  (studentStats.studyingCategory == 0 ||
                              canChooseAnotherCategory == true) &&
                          studentSubscription.isSubscribed == true
                      ? Container(
                          margin:
                              const EdgeInsets.only(top: 100.0, bottom: 30.0),
                          width: screen(context).width * 0.8,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                              ),
                              side: MaterialStateProperty.all(
                                BorderSide(
                                  color: brown,
                                  width: 2,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                _selectedCategory == "" ? Colors.white : brown,
                              ),
                              foregroundColor: MaterialStateProperty.all(
                                _selectedCategory == "" ? brown : Colors.white,
                              ),
                            ),
                            onPressed: _selectedCategory == "" ||
                                    _selectedCategory ==
                                        studentStats.studyingCategoryLabel
                                ? null
                                : () async {
                                    try {
                                      String category = '0';
                                      switch (_selectedCategory) {
                                        case "Beginner":
                                          category = '1';
                                          break;
                                        case "Amateur":
                                          category = '2';
                                          break;
                                        case "Intermediate":
                                          category = '3';
                                          break;
                                        case "Advanced":
                                          category = '4';
                                          break;
                                        default:
                                          category = '1';
                                      }

                                      loading(context);
                                      if (studentStats.takenCourses == 0 &&
                                          studentStats.takenLessons == 0) {
                                        await studentStats.chooseCategory(
                                            studentSubscription, category);
                                      } else {
                                        await studentStats
                                            .rechooseCategory(category);
                                      }
                                      Navigator.pop(context);
                                      if (studentStats.studyingCategory == 0) {
                                        Navigator.popAndPushNamed(
                                            context, "/choose_category");
                                      } else {
                                        // if (Student.isLoaded == true) {
                                        if (canChooseAnotherCategory == true) {
                                          Navigator.popUntil(
                                              context,
                                              ModalRoute.withName(
                                                  '/dashboard'));
                                        } else {
                                          Navigator.popUntil(
                                              context,
                                              ModalRoute.withName(
                                                  '/welcome_note'));
                                          Navigator.pushNamed(
                                              context, '/ready_to_play');
                                        }
                                        // } else {
                                        //   Navigator.popAndPushNamed(
                                        //       context, '/ready_to_play');
                                        // }
                                      }
                                    } catch (e) {
                                      Navigator.pop(context);
                                      error(context, stripExceptions(e));
                                    }
                                  },
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(horizontal: 50),
                              child: Text("Done",
                                  style: TextStyle(fontSize: 20.0)),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ])),
          );
        });
      });
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:spicyguitaracademy_app/providers/Courses.dart';
import 'package:spicyguitaracademy_app/providers/StudentStudyStatistics.dart';
import 'package:spicyguitaracademy_app/providers/StudentSubscription.dart';
import 'package:spicyguitaracademy_app/providers/Ui.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';
import 'package:spicyguitaracademy_app/widgets/modals.dart';

class PreviousCategories extends StatefulWidget {
  @override
  PreviousCategoriesState createState() => new PreviousCategoriesState();
}

class PreviousCategoriesState extends State<PreviousCategories> {
  @override
  void initState() {
    super.initState();
  }

  List<Widget> renderPreviousCategories(StudentSubscription studentSubscription,
      Courses courses, StudentStudyStatistics studentStats, Ui ui) {
    List<Widget> categories = [];
    int count = 1;
    studentStats.previousCategories?.forEach((element) {
      if (studentStats.previousCategories?.last != element) {
        categories.add(
          Container(
            width: screen(context).width,
            child: ElevatedButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(grey),
                backgroundColor: MaterialStateProperty.all(white),
                foregroundColor: MaterialStateProperty.all(brown),
              ),
              onPressed: () async {
                try {
                  loading(context);
                  // save the old values

                  if (studentStats.viewingPreviousCourse == false) {
                    studentStats.originalStudyingCategory =
                        studentStats.studyingCategory;
                    studentStats.originalStudyingCategoryLabel =
                        studentStats.studyingCategoryLabel;
                  }

                  await studentStats
                      .getStudentCategoryAndStatsForPreviousCategories(
                          studentSubscription,
                          int.parse(element['category_id']));

                  await courses.getStudyingCoursesFromPreviousCategory(
                      int.parse(element['category_id']));

                  // update with the new value
                  studentStats.studyingCategory =
                      int.parse(element['category_id']);
                  studentStats.studyingCategoryLabel = element['categoryLabel'];

                  // indicate
                  studentStats.viewingPreviousCourse = true;
                  Navigator.popUntil(
                      context, ModalRoute.withName('/dashboard'));
                  ui.setDashboardPage(0);
                } catch (e) {
                  Navigator.pop(context);
                  error(context, stripExceptions(e));
                }
              },
              child: Text("$count. ${element['categoryLabel']} Category"),
            ),
          ),
        );
        categories.add(SizedBox(height: 10));
        count++;
      }
    });

    if (studentStats.viewingPreviousCourse == true) {
      categories.add(SizedBox(height: 20));
      categories.add(
        Container(
          width: screen(context).width,
          child: ElevatedButton(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(grey),
              backgroundColor: MaterialStateProperty.all(white),
              foregroundColor: MaterialStateProperty.all(brown),
            ),
            onPressed: () async {
              try {
                // update with the original values
                studentStats.studyingCategory =
                    studentStats.originalStudyingCategory;
                studentStats.studyingCategoryLabel =
                    studentStats.originalStudyingCategoryLabel;

                await studentStats
                    .getStudentCategoryAndStatsForPreviousCategories(
                        studentSubscription,
                        studentStats.originalStudyingCategory!);

                await courses.getStudyingCoursesFromPreviousCategory(
                    studentStats.originalStudyingCategory!);

                // indicate
                studentStats.viewingPreviousCourse = false;

                Navigator.popUntil(context, ModalRoute.withName('/dashboard'));
                ui.setDashboardPage(0);
              } catch (e) {
                Navigator.pop(context);
                error(context, stripExceptions(e));
              }
            },
            child: Text(
              "Return to ${studentStats.originalStudyingCategoryLabel} Category",
            ),
          ),
        ),
      );
      categories.add(SizedBox(height: 50));
    }

    return categories;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentSubscription>(
        builder: (BuildContext context, studentSubscription, child) {
      return Consumer<Courses>(builder: (BuildContext context, courses, child) {
        return Consumer<Ui>(builder: (BuildContext context, ui, child) {
          return Consumer<StudentStudyStatistics>(
              builder: (BuildContext context, studentStats, child) {
            return new Scaffold(
              appBar: AppBar(
                toolbarHeight: 70,
                iconTheme: IconThemeData(color: brown),
                backgroundColor: grey,
                centerTitle: true,
                title: Text(
                  'Previous Categories',
                  style: TextStyle(
                      color: brown,
                      fontSize: 30,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.normal),
                ),
                elevation: 0,
              ),
              body: SafeArea(
                minimum: EdgeInsets.all(5.0),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      ...renderPreviousCategories(
                          studentSubscription, courses, studentStats, ui)
                    ],
                  ),
                ),
              ),
            );
          });
        });
      });
    });
  }
}

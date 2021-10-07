import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spicyguitaracademy_app/providers/Student.dart';
import 'package:spicyguitaracademy_app/providers/StudentStudyStatistics.dart';
import 'package:spicyguitaracademy_app/providers/StudentSubscription.dart';
import 'package:spicyguitaracademy_app/providers/Subscription.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';

class WelcomeNotePage extends StatefulWidget {
  @override
  WelcomeNotePageState createState() => new WelcomeNotePageState();
}

class WelcomeNotePageState extends State<WelcomeNotePage> {
  @override
  void initState() {
    super.initState();
    initiatePage();
  }

  Future initiatePage() async {
    StudentSubscription studentSubscription =
        context.read<StudentSubscription>();
    StudentStudyStatistics studentStudyingStats =
        context.read<StudentStudyStatistics>();
    Subscription subscription = context.read<Subscription>();

    await studentSubscription.getStudentSubscriptionStatus();
    await studentStudyingStats.getStudentCategoryAndStats(studentSubscription);
    await subscription.getSubscriptionPlans();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Student>(builder: (BuildContext context, student, child) {
      return Consumer<StudentSubscription>(
          builder: (BuildContext context, studentSubscription, child) {
        return new Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
                minimum: EdgeInsets.all(5.0),
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 50.0),
                          Text(
                            "Hi, ${student.firstname}",
                            style: TextStyle(
                              color: brown,
                              fontSize: 40.0,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 30.0),
                          Container(
                            child: Text(
                              "You are welcome to Spicy Guitar Academy.",
                              style: TextStyle(
                                  color: brown,
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 30.0),
                            child: Text(
                              "Spicy Guitar Academy is aimed at guiding beginners to fulfill their dreams of becoming professional guitar players.\n\nWe have the best qualified tutors who are dedicated to help you develop from start to finish to make your dreams come true.",
                              style: TextStyle(
                                color: Color.fromRGBO(112, 112, 112, 1.0),
                                fontSize: 20.0,
                                // fontWeight: FontWeight.bold,
                              ),
                              strutStyle: StrutStyle(
                                fontSize: 20.0,
                                height: 1.6,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          SizedBox(height: 60),
                          Container(
                            alignment: Alignment.centerRight,
                            child: RaisedButton(
                                onPressed: () {
                                  if (studentSubscription.isSubscribed ==
                                      true) {
                                    Navigator.pushNamed(
                                        context, '/ready_to_play');
                                  } else {
                                    Navigator.pushNamed(
                                        context, '/choose_plan');
                                  }
                                },
                                color: brown,
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(15.0),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Text("Continue",
                                    style: TextStyle(fontSize: 20.0))),
                          ),
                          SizedBox(height: 50.0)
                        ]),
                  ),
                )));
      });
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:spicyguitaracademy_app/providers/Course.dart';
import 'package:spicyguitaracademy_app/providers/Courses.dart';
import 'package:spicyguitaracademy_app/providers/Student.dart';
import 'package:spicyguitaracademy_app/providers/StudentSubscription.dart';
import 'package:spicyguitaracademy_app/providers/Subscription.dart';
import 'package:spicyguitaracademy_app/providers/Ui.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';
import 'package:spicyguitaracademy_app/widgets/modals.dart';

class CompletePayment extends StatefulWidget {
  @override
  CompletePaymentState createState() => new CompletePaymentState();
}

class CompletePaymentState extends State<CompletePayment> {
  @override
  void initState() {
    super.initState();
  }

  String? _selectedPlan;
  Course? course;
  String? type;

  Future<void> initiateSubscriptionPayment(
      Student student,
      Subscription subscription,
      String medium,
      StudentSubscription studentSubscription) async {
    // medium = 'paystack' | 'paypal' | 'spicyunits'
    try {
      loading(context);

      // navigate to payment page based on medium
      if (medium == 'paystack') {
        await subscription.initiateSubscriptionPayment(
            _selectedPlan!, student, medium);
        Navigator.pop(context);
        Navigator.pushNamed(
          context,
          '/pay_with_paystack',
          arguments: {'type': 'featured-course', 'course': course},
        );
      } else if (medium == 'paypal') {
        await subscription.initiateSubscriptionPayment(
            _selectedPlan!, student, medium);
        Navigator.pop(context);
        Navigator.pushNamed(
          context,
          '/pay_with_paypal',
          arguments: {'type': 'featured-course', 'course': course},
        );
      } else if (medium == 'spicyunits') {
        var resp = await subscription.completeSubscriptionPaymentWithSpicyUnits(
            _selectedPlan!, student, studentSubscription);
        Navigator.pop(context);

        if (subscription.subscriptionPaymentStatus == true) {
          Navigator.popAndPushNamed(context, "/successful_transaction");
        } else {
          Navigator.pushNamed(context, "/failed_transaction");
          error(context, resp['message']);
        }
      }
    } catch (e) {
      Navigator.pop(context);
      error(context, stripExceptions(e));
    }
  }

  Future<void> initiateFeaturedCoursePayment(Student student,
      Subscription subscription, String medium, Courses courses, Ui ui) async {
    // medium = 'paystack' | 'paypal' | 'spicyunits'
    try {
      loading(context);

      // navigate to payment page based on medium
      if (medium == 'paystack') {
        await subscription.initiateFeaturedPayment(course!, student, medium);
        Navigator.pop(context);

        Navigator.pushNamed(
          context,
          '/pay_with_paystack',
          arguments: {'type': 'featured-course', 'course': course},
        );
      } else if (medium == 'paypal') {
        await subscription.initiateFeaturedPayment(course!, student, medium);
        Navigator.pop(context);

        Navigator.pushNamed(
          context,
          '/pay_with_paypal',
          arguments: {'type': 'featured-course', 'course': course},
        );
      } else if (medium == 'spicyunits') {
        var resp = await subscription.completeFeaturedPaymentWithSpicyUnits(
            course!, student, courses);
        Navigator.pop(context);

        if (subscription.featuredPaymentStatus == true) {
          courses.featuredCourses
              .firstWhere((element) => element.id == course!.id)
              .status = true;
          Navigator.popUntil(context, ModalRoute.withName('/dashboard'));
          ui.setDashboardPage(2);
          ui.setFeaturedCoursesPage(0);
          success(context, resp['message']);
        } else {
          Navigator.popUntil(
              context, ModalRoute.withName('/coursepreview_page'));
          error(context, resp['message']);
        }
      }
    } catch (e) {
      Navigator.pop(context);
      error(context, stripExceptions(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    var map = getRouteArgs(context);
    type = map['type'];
    if (type == 'subscription') {
      _selectedPlan = map['plan'];
    } else if (type == 'featured-course') {
      course = map['course'];
    }

    return Consumer<Ui>(builder: (BuildContext context, ui, child) {
      return Consumer<Student>(builder: (BuildContext context, student, child) {
        return Consumer<Courses>(
            builder: (BuildContext context, courses, child) {
          return Consumer<Subscription>(
              builder: (BuildContext context, subscription, child) {
            return Consumer<StudentSubscription>(
                builder: (BuildContext context, studentSubscription, child) {
              return new Scaffold(
                appBar: AppBar(
                  toolbarHeight: 70,
                  iconTheme: IconThemeData(color: brown),
                  backgroundColor: grey,
                  centerTitle: true,
                  title: Text(
                    'Complete Payment',
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
                        SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {
                            if (type == 'subscription') {
                              initiateSubscriptionPayment(student, subscription,
                                  'paystack', studentSubscription);
                            } else if (type == 'featured-course') {
                              initiateFeaturedCoursePayment(student,
                                  subscription, 'paystack', courses, ui);
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(white),
                            overlayColor: MaterialStateProperty.all(darkgrey),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            width: screen(context).width,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              image: DecorationImage(
                                image: AssetImage(
                                    "assets/imgs/icons/pay_with_paystack.png"),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            if (type == 'subscription') {
                              initiateSubscriptionPayment(student, subscription,
                                  'paypal', studentSubscription);
                            } else if (type == 'featured-course') {
                              initiateFeaturedCoursePayment(
                                  student, subscription, 'paypal', courses, ui);
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(white),
                            overlayColor: MaterialStateProperty.all(darkgrey),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            width: screen(context).width,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              image: DecorationImage(
                                image: AssetImage(
                                    "assets/imgs/icons/pay_with_paypal.png"),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            if (type == 'subscription') {
                              initiateSubscriptionPayment(student, subscription,
                                  'spicyunits', studentSubscription);
                            } else if (type == 'featured-course') {
                              initiateFeaturedCoursePayment(student,
                                  subscription, 'spicyunits', courses, ui);
                            }
                          },
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                vertical: 9,
                                horizontal: 25,
                              ),
                            ),
                            overlayColor: MaterialStateProperty.all(darkgrey),
                            backgroundColor: MaterialStateProperty.all(white),
                            foregroundColor: MaterialStateProperty.all(brown),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SvgPicture.asset(
                                "assets/imgs/icons/spicyunit.svg",
                                width: 30,
                                matchTextDirection: true,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "SPICY UNITS - ${student.referralUnits}",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40),
                      ],
                    ),
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

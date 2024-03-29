import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:spicyguitaracademy_app/providers/Course.dart';
import 'package:spicyguitaracademy_app/providers/Courses.dart';
import 'package:spicyguitaracademy_app/providers/Student.dart';
import 'package:spicyguitaracademy_app/providers/StudentSubscription.dart';
import 'package:spicyguitaracademy_app/providers/Subscription.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';
import 'package:spicyguitaracademy_app/widgets/custom_video_player.dart';
import 'package:spicyguitaracademy_app/widgets/modals.dart';

class CoursePreviewPage extends StatefulWidget {
  CoursePreviewPage();

  @override
  CoursePreviewPageState createState() => new CoursePreviewPageState();
}

// enum Screen { video, audio, practice, tablature, none }

class CoursePreviewPageState extends State<CoursePreviewPage> {
  Course? course;

  @override
  void initState() {
    super.initState();
  }

  Future initiatePage() async {}

  Widget renderDisplayScreen() {
    return Container(
        height: (screen(context).width * 2) / 3,
        width: screen(context).width,
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: NetworkImage(
                Uri.parse('$baseUrl/${course!.thumbnail}').toString(),
                headers: {'cache-control': 'max-age=0, must-revalidate'}),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: VideoWidget(
          play: true,
          url: "$baseUrl/${course!.preview}",
        ));
  }

  @override
  Widget build(BuildContext context) {
    final Map args = getRouteArgs(context);
    course = args['course'];

    return Consumer<Student>(builder: (BuildContext context, student, child) {
      return Consumer<Courses>(builder: (BuildContext context, courses, child) {
        return Consumer<Subscription>(
            builder: (BuildContext context, subscription, child) {
          return Consumer<StudentSubscription>(
              builder: (BuildContext context, studentSubscription, child) {
            return SafeArea(
              top: true,
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: PreferredSize(
                  preferredSize:
                      Size.fromHeight((screen(context).width * 2) / 3),
                  child: renderDisplayScreen(),
                ),
                body: Column(children: [
                  Expanded(
                    child: SingleChildScrollView(
                        child: Column(children: <Widget>[
                      Container(
                          width: screen(context).width,
                          padding: EdgeInsets.symmetric(horizontal: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // The text contents
                              Text(
                                course!.title!,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.clip,
                                maxLines: 3,
                                style: TextStyle(
                                  color: brown,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                course!.tutor!,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: darkgrey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "${course!.description}",
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                  color: darkgrey,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "N${course!.featuredprice}",
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                      color: darkgrey,
                                      fontSize: 25,
                                    ),
                                  ),
                                  Text(
                                    "${course!.allLessons} lessons",
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                      color: darkgrey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 20),

                              ElevatedButton(
                                onPressed: () async {
                                  try {
                                    loading(context);
                                    await subscription.initiateFeaturedPayment(
                                        course!, student, 'paystack');
                                    Navigator.pop(context);

                                    // complete payment with paystack
                                    Navigator.pushNamed(
                                      context,
                                      '/pay_with_paystack',
                                      arguments: {
                                        'type': 'featured-course',
                                        'course': course
                                      },
                                    );
                                  } catch (e) {
                                    Navigator.pop(context);
                                    error(context, stripExceptions(e));
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.credit_card),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text('Buy with Paystack'),
                                  ],
                                ),
                              ),

                              SizedBox(height: 15),

                              ElevatedButton(
                                onPressed: () async {
                                  try {
                                    loading(context);
                                    await subscription.initiateFeaturedPayment(
                                        course!, student, 'paypal');
                                    Navigator.pop(context);

                                    // complete payment with paystack
                                    Navigator.pushNamed(
                                      context,
                                      '/pay_with_paypal',
                                      arguments: {
                                        'type': 'featured-course',
                                        'course': course
                                      },
                                    );
                                  } catch (e) {
                                    Navigator.pop(context);
                                    error(context, stripExceptions(e));
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(CupertinoIcons.money_dollar),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text('Buy with PayPal')
                                  ],
                                ),
                              ),

                              SizedBox(height: 20),
                            ],
                          )),
                    ])),
                  ),
                ]),
                // bottomSheet: BottomAppBar(
                //   child: Container(
                //       width: screen(context).width,
                //       child: Row(
                //         children: [
                //           ],
                //       )),
                // ),
              ),
            );
          });
        });
      });
    });
  }
}

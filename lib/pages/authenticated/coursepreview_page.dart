import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_svg/svg.dart';
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
  CheckoutMethod _method = CheckoutMethod.selectable;
  Course? course;

  PaystackPlugin _paystackPlugin = new PaystackPlugin();

  @override
  void initState() {
    // _paystackPlugin.initialize(publicKey: paystackPublicKey!);
    super.initState();
  }

  Future initiatePage() async {
    Subscription subscription = context.read<Subscription>();

    await subscription.getPaymentKey();
    _paystackPlugin.initialize(publicKey: subscription.paystackPublicKey!);
  }

  PaymentCard _getCardFromUI() {
    return PaymentCard(
      number: '',
      cvc: '',
      expiryMonth: 0,
      expiryYear: 0,
    );
  }

  _handleCheckout(
      BuildContext context,
      Student student,
      Courses courses,
      Subscription subscription,
      StudentSubscription studentSubscription) async {
    Charge charge = Charge()
      ..amount = subscription.price! // In base currency
      ..email = student.email
      ..card = _getCardFromUI();

    charge.accessCode = subscription.accessCode;

    try {
      CheckoutResponse response = await _paystackPlugin.checkout(
        context,
        method: _method,
        charge: charge,
        fullscreen: true,
        logo: SvgPicture.asset(
          "assets/imgs/icons/spicy_guitar_logo.svg",
          width: 40.0,
          matchTextDirection: true,
        ),
      );

      if (response.verify == true) {
        loading(context, message: 'Verifying payment');
        await subscription.verifyFeaturedPayment(courses).then((value) async {
          Navigator.pop(context);
          if (subscription.featuredPaymentStatus == true) {
            // update my featured courses
            await courses.getBoughtCourses();
            courses.featuredCourses
                .firstWhere((element) => element.id == course!.id)
                .status = true;
            Navigator.popUntil(context, ModalRoute.withName('/ready_to_play'));
            Navigator.pushReplacementNamed(context, '/dashboard');
            success(context, 'Payment verified.');
          } else {
            snackbar(context, 'Payment verification failed');
            Navigator.popUntil(context, ModalRoute.withName('/dashboard'));
          }
        });
      } else {
        throw Exception('Cancelled Transaction');
      }
    } catch (e) {
      error(context, stripExceptions(e));
    }
  }

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

                              SizedBox(height: 100),
                            ],
                          )),
                    ])),
                  ),
                ]),
                bottomSheet: BottomAppBar(
                  child: Container(
                    width: screen(context).width,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: new BorderRadius.all(Radius.zero),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        try {
                          loading(context);
                          await subscription.initiateFeaturedPayment(
                              course!, student);
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
                          Text('BUY COURSE'),
                          SizedBox(
                            width: 15,
                          ),
                          Icon(Icons.arrow_forward)
                        ],
                      ),
                    ),
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

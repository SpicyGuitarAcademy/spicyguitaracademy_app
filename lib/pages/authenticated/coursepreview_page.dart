import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spicyguitaracademy/pages/authenticated/featured_courses_page.dart';
import 'package:spicyguitaracademy/pages/authenticated/videoWidget.dart';
import 'package:spicyguitaracademy/common.dart';
import 'package:spicyguitaracademy/models.dart';

class CoursePreviewPage extends StatefulWidget {
  CoursePreviewPage();

  @override
  CoursePreviewPageState createState() => new CoursePreviewPageState();
}

// enum Screen { video, audio, practice, tablature, none }

class CoursePreviewPageState extends State<CoursePreviewPage> {
  CheckoutMethod _method = CheckoutMethod.selectable;
  Course course;

  PaystackPlugin _paystackPlugin = new PaystackPlugin();

  @override
  void initState() {
    _paystackPlugin.initialize(publicKey: paystackPublicKey);
    super.initState();
  }

  PaymentCard _getCardFromUI() {
    return PaymentCard(
      number: '',
      cvc: '',
      expiryMonth: 0,
      expiryYear: 0,
    );
  }

  _handleCheckout(BuildContext context) async {
    Charge charge = Charge()
      ..amount = Subscription.price // In base currency
      ..email = Student.email
      ..card = _getCardFromUI();

    charge.accessCode = Subscription.accessCode;

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
        await Subscription.verifyFeatured().then((value) async {
          Navigator.pop(context);
          if (Subscription.featuredpaystatus == true) {
            // update my featured courses
            await Courses.getMyFeaturedCourses(context);
            featuredCourses
                .firstWhere((element) => element.id == course.id)
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
                Uri.parse('$baseUrl/${course.thumbnail}').toString(),
                headers: {'cache-control': 'max-age=0, must-revalidate'}),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: VideoWidget(
          play: true,
          url: "$baseUrl/${course.preview}",
        ));
  }

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments as Map;
    course = args['course'];
    return SafeArea(
        top: true,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight((screen(context).width * 2) / 3),
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
                          course.title,
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
                          course.tutor,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: darkgrey,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "${course.description}",
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                            color: darkgrey,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "N${course.featuredprice}",
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                color: darkgrey,
                                fontSize: 25,
                              ),
                            ),
                            Text(
                              "${course.allLessons} lessons",
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
                  child: RaisedButton(
                      onPressed: () async {
                        try {
                          loading(context);
                          await Subscription.initiateFeaturedPayment(course.id);
                          Navigator.pop(context);
                          await _handleCheckout(context);
                        } catch (e) {
                          Navigator.pop(context);
                          error(context, stripExceptions(e));
                        }
                      },
                      textColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'BUY COURSE',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Icon(Icons.arrow_forward)
                        ],
                      )))),
        ));
  }
}

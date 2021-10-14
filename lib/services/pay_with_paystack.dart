import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spicyguitaracademy_app/providers/Course.dart';
import 'package:spicyguitaracademy_app/providers/Courses.dart';
import 'package:spicyguitaracademy_app/providers/StudentSubscription.dart';
import 'package:spicyguitaracademy_app/providers/Subscription.dart';
import 'package:spicyguitaracademy_app/providers/Ui.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';
import 'package:spicyguitaracademy_app/widgets/modals.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayWithPaystack extends StatefulWidget {
  const PayWithPaystack({Key? key}) : super(key: key);

  @override
  _PayWithPaystackState createState() => _PayWithPaystackState();
}

class _PayWithPaystackState extends State<PayWithPaystack> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  Future verifySubscriptionPayment(Subscription subscription,
      StudentSubscription studentSubscription) async {
    try {
      loading(context, message: 'Verifying payment');
      await subscription.verifySubscriptionPayment(
          studentSubscription, 'paystack');
      Navigator.pop(context);
      if (subscription.subscriptionPaymentStatus == true) {
        Navigator.popAndPushNamed(context, "/successful_transaction");
      } else {
        Navigator.pushNamed(context, "/failed_transaction");
      }
    } catch (e) {
      Navigator.pop(context);
      Navigator.pop(context);
      error(context, stripExceptions(e));
    }
  }

  Future verifyFeaturedPayment(
      Subscription subscription, Courses courses, Ui ui) async {
    try {
      loading(context, message: 'Verifying payment');
      await subscription
          .verifyFeaturedPayment(courses, 'paystack')
          .then((value) async {
        Navigator.pop(context);
        if (subscription.featuredPaymentStatus == true) {
          // update my featured courses
          await courses.getBoughtCourses();
          courses.featuredCourses
              .firstWhere((element) => element.id == course!.id)
              .status = true;
          Navigator.popUntil(context, ModalRoute.withName('/dashboard'));
          ui.setDashboardPage(0);
          success(context, 'Payment verified.');
        } else {
          snackbar(context, 'Payment verification failed');
          Navigator.popUntil(context, ModalRoute.withName('/dashboard'));
        }
      });
    } catch (e) {
      Navigator.pop(context);
      Navigator.pop(context);
      error(context, stripExceptions(e));
    }
  }

  Course? course;
  String? type;

  @override
  Widget build(BuildContext context) {
    final Map args = getRouteArgs(context);
    type = args['type'];
    course = args['course'];

    return Consumer<Ui>(builder: (BuildContext context, ui, child) {
      return Consumer<StudentSubscription>(
          builder: (BuildContext context, studentSubscription, child) {
        return Consumer<Subscription>(
            builder: (BuildContext context, subscription, child) {
          return Consumer<Courses>(
              builder: (BuildContext context, courses, child) {
            return SafeArea(
              top: true,
              child: WebView(
                initialUrl: subscription.authorizationUrl,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
                onProgress: (int progress) {
                  print("WebView is loading (progress : $progress%)");
                },
                javascriptChannels: <JavascriptChannel>{
                  _toasterJavascriptChannel(context),
                },
                navigationDelegate: (NavigationRequest request) async {
                  if (request.url.startsWith(
                      baseUrl + '/api/subscription/paystack/verify')) {
                    print('verifying payment...');

                    if (type == 'subscription') {
                      await verifySubscriptionPayment(
                          subscription, studentSubscription);
                    } else if (type == 'featured-course') {
                      await verifyFeaturedPayment(subscription, courses, ui);
                    }

                    return NavigationDecision.prevent;
                  }
                  print('allowing navigation to $request');
                  return NavigationDecision.navigate;
                },
                onPageStarted: (String url) {
                  print('Page started loading: $url');
                },
                onPageFinished: (String url) {
                  print('Page finished loading: $url');
                },
                gestureNavigationEnabled: true,
              ),
            );
          });
        });
      });
    });
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}

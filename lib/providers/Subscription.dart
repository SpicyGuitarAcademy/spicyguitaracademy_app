import 'package:flutter/foundation.dart';
import 'package:spicyguitaracademy_app/providers/Auth.dart';
import 'package:spicyguitaracademy_app/providers/Course.dart';
import 'package:spicyguitaracademy_app/providers/Courses.dart';
import 'package:spicyguitaracademy_app/providers/Student.dart';
import 'package:spicyguitaracademy_app/providers/StudentSubscription.dart';
import 'package:spicyguitaracademy_app/utils/request.dart';

class Subscription extends ChangeNotifier {
  String? reference;
  String? paypalPaymentID;
  String? authorizationUrl;

  bool? subscriptionPaymentStatus;
  bool? featuredPaymentStatus;

  List<dynamic>? plans;

  Future getSubscriptionPlans() async {
    try {
      var resp = await request('/api/subscription/plans',
          method: 'GET',
          headers: {
            'JWToken': Auth.token!,
            'cache-control': 'max-age=0, must-revalidate'
          });
      plans = resp['data'];

      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  Future completeSubscriptionPaymentWithSpicyUnits(String selectedPlan,
      Student student, StudentSubscription studentSubscription) async {
    try {
      var resp = await request(
        '/api/subscription/spicyunits/complete-subscription',
        method: 'POST',
        body: {'email': student.email, 'plan': selectedPlan},
        headers: {
          'JWToken': Auth.token!,
          'cache-control': 'max-age=0, must-revalidate'
        },
      );

      if (resp['status'] == true) {
        subscriptionPaymentStatus = true;

        // update spicy units
        await student.getProfile();

        // get subscription status again
        await studentSubscription.getStudentSubscriptionStatus();
      } else {
        subscriptionPaymentStatus = false;
      }

      notifyListeners();

      return resp;
    } catch (e) {
      throw (e);
    }
  }

  Future completeFeaturedPaymentWithSpicyUnits(
      Course course, Student student, Courses courses) async {
    try {
      var resp = await request(
        '/api/subscription/spicyunits/complete-featured',
        method: 'POST',
        body: {'email': student.email, 'course': course.id.toString()},
        headers: {
          'JWToken': Auth.token!,
          'cache-control': 'max-age=0, must-revalidate'
        },
      );

      if (resp['status'] == true) {
        featuredPaymentStatus = true;

        // update spicy units
        await student.getProfile();

        // get bought courses again
        courses.getBoughtCourses();
      } else {
        featuredPaymentStatus = false;
      }

      return resp;
    } catch (e) {
      throw (e);
    }
  }

  Future initiateFeaturedPayment(
      Course course, Student student, String medium) async {
    try {
      var resp = await request(
        '/api/subscription/$medium/initiate-featured',
        method: 'POST',
        body: {'email': student.email, 'course': course.id.toString()},
        // continue with the server side and
        headers: {
          'JWToken': Auth.token!,
          'cache-control': 'max-age=0, must-revalidate'
        },
      );

      if (resp['status'] == true) {
        reference = resp['data']['reference'];
        authorizationUrl = resp['data']['authorization_url'];
        if (medium == 'paypal') paypalPaymentID = resp['data']['id'];
      } else {
        throw Exception(resp['message']);
      }

      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  Future initiateSubscriptionPayment(
      String selectedPlan, Student student, String medium) async {
    try {
      var resp = await request(
        '/api/subscription/$medium/initiate',
        method: 'POST',
        body: {'email': student.email, 'plan': selectedPlan},
        headers: {
          'JWToken': Auth.token!,
          'cache-control': 'max-age=0, must-revalidate'
        },
      );

      if (resp['status'] == true) {
        reference = resp['data']['reference'];
        authorizationUrl = resp['data']['authorization_url'];
        if (medium == 'paypal') paypalPaymentID = resp['data']['id'];
      } else {
        throw Exception(resp['message']);
      }

      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  Future verifySubscriptionPayment(
      StudentSubscription studentSubscription, String medium) async {
    try {
      var endpoint = medium == 'paypal'
          ? '/api/subscription/$medium/verify/$reference?paymentID=$paypalPaymentID'
          : '/api/subscription/$medium/verify/$reference';
      var resp = await request(
        endpoint,
        method: 'POST',
        headers: {
          'JWToken': Auth.token!,
          'cache-control': 'max-age=0, must-revalidate'
        },
      );

      if (resp['status'] == true) {
        subscriptionPaymentStatus = true;

        // get subscription status again
        await studentSubscription.getStudentSubscriptionStatus();
      } else {
        subscriptionPaymentStatus = false;
      }

      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  Future verifyFeaturedPayment(Courses courses, String medium) async {
    try {
      var endpoint = medium == 'paypal'
          ? '/api/subscription/$medium/verify-featured/$reference?paymentID=$paypalPaymentID'
          : '/api/subscription/$medium/verify-featured/$reference';
      var resp = await request(
        endpoint,
        method: 'POST',
        headers: {
          'JWToken': Auth.token!,
          'cache-control': 'max-age=0, must-revalidate'
        },
      );

      if (resp['status'] == true) {
        featuredPaymentStatus = true;

        // get bought courses again
        courses.getBoughtCourses();
      } else {
        featuredPaymentStatus = false;
      }

      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }
}

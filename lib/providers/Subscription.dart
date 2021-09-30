import 'package:flutter/foundation.dart';
import 'package:spicyguitaracademy_app/providers/Auth.dart';
import 'package:spicyguitaracademy_app/providers/Course.dart';
import 'package:spicyguitaracademy_app/providers/Courses.dart';
import 'package:spicyguitaracademy_app/providers/Student.dart';
import 'package:spicyguitaracademy_app/providers/StudentSubscription.dart';
import 'package:spicyguitaracademy_app/utils/request.dart';

class Subscription extends ChangeNotifier {
  String? paystackPublicKey;
  String? reference;
  String? accessCode;
  int? price;

  bool? subscriptionPaymentStatus;
  bool? featuredPaymentStatus;

  List<dynamic>? plans;

  getPaymentKey() async {
    try {
      dynamic resp = await request('/api/paystack/key');
      if (resp['status'] == true) {
        paystackPublicKey = resp['data']['key'];
      }

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

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

  Future initiateFeaturedPayment(Course course, Student student) async {
    try {
      var resp = await request(
        '/api/subscription/initiate-featured',
        method: 'POST',
        body: {'email': student.email, 'course': course.id.toString()},
        // continue with the server side and
        headers: {
          'JWToken': Auth.token!,
          'cache-control': 'max-age=0, must-revalidate'
        },
      );

      // Navigator.pushNamedAndRemoveUntil(context,'/login', (route) => false);
      if (resp['status'] == true) {
        reference = resp['data']['reference'];
        accessCode = resp['data']['access_code'];
        price = resp['data']['price'];
      } else {
        throw Exception(resp['message']);
      }

      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  Future initiateSubscriptionPayment(
      String selectedPlan, Student student) async {
    try {
      var resp = await request(
        '/api/subscription/initiate',
        method: 'POST',
        body: {'email': student.email, 'plan': selectedPlan},
        headers: {
          'JWToken': Auth.token!,
          'cache-control': 'max-age=0, must-revalidate'
        },
      );

      if (resp['status'] == true) {
        reference = resp['data']['reference'];
        accessCode = resp['data']['access_code'];
        price = resp['data']['price'];
      } else {
        throw Exception(resp['message']);
      }

      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  Future verifySubscriptionPayment(
      Student student, StudentSubscription studentSubscription) async {
    try {
      var resp = await request('/api/subscription/verify/$reference',
          method: 'POST',
          headers: {
            'JWToken': Auth.token!,
            'cache-control': 'max-age=0, must-revalidate'
          },
          body: {
            'email': student.email
          });

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

  Future verifyFeaturedPayment(Student student, Courses courses) async {
    try {
      var resp = await request('/api/subscription/verify-featured/$reference',
          method: 'POST',
          headers: {
            'JWToken': Auth.token!,
            'cache-control': 'max-age=0, must-revalidate'
          },
          body: {
            'email': student.email
          });

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

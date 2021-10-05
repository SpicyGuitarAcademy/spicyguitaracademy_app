import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spicyguitaracademy_app/providers/Auth.dart';
import 'package:spicyguitaracademy_app/utils/request.dart';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class Student extends ChangeNotifier {
  String? id;
  String? firstname;
  String? lastname;
  String? email;
  String? telephone;
  String? avatar;
  String? status;
  bool? isNewStudent; // to indicate if the student is a new student
  bool?
      hasForgottenPassword; // to indicate if the student forgot his/her password

  Future signin(String _email, String _password) async {
    try {
      var resp = await request(
        '/api/login',
        method: 'POST',
        body: {'email': _email, 'password': _password},
      );

      if (resp['status'] == true) {
        Map<String, dynamic> student = resp['data']['student'];

        Auth.authenticated = true;
        Auth.token = resp['data']['token'];

        id = student['id'];
        firstname = student['firstname'];
        lastname = student['lastname'];
        email = student['email'];
        telephone = student['telephone'];
        avatar = student['avatar'];
        status = student['status'];

        isNewStudent = false;
        hasForgottenPassword = false;

        await cacheSigninData();

        // // load subscription plans
        // await Subscription.getSubscriptionPlans();

        // // get student subscription status, days remaining and subscription plan
        // await getSubscriptionStatus();

        // // get the current category and stats
        // await getStudentCategoryAndStats();

        notifyListeners();
      } else {
        throw Exception(resp['message']);
      }
    } catch (e) {
      throw (e);
    }
  }

  Future verifyEmail(String _token) async {
    try {
      var resp = await request(
        '/api/verify',
        method: 'POST',
        body: {'token': _token, 'email': email},
      );

      if (resp['status'] == true) {
        status = 'active';
        await cacheSigninData();
      }

      notifyListeners();

      return resp;
    } catch (e) {
      throw (e);
    }
  }

  Future verifyDevice() async {
    try {
      dynamic deviceInfo;
      var resp = await request('/api/verify-device', method: 'POST', body: {
        'device': deviceInfo
      }, headers: {
        'JWToken': Auth.token!,
        'cache-control': 'max-age=0, must-revalidate'
      });

      return resp;
    } catch (e) {
      throw (e);
    }
  }

  Future resetDevice(String _token) async {
    try {
      dynamic deviceInfo;
      var resp = await request('/api/reset-device', method: 'POST', body: {
        'token': _token,
        'device': deviceInfo
      }, headers: {
        'JWToken': Auth.token!,
        'cache-control': 'max-age=0, must-revalidate'
      });

      return resp['status'];
    } catch (e) {
      throw (e);
    }
  }

  Future resetPassword(String _pass, String _cpass) async {
    var resp = await request(
      '/api/resetpassword',
      method: 'POST',
      body: {
        'email': email,
        'password': _pass,
        'cpassword': _cpass,
      },
    );

    return resp;
  }

  Future forgotPassword(String _email) async {
    var resp = await request('/api/forgotpassword',
        method: 'POST', body: {'email': _email});

    hasForgottenPassword = true;

    if (resp['status'] == true) {
      email = _email;
      await cacheSigninData();
    }

    notifyListeners();

    return resp;
  }

  Future signout() async {
    Auth.token = null;
    Auth.authenticated = false;

    id = null;
    firstname = null;
    lastname = null;
    email = null;
    telephone = null;
    avatar = null;
    status = null;
    isNewStudent = null;
    hasForgottenPassword = null;

    await clearSigninCache();

    notifyListeners();
  }

  Future signinWithCachedData({bool? handleClick = false}) async {
    try {
      final SharedPreferences prefs = await _prefs;

      Auth.authenticated = prefs.getBool('authenticated') ?? false;

      if (Auth.authenticated == true) {
        id = prefs.getString('id');
        firstname = prefs.getString('firstname');
        lastname = prefs.getString('lastname');
        email = prefs.getString('email');
        telephone = prefs.getString('telephone');
        avatar = prefs.getString('avatar');
        status = prefs.getString('status');

        Auth.token = prefs.getString('token');

        isNewStudent = false;
        hasForgottenPassword = false;

        notifyListeners();
      }
    } catch (e) {
      throw (e);
    }
  }

  Future cacheSigninData() async {
    // store user data in sharedpreference
    final SharedPreferences prefs = await _prefs;
    prefs.setString('id', id!);
    prefs.setString('firstname', firstname!);
    prefs.setString('lastname', lastname!);
    prefs.setString('email', email!);
    prefs.setString('telephone', telephone!);
    prefs.setString('avatar', avatar!);
    prefs.setString('status', status!);
    prefs.setString('token', Auth.token!);
    prefs.setBool('authenticated', Auth.authenticated!);
  }

  Future clearSigninCache() async {
    // remove the student data from sharedpreference
    final SharedPreferences prefs = await _prefs;
    prefs.remove('firstname');
    prefs.remove('lastname');
    prefs.remove('email');
    prefs.remove('telephone');
    prefs.remove('avatar');
    prefs.remove('status');
    prefs.remove('token');
    prefs.setBool('authenticated', false);
  }
}

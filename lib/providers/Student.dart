import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spicyguitaracademy_app/providers/Auth.dart';
import 'package:spicyguitaracademy_app/services/device_info.dart';
import 'package:spicyguitaracademy_app/utils/request.dart';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class Student extends ChangeNotifier {
  String? id;
  String? firstname;
  String? lastname;
  String? email;
  String? telephone;
  String? avatar;
  String? referralCode;
  int? referralUnits;
  String? status;
  bool? isNewStudent; // to indicate if the student is a new student
  bool?
      hasForgottenPassword; // to indicate if the student forgot his/her password

  Future signup(
      String _firstname,
      String _lastname,
      String _email,
      String _telephone,
      String _password,
      String _cpassword,
      String _referralCode) async {
    try {
      var resp = await request(
        '/api/register_student',
        method: 'POST',
        body: {
          'firstname': _firstname,
          'lastname': _lastname,
          'email': _email,
          'telephone': _telephone,
          'password': _password,
          'cpassword': _cpassword,
          'referral_code': _referralCode
        },
      );

      id = '';
      firstname = _firstname;
      lastname = _lastname;
      email = _email;
      telephone = _telephone;
      avatar = '';
      referralCode = '';
      referralUnits = 0;
      status = 'inactive';
      isNewStudent = true;

      notifyListeners();

      return resp;
    } catch (e) {
      throw (e);
    }
  }

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
        referralCode = student['referral_code'] ?? '';
        referralUnits = int.parse(student['referral_units']);
        status = student['status'];

        isNewStudent = false;
        hasForgottenPassword = false;

        final SharedPreferences prefs = await _prefs;
        prefs.setString('id', id!);
        prefs.setString('firstname', firstname!);
        prefs.setString('lastname', lastname!);
        prefs.setString('email', email!);
        prefs.setString('telephone', telephone!);
        prefs.setString('avatar', avatar!);
        prefs.setString('referralCode', referralCode!);
        prefs.setInt('referralUnits', referralUnits!);
        prefs.setString('status', status!);
        prefs.setString('token', Auth.token!);
        prefs.setBool('authenticated', Auth.authenticated!);

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
        final SharedPreferences prefs = await _prefs;
        prefs.setString('status', status!);
      }

      notifyListeners();

      return resp;
    } catch (e) {
      throw (e);
    }
  }

  Future verifyDevice() async {
    try {
      dynamic deviceInfo = await getDeviceInfo();
      var resp = await request('/api/device/verify', method: 'POST', body: {
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
      dynamic deviceInfo = await getDeviceInfo();
      var resp = await request('/api/device/reset', method: 'POST', body: {
        'token': _token,
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

      final SharedPreferences prefs = await _prefs;
      prefs.setString('email', email!);
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

  Future canAuthWithCachedData() async {
    try {
      final SharedPreferences prefs = await _prefs;
      Auth.authenticated = prefs.getBool('authenticated') ?? false;

      if (Auth.authenticated == true) {
        Auth.token = prefs.getString('token');
        firstname = prefs.getString('firstname');
      }

      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  Future signinWithCachedData() async {
    try {
      final SharedPreferences prefs = await _prefs;

      Auth.authenticated = prefs.getBool('authenticated') ?? false;

      if (Auth.authenticated == true) {
        await getProfile();

        id = prefs.getString('id');
        firstname = prefs.getString('firstname');
        lastname = prefs.getString('lastname');
        email = prefs.getString('email');
        telephone = prefs.getString('telephone');
        avatar = prefs.getString('avatar');
        referralCode = prefs.getString('referralCode');
        referralUnits = prefs.getInt('referralUnits');
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

  Future requestReferralCode() async {
    try {
      var resp = await request('/api/student/request-referral-code', headers: {
        'JWToken': Auth.token!,
        'cache-control': 'max-age=0, must-revalidate'
      });

      if (resp['status'] == true) {
        final SharedPreferences prefs = await _prefs;
        referralCode = resp['data']['referral_code'];
        prefs.setString('referralCode', referralCode!);

        notifyListeners();
      }
    } catch (e) {
      throw (e);
    }
  }

  Future getProfile() async {
    try {
      var resp = await request('/api/student/profile', headers: {
        'JWToken': Auth.token!,
        'cache-control': 'max-age=0, must-revalidate'
      });

      if (resp['status'] == true) {
        var student = resp['data'];

        id = student['id'];
        firstname = student['firstname'];
        lastname = student['lastname'];
        email = student['email'];
        telephone = student['telephone'];
        avatar = student['avatar'];
        referralCode = student['referral_code'] ?? '';
        referralUnits = int.parse(student['referral_units']);
        status = student['status'];

        final SharedPreferences prefs = await _prefs;
        prefs.setString('id', id!);
        prefs.setString('firstname', firstname!);
        prefs.setString('lastname', lastname!);
        prefs.setString('email', email!);
        prefs.setString('telephone', telephone!);
        prefs.setString('avatar', avatar!);
        prefs.setString('referralCode', referralCode!);
        prefs.setInt('referralUnits', referralUnits!);
        prefs.setString('status', status!);
      }

      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  Future cacheSigninData() async {
    //? store user data in sharedpreference
    final SharedPreferences prefs = await _prefs;
    prefs.setString('id', id!);
    prefs.setString('firstname', firstname!);
    prefs.setString('lastname', lastname!);
    prefs.setString('email', email!);
    prefs.setString('telephone', telephone!);
    prefs.setString('avatar', avatar!);
    prefs.setString('referralCode', referralCode!);
    prefs.setInt('referralUnits', referralUnits!);
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
    prefs.remove('referralCode');
    prefs.remove('referralUnits');
    prefs.remove('status');
    prefs.remove('token');
    prefs.setBool('authenticated', false);
  }
}

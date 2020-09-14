import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'common.dart';

class App extends Common {
  // static String appurl = 'https://spicyguitaracademy.com';
  static String appurl = 'http://test.initframework.com';
  static String appName = "Spicy Guitar Academy";
  static String paystackPublicKey =
      'pk_test_2aedc9b8a06baff2b47a08a08cd1b0237c260e4a';

  static Future<bool> signup(scaffold, String firstname, String lastname,
      String email, String telephone, String password, String cpassword) async {
    var resp = await http.post(
      appurl + '/api/register',
      body: {
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'telephone': telephone,
        'password': password,
        'cpassword': cpassword
      },
    );

    if (resp.statusCode != 200) {
      Common.showMessage(scaffold, 'Registeration Failed.');
      return false;
    } else {
      var respb = resp.body;
      Map<String, dynamic> json = jsonDecode(respb);
      if (json['success'] != '') {
        showMessage(scaffold, json['success']);
        return true;
      } else {
        showMessage(scaffold, json['error']);
        return false;
      }
    }
  }

  static Future<bool> login(scaffold, String email, String password) async {
    User.reset();
    var resp = await http.post('http://test.initframework.com/api/login',
        body: {'email': email, 'password': password});

    if (resp.statusCode != 200) {
      showMessage(scaffold, 'Login Failed.');
      return false;
    } else {
      var respb = resp.body;
      Map<String, dynamic> json = jsonDecode(respb);
      // showMessage(scaffold, respb);
      if (json['success'] != '') {
        User.firstname = json['student']['firstname'];
        User.lastname = json['student']['lastname'];
        User.email = json['student']['email'];
        User.telephone = json['student']['telephone'];
        User.id = json['student']['id'];
        User.avatar = json['student']['avatar'];
        User.token = json['token'];
        User.justLoggedIn = true;
        print(User.token);
        showMessage(scaffold, json['success']);

        // set the student subscription details
        getUserSubscriptionStatus();

        // get subscription plans
        getSubscriptionPlans();

        // get the student's category and stats
        studentStatistics();

        return true;
      } else {
        showMessage(scaffold, json['errors']);
        return false;
      }
    }
  }

  static studentStatistics() async {
    var resp = await http
        .get('http://test.initframework.com/api/student/statistics', headers: {
      'cache-control': 'no-cache',
      'JWToken': User.token,
    });

    if (resp.statusCode != 200) {
      print('Getting Student Subscription Status Failed (${resp.statusCode}).');
      return false;
    } else {
      var respb = resp.body;
      Map<String, dynamic> json = jsonDecode(respb);
      print(json['status']);
      if (json['status'] == false) {
        User.categoryStats = null;
        User.category = null;
      } else {
        User.categoryStats = json['stats'];
        User.category = json['category'];
      }
      print("student stats is ${json['category']}");
    }
  }

  static getSubscriptionPlans() async {
    var resp = await http.get(
        'http://test.initframework.com/api/subscription/plans',
        headers: {'JWToken': User.token, 'cache-control': 'no-cache'});

    if (resp.statusCode != 200) {
      print('Getting Subscription Plans Failed.');
    } else {
      var respb = resp.body;
      Map<String, dynamic> json = jsonDecode(respb);
      Subscription.plans = json['plans'];
    }
  }

  static getUserSubscriptionStatus() async {
    var resp = await http.get(
        'http://test.initframework.com/api/subscription/status',
        headers: {'JWToken': User.token, 'cache-control': 'no-cache'});

    if (resp.statusCode != 200) {
      print('${resp.statusCode} Getting Student Subscription Status Failed.');
      return false;
    } else {
      var respb = resp.body;
      Map<String, dynamic> json = jsonDecode(respb);
      User.subStatus = json['status'];
      User.daysRemaining = json['days'];
    }
  }

  static Future initiatePayment(scaffold, String plan) async {
    var resp = await http.post(
        'http://test.initframework.com/api/subscription/initiate',
        headers: {'JWToken': User.token},
        body: {'email': User.email, 'plan': plan});

    if (resp.statusCode != 200) {
      showMessage(scaffold, 'Initiate Subscription Failed.');
      return false;
    } else {
      var respb = resp.body;
      Map<String, dynamic> json = jsonDecode(respb);
      if (json['flag'] == true) {
        Subscription.reference = json['data']['reference'];
        Subscription.access_code = json['data']['access_code'];
        Subscription.price = json['data']['price'];
      } else {
        showMessage(scaffold, 'Initiate Subscription Failed.');
      }
      return true;
    }
  }

  static Future verifyPayment(String reference) async {
    var resp = await http.post(
        "http://test.initframework.com/api/subscription/verify/$reference",
        headers: {'JWToken': User.token},
        body: {'plan': reference});

    if (resp.statusCode != 200) {
      print('Error Occurred.');
    } else {
      final respb = resp.body;
      Map<String, dynamic> json = jsonDecode(respb);
      if (json['success']) {
        Subscription.paystatus = true;
        getUserSubscriptionStatus();
      }
    }
  }

  static Future chooseCategory(String category) async {
    var resp = await http.post(
        'http://test.initframework.com/api/student/category/select',
        headers: {'JWToken': User.token, 'cache-control': 'no-cache'},
        body: {'category': category});

    if (resp.statusCode != 200) {
      print('Getting Student Subscription Status Failed. (${resp.body}) ');
      return false;
    } else {
      var respb = resp.body;
      Map<String, dynamic> json = jsonDecode(respb);
      print("response message: ${json['message']}");

      await studentStatistics();
    }
  }

  static Future getAllCourses() async {
    var resp = await http.get('http://test.initframework.com/api/course/all',
        headers: {'JWToken': User.token, 'cache-control': 'no-cache'});

    if (resp.statusCode != 200) {
      print('${resp.statusCode} Getting Student Subscription Status Failed.');
      return false;
    } else {
      var respb = resp.body;
      Map<String, dynamic> json = jsonDecode(respb);
      Courses.allCourses = json;
      print(json);
    }
  }

  static Future studyingCourses() async {
    var resp = await http.get(
        'http://test.initframework.com/api/student/courses/studying',
        headers: {'JWToken': User.token, 'cache-control': 'no-cache'});

    if (resp.statusCode != 200) {
      print('${resp.statusCode} Getting Student Subscription Status Failed.');
      return false;
    } else {
      var respb = resp.body;
      Map<String, dynamic> json = jsonDecode(respb);
      Courses.studyingCourses = json['courses'];
      print(json['courses']);
    }
  }

  static Future courseLessons(int course) async {
    var resp = await http.get(
        'http://test.initframework.com/api/course/$course/lessons',
        headers: {'JWToken': User.token, 'cache-control': 'no-cache'});

    if (resp.statusCode != 200) {
      print('${resp.statusCode} Getting Student Subscription Status Failed.');
      return false;
    } else {
      var respb = resp.body;
      Map<String, dynamic> json = jsonDecode(respb);
      // showMessage(json['status']);
      return true;
    }
  }

  static Future getLesson(int lesson) async {
    var resp = await http.get(
        'http://test.initframework.com/api/lesson/$lesson',
        headers: {'JWToken': User.token, 'cache-control': 'no-cache'});

    if (resp.statusCode != 200) {
      print('${resp.statusCode} Getting Student Subscription Status Failed.');
      return false;
    } else {
      var respb = resp.body;
      Map<String, dynamic> json = jsonDecode(respb);
      // showMessage(json['status']);
      return true;
    }
  }

  static Future studyingLesson(lesson) async {
    var resp = await http.get(
        'http://test.initframework.com/api/student/lesson/$lesson',
        headers: {'JWToken': User.token, 'cache-control': 'no-cache'});

    if (resp.statusCode != 200) {
      print('${resp.statusCode} Getting Student Subscription Status Failed.');
      return false;
    } else {
      var respb = resp.body;
      Map<String, dynamic> json = jsonDecode(respb);
      // showMessage(json['status']);
      return true;
    }
  }

  static Future nextLesson(lesson) async {
    var resp = await http.get(
        'http://test.initframework.com/api/student/lesson/$lesson/next?course=${User.studyingCourse}',
        headers: {'JWToken': User.token, 'cache-control': 'no-cache'});

    if (resp.statusCode != 200) {
      print('${resp.statusCode} Getting Student Subscription Status Failed.');
      return false;
    } else {
      var respb = resp.body;
      Map<String, dynamic> json = jsonDecode(respb);
      // showMessage(json['status']);
      return true;
    }
  }

  static Future prevLesson(lesson) async {
    var resp = await http.get(
        'http://test.initframework.com/api/student/lesson/$lesson/previous?course=${User.studyingCourse}',
        headers: {'JWToken': User.token, 'cache-control': 'no-cache'});

    if (resp.statusCode != 200) {
      print('${resp.statusCode} Getting Student Subscription Status Failed.');
      return false;
    } else {
      var respb = resp.body;
      Map<String, dynamic> json = jsonDecode(respb);
      // showMessage(json['status']);
      return true;
    }
  }

  static Future answerAssignment(assignment) async {
    var resp = await http.post(
        'http://test.initframework.com/api/student/assignment/answer',
        headers: {'JWToken': User.token, 'cache-control': 'no-cache'},
        body: {'assignment': assignment});

    if (resp.statusCode != 200) {
      print('${resp.statusCode} Getting Student Subscription Status Failed.');
      return false;
    } else {
      var respb = resp.body;
      Map<String, dynamic> json = jsonDecode(respb);
      // showMessage(json['status']);
      return true;
    }
  }

  static Future search(query) async {
    var resp = await http.get(
        'http://test.initframework.com/api/courses/search?q=$query',
        headers: {'JWToken': User.token, 'cache-control': 'no-cache'});

    if (resp.statusCode != 200) {
      print('${resp.statusCode} Getting Student Subscription Status Failed.');
      return false;
    } else {
      var respb = resp.body;
      Map<String, dynamic> json = jsonDecode(respb);
      // showMessage(json['status']);
      return true;
    }
  }

  static Future inviteAFriend(String friend) async {
    var resp = await http.post(
        'http://test.initframework.com/api/invite-a-friend',
        headers: {'JWToken': User.token, 'cache-control': 'no-cache'},
        body: {'friend': friend});

    if (resp.statusCode != 200) {
      print('${resp.statusCode} Getting Student Subscription Status Failed.');
      return false;
    } else {
      var respb = resp.body;
      Map<String, dynamic> json = jsonDecode(respb);
      // showMessage(json['status']);
      return true;
    }
  }

  static Future uploadAvatar(String base64Image) async {
    var resp = await http.post(
        'http://test.initframework.com/api/student/avatar/update',
        headers: {'JWToken': User.token, 'cache-control': 'no-cache'},
        body: {'avatar': base64Image});

    if (resp.statusCode != 200) {
      print('${resp.statusCode} Getting Student Subscription Status Failed.');
      return false;
    } else {
      var respb = resp.body;
      Map<String, dynamic> json = jsonDecode(respb);
      // showMessage(json['status']);
      return true;
    }
  }

  static Future quicklessons() async {
    var resp = await http.get(
        'http://test.initframework.com/api/student/quicklessons',
        headers: {'JWToken': User.token, 'cache-control': 'no-cache'});

    if (resp.statusCode != 200) {
      print('${resp.statusCode} Getting Student Subscription Status Failed.');
      return false;
    } else {
      var respb = resp.body;
      Map<String, dynamic> json = jsonDecode(respb);
      // showMessage(json['status']);
      return true;
    }
  }

  static Future quicklesson(lesson) async {
    var resp = await http.get(
        'http://test.initframework.com/api/student/quicklesson/$lesson',
        headers: {'JWToken': User.token, 'cache-control': 'no-cache'});

    if (resp.statusCode != 200) {
      print('${resp.statusCode} Getting Student Subscription Status Failed.');
      return false;
    } else {
      var respb = resp.body;
      Map<String, dynamic> json = jsonDecode(respb);
      // showMessage(json['status']);
      return true;
    }
  }

  static Future freelesson() async {
    var resp = await http.get(
        'http://test.initframework.com/api/student/freelessons',
        headers: {'JWToken': User.token, 'cache-control': 'no-cache'});

    if (resp.statusCode != 200) {
      print('${resp.statusCode} Getting Student Subscription Status Failed.');
      return false;
    } else {
      var respb = resp.body;
      Map<String, dynamic> json = jsonDecode(respb);
      Courses.freeLessons = json['lessons'];
      print(Courses.freeLessons);
    }
  }

  // static tempStore(String field, value, String type) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (prefs.containsKey(field) == false) {
  //     switch (type) {
  //       case 'string':
  //         prefs.setString(field, value);
  //       break;
  //       case 'int':
  //         prefs.setInt(field, value);
  //       break;
  //       case 'double':
  //         prefs.setDouble(field, value);
  //       break;
  //       case 'bool':
  //         prefs.setBool(field, value);
  //       break;
  //       case 'slist':
  //         prefs.setStringList(field, value);
  //       break;
  //       default:
  //         prefs.setString(field, value);
  //       break;
  //     }
  //   } else {
  //     print("Trying to add temp: $field that already exists");
  //   }

  // }

  // static tempGet(String field, String type) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (prefs.containsKey(field) == true) {
  //     switch (type) {
  //       case 'string':
  //         return prefs.getString(field);
  //       case 'int':
  //         return prefs.getInt(field);
  //       case 'double':
  //         return prefs.getDouble(field);
  //       case 'bool':
  //         return prefs.getBool(field);
  //       case 'slist':
  //         return prefs.getStringList(field);
  //       default:
  //         return prefs.get(field);
  //     }
  //   }
  // }

  // static tempRemove(String field) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (prefs.containsKey(field) == true) {
  //     prefs.remove(field);
  //   }
  // }

  // static tempRemoveAll() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.clear();
  // }

  static showMessage(scaffoldKey, String message) {
    Common.showMessage(scaffoldKey, message);
  }
}

class User {
  static bool justLoggedIn = false;
  static String id;
  static String firstname;
  static String lastname;
  static String email;
  static String telephone;
  static String avatar;
  static String token;

  static String category;
  static Map<String, dynamic> categoryStats;

  static String studyingCourse;

  static String subStatus;
  static String daysRemaining;

  static reset() {
    User.id = null;
    User.firstname = null;
    User.lastname = null;
    User.email = null;
    User.telephone = null;
    User.avatar = null;
    User.token = null;
    User.category = null;
    User.categoryStats = null;
    User.studyingCourse = null;
    User.subStatus = null;
    User.daysRemaining = null;
  }
}

class Courses {
  static Map<String, dynamic> allCourses;
  static List<dynamic> studyingCourses;
  static Map<String, dynamic> freeLessons;
  static Map<String, dynamic> quickLessons;

  static getAllCourses() {
    return Courses.allCourses;
  }
}

class Lessons {
  // the properties on the class
  String thumbnail, tutor, title, description;

  // the constructor
  Lessons(this.thumbnail, this.tutor, this.title, this.description);

  // constructing from json
  Lessons.fromJson(Map<String, dynamic> json) {
    thumbnail = json['thumbnail'];
    tutor = json['tutor'];
    title = json['title'];
    description = json['description'];
  }
}

class Subscription {
  static String status;
  static String reference;
  // ignore: non_constant_identifier_names
  static String access_code;
  static int price;
  static List<dynamic> plans;

  static bool paystatus;
}

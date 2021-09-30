import 'package:flutter/foundation.dart';
import 'package:spicyguitaracademy_app/providers/Auth.dart';
import 'package:spicyguitaracademy_app/providers/Course.dart';
import 'package:spicyguitaracademy_app/utils/exceptions.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';
import 'package:spicyguitaracademy_app/utils/request.dart';
import 'package:spicyguitaracademy_app/widgets/modals.dart';

class Courses extends ChangeNotifier {
  Course? currentCourse;
  String? activateCourseErrMsg;

  List<Course> studyingCourses = [];
  List<Course> beginnersCourses = [];
  List<Course> amateurCourses = [];
  List<Course> intermediateCourses = [];
  List<Course> advancedCourses = [];
  List<Course> featuredCourses = [];
  List<Course> boughtCourses = [];

  Future getAllCourses() async {
    try {
      var resp =
          await request('/api/student/courses/all', method: 'GET', headers: {
        'JWToken': Auth.token!,
        'cache-control': 'public, max-age=604800, must-revalidate'
      });

      // beginners
      beginnersCourses = [];
      List<dynamic> beginners = resp['data']['beginners'] ?? [];
      beginners.forEach((course) {
        beginnersCourses.add(Course.fromJson(course));
      });
      // amateurs
      amateurCourses = [];
      List<dynamic> amateurs = resp['data']['amateurs'] ?? [];
      amateurs.forEach((course) {
        amateurCourses.add(Course.fromJson(course));
      });
      // intermediates
      intermediateCourses = [];
      List<dynamic> intermediates = resp['data']['intermediates'] ?? [];
      intermediates.forEach((course) {
        intermediateCourses.add(Course.fromJson(course));
      });
      // advanced
      advancedCourses = [];
      List<dynamic> advanced = resp['data']['advanceds'] ?? [];
      advanced.forEach((course) {
        advancedCourses.add(Course.fromJson(course));
      });

      notifyListeners();
    } on AuthException catch (e) {
      throw (e);
    } catch (e) {
      throw (e);
    }
  }

  Future getStudyingCourses() async {
    try {
      // TODO: Fix cache max-age

      var resp = await request('/api/student/courses/studying',
          method: 'GET',
          headers: {
            'JWToken': Auth.token!,
            'cache-control': 'private, max-age=2592000, must-revalidate'
          });
      List<dynamic> courses = resp['data'] ?? [];
      studyingCourses = [];
      courses.forEach((course) {
        studyingCourses.add(Course.fromJson(course));
      });

      notifyListeners();
    } on AuthException catch (e) {
      throw (e);
    } catch (e) {
      throw (e);
    }
  }

  Future getFeaturedCourses() async {
    try {
      var resp = await request('/api/student/featuredcourses/all',
          method: 'GET',
          headers: {
            'JWToken': Auth.token!,
            'cache-control': 'public, max-age=604800, must-revalidate'
          });

      List<dynamic> courses = resp['data'] ?? [];
      featuredCourses = [];
      courses.forEach((course) {
        featuredCourses.add(Course.fromJson(course));
      });

      notifyListeners();
    } on AuthException catch (e) {
      throw (e);
    } catch (e) {
      throw (e);
    }
  }

  Future getBoughtCourses() async {
    try {
      var resp = await request('/api/student/featuredcourses/bought',
          method: 'GET',
          headers: {
            'JWToken': Auth.token!,
            'cache-control': 'private, max-age=86400, must-revalidate'
          });
      List<dynamic> courses = resp['data'] ?? [];
      boughtCourses = [];
      courses.forEach((course) {
        boughtCourses.add(Course.fromJson(course));
      });

      notifyListeners();
    } on AuthException catch (e) {
      throw (e);
    } catch (e) {
      throw (e);
    }
  }

  sortCoursesByTutor(courses) {
    return courses
        .sort((a, b) => a.tutor.toString().compareTo(b.tutor.toString()));
  }

  sortCoursesByTitle(courses) {
    return courses
        .sort((a, b) => a.title.toString().compareTo(stripExceptions(b.title)));
  }

  sortCoursesByOrder(courses) {
    return courses
        .sort((a, b) => a.order.toString().compareTo(b.order.toString()));
  }

  Future activateCourse(context) async {
    try {
      activateCourseErrMsg = "";
      var resp = await request('/api/student/course/activate',
          method: 'POST',
          body: {
            'course': currentCourse!.id.toString()
          },
          headers: {
            'JWToken': Auth.token!,
            'cache-control': 'max-age=0, must-revalidate'
          });

      if (resp['status'] == true) {
        currentCourse!.status = true;
        studyingCourses[studyingCourses.indexOf(currentCourse!)] =
            currentCourse!;
      } else {
        currentCourse!.status = false;
        // TODO: move this snackbar snippet to where the function was called from
        // and throw an exception instead.

        if (resp['message'] != "Course already activated") {
          snackbar(context, resp['message'], timeout: 15);
        } else {
          currentCourse!.status = true;
          studyingCourses[studyingCourses.indexOf(currentCourse!)] =
              currentCourse!;
        }
      }

      notifyListeners();
    } on AuthException catch (e) {
      throw (e);
    } catch (e) {
      throw (e);
    }
  }
}

import 'package:flutter/foundation.dart';
import 'package:spicyguitaracademy_app/providers/Auth.dart';
import 'package:spicyguitaracademy_app/providers/Courses.dart';
import 'package:spicyguitaracademy_app/providers/Lesson.dart';
import 'package:spicyguitaracademy_app/providers/StudentStudyStatistics.dart';
import 'package:spicyguitaracademy_app/providers/Tutorial.dart';
import 'package:spicyguitaracademy_app/utils/exceptions.dart';
import 'package:spicyguitaracademy_app/utils/request.dart';

enum LessonSource { free, featured, normal }

class Lessons extends ChangeNotifier {
  List<Lesson>? courseLessons = [];
  List<Lesson>? freeLessons = [];
  List<Lesson>? allLessons = [];
  List<Lesson>? studyingCateogryLessons = [];
  LessonSource? source;

  Future getAllLessons() async {
    try {
      var resp =
          await request('/api/student/alllessons', method: 'GET', headers: {
        // 'JWToken': Auth.token!,
        'cache-control': 'public, max-age=2592000, must-revalidate'
      });
      List<dynamic> lessons = resp['data'] ?? [];
      allLessons = [];
      lessons.forEach((lesson) {
        allLessons?.add(Lesson.fromJson(lesson));
      });

      notifyListeners();
    } on AuthException catch (e) {
      throw (e);
    } catch (e) {
      throw (e);
    }
  }

  Future getFreeLessons() async {
    try {
      var resp =
          await request('/api/student/freelessons', method: 'GET', headers: {
        // 'JWToken': Auth.token!,
        'cache-control': 'public, max-age=2592000, must-revalidate'
      });
      List<dynamic> lessons = resp['data'] ?? [];
      freeLessons = [];
      lessons.forEach((lesson) {
        freeLessons?.add(Lesson.fromJson(lesson));
      });

      notifyListeners();
    } on AuthException catch (e) {
      throw (e);
    } catch (e) {
      throw (e);
    }
  }

  Future getCourseLessonsForStudyingCategory(studyingCategory) async {
    try {
      var resp = await request('/api/category/$studyingCategory/lessons',
          method: 'GET',
          headers: {
            'JWToken': Auth.token!,
            'cache-control': 'max-age=0, must-revalidate'
          });
      List<dynamic> lessons = resp['data'] ?? [];
      studyingCateogryLessons = [];
      lessons.forEach((lesson) {
        studyingCateogryLessons?.add(Lesson.fromJson(lesson));
      });

      print('Category Lessons');
      print(lessons);

      notifyListeners();
    } on AuthException catch (e) {
      throw (e);
    } catch (e) {
      throw (e);
    }
  }

  Future getCourseLessons(context, courseid) async {
    try {
      var resp = await request('/api/course/$courseid/lessons',
          method: 'GET',
          headers: {
            'JWToken': Auth.token!,
            'cache-control': 'max-age=0, must-revalidate'
          });
      List<dynamic> lessons = resp['data'] ?? [];
      courseLessons = [];
      lessons.forEach((lesson) {
        courseLessons?.add(Lesson.fromJson(lesson));
      });

      notifyListeners();
    } on AuthException catch (e) {
      throw (e);
    } catch (e) {
      throw (e);
    }
  }

  Future getFeaturedLessons(context, courseid) async {
    try {
      var resp = await request('/api/course/featured/$courseid/lessons',
          method: 'GET',
          headers: {
            'JWToken': Auth.token!,
            'cache-control': 'max-age=0, must-revalidate'
          });
      List<dynamic> lessons = resp['data'] ?? [];
      courseLessons = [];
      lessons.forEach((lesson) {
        courseLessons?.add(Lesson.fromJson(lesson));
      });

      notifyListeners();
    } on AuthException catch (e) {
      throw (e);
    } catch (e) {
      throw (e);
    }
  }

  Future activateLesson(StudentStudyStatistics studentStats, Courses courses,
      Tutorial tutorial) async {
    try {
      var resp = await request('/api/student/lesson/activate',
          method: 'POST',
          body: {
            'lesson': tutorial.currentTutorial!.id.toString()
          },
          headers: {
            'JWToken': Auth.token!,
            'cache-control': 'max-age=0, must-revalidate'
          });

      if (resp['status'] == true) {
        // update the number of lessons taken in the stats
        studentStats.takenLessons = studentStats.takenLessons! + 1;
        courses.currentCourse!.completedLessons =
            courses.currentCourse!.completedLessons! + 1;
        courses.studyingCourses[courses.studyingCourses
            .indexOf(courses.currentCourse!)] = courses.currentCourse!;
        // if all lessons for this course has been taken,
        // update the nuber of course completed for this student
        if (courses.currentCourse!.allLessons ==
            courses.currentCourse!.completedLessons) {
          studentStats.takenCourses = studentStats.takenCourses! + 1;
        }
      }

      notifyListeners();
    } on AuthException catch (e) {
      throw (e);
    } catch (e) {
      throw (e);
    }
  }

  Future activateFeaturedLesson(Courses courses, Tutorial tutorial) async {
    try {
      var resp = await request('/api/student/lesson/activate-featured',
          method: 'POST',
          body: {
            'lesson': tutorial.currentTutorial!.id.toString()
          },
          headers: {
            'JWToken': Auth.token!,
            'cache-control': 'max-age=0, must-revalidate'
          });

      if (resp['status'] == true) {
        // update the number of lessons taken for the current course
        courses.currentCourse!.completedLessons =
            courses.currentCourse!.completedLessons! + 1;
        courses.boughtCourses[courses.boughtCourses
            .indexOf(courses.currentCourse!)] = courses.currentCourse!;
      }

      notifyListeners();
    } on AuthException catch (e) {
      throw (e);
    } catch (e) {
      throw (e);
    }
  }
}

import 'package:flutter/foundation.dart';
import 'package:spicyguitaracademy_app/providers/Auth.dart';
import 'package:spicyguitaracademy_app/providers/StudentSubscription.dart';
import 'package:spicyguitaracademy_app/utils/request.dart';

class StudentStudyStatistics extends ChangeNotifier {
  int? studyingCategory;
  String? studyingCategoryLabel;
  int? originalStudyingCategory;
  String? originalStudyingCategoryLabel;
  int? takenCourses;
  int? allCourses;
  int? takenLessons;
  int? allLessons;
  List<dynamic>? previousCategories;
  bool viewingPreviousCourse = false;

  Future getStudentCategoryAndStatsForPreviousCategories(
      StudentSubscription studentSubscription, int category) async {
    try {
      var resp = await request(
        '/api/student/statistics/previous/$category',
        method: 'GET',
        headers: {
          'JWToken': Auth.token!,
          'cache-control': 'max-age=0, must-revalidate'
        },
      );

      if (resp['status'] == true) {
        studyingCategory = category;
        takenCourses = resp['data']['takenCourses'] ?? 0;
        allCourses = resp['data']['allCourses'] ?? 0;
        takenLessons = resp['data']['takenLessons'] ?? 0;
        allLessons = resp['data']['allLessons'] ?? 0;
      } else {
        studyingCategory = 0;
        takenCourses = 0;
        allCourses = 0;
        takenLessons = 0;
        allLessons = 0;
      }

      studyingCategoryLabel = [
        "No Category",
        "Beginner",
        "Amateur",
        "Intermediate",
        "Advanced"
      ][studyingCategory!];

      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  Future getStudentCategoryAndStats(
      StudentSubscription studentSubscription) async {
    try {
      var resp = await request(
        '/api/student/statistics',
        method: 'GET',
        headers: {
          'JWToken': Auth.token!,
          'cache-control': 'max-age=0, must-revalidate'
        },
      );

      if (resp['status'] == true) {
        studyingCategory = resp['data']['category'] ?? 0;
        takenCourses = resp['data']['takenCourses'] ?? 0;
        allCourses = resp['data']['allCourses'] ?? 0;
        takenLessons = resp['data']['takenLessons'] ?? 0;
        allLessons = resp['data']['allLessons'] ?? 0;
      } else {
        studyingCategory = 0;
        takenCourses = 0;
        allCourses = 0;
        takenLessons = 0;
        allLessons = 0;
      }

      if (studentSubscription.isSubscribed == false) studyingCategory = 0;

      studyingCategoryLabel = [
        "No Category",
        "Beginner",
        "Amateur",
        "Intermediate",
        "Advanced"
      ][studyingCategory!];

      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  Future chooseCategory(
      StudentSubscription studentSubscription, String? category) async {
    try {
      var resp = await request('/api/student/category/select',
          method: 'POST',
          headers: {
            'JWToken': Auth.token!,
            'cache-control': 'max-age=0, must-revalidate'
          },
          body: {
            'category': category
          });

      if (resp['status'] == true) {
        await getStudentCategoryAndStats(studentSubscription);
      }

      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  Future getPreviousCategories() async {
    try {
      var resp = await request(
        '/api/student/category/previous',
        method: 'GET',
        headers: {
          'JWToken': Auth.token!,
          'cache-control': 'max-age=0, must-revalidate'
        },
      );

      if (resp['status'] == true) {
        previousCategories = resp['data'];
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw (e);
    }
  }

  Future rechooseCategory(String? category) async {
    try {
      await request('/api/student/category/re-select',
          method: 'POST',
          headers: {
            'JWToken': Auth.token!,
            'cache-control': 'max-age=0, must-revalidate'
          },
          body: {
            'category': category
          });

      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }
}

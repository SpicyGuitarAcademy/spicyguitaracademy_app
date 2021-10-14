import 'package:flutter/foundation.dart';

class Ui extends ChangeNotifier {
  int dashboardPage = 0;
  // int coursesPage = 0;
  // int featuredCoursesPage = 0;

  setDashboardPage(int page) {
    dashboardPage = page;
    notifyListeners();
  }

  // setCoursesPage(int page) {
  //   coursesPage = page;
  //   notifyListeners();
  // }

  // setFeaturedCoursesPage(int page) {
  //   featuredCoursesPage = page;
  //   notifyListeners();
  // }
}

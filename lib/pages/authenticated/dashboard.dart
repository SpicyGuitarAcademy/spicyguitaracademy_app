import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:spicyguitaracademy_app/providers/Student.dart';
import 'package:spicyguitaracademy_app/providers/StudentNotifications.dart';
import 'package:spicyguitaracademy_app/providers/StudentStudyStatistics.dart';
import 'package:spicyguitaracademy_app/providers/StudentSubscription.dart';

import 'package:spicyguitaracademy_app/pages/authenticated/home_page.dart';
import 'package:spicyguitaracademy_app/pages/authenticated/courses_page.dart';
import 'package:spicyguitaracademy_app/pages/authenticated/featured_courses_page.dart';
import 'package:spicyguitaracademy_app/pages/authenticated/userprofile_page.dart';
import 'package:spicyguitaracademy_app/providers/Ui.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';
import 'package:spicyguitaracademy_app/widgets/back_button.dart';

class Dashboard extends StatefulWidget {
  @override
  DashboardState createState() => new DashboardState();
}

class DashboardState extends State<Dashboard> {
  // int _pageIndex = 0;

  bool? hasFetchedNotifications = false;
  bool? hasFetchedStudentStats = false;

  @override
  void initState() {
    super.initState();
  }

  // rebuild(index) {
  //   setState(() => _pageIndex = index);
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<Ui>(builder: (BuildContext context, ui, child) {
      return Consumer<Student>(builder: (BuildContext context, student, child) {
        return Consumer<StudentSubscription>(
            builder: (BuildContext context, studentSubscription, child) {
          return Consumer<StudentStudyStatistics>(
              builder: (BuildContext context, studentStats, child) {
            return Consumer<StudentNotifications>(
                builder: (BuildContext context, studentNotifications, child) {
              return new Scaffold(
                  // key: dashboardScaffoldKey,
                  backgroundColor: grey,
                  appBar: AppBar(
                    toolbarHeight: 60,
                    iconTheme: IconThemeData(color: brown),
                    backgroundColor: grey,
                    centerTitle: true,
                    actions: <Widget>[
                      IconButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, "/notification"),
                          icon: Stack(
                              alignment: Alignment.topLeft,
                              children: <Widget>[
                                SvgPicture.asset(
                                  "assets/imgs/icons/notification_icon.svg",
                                  width: 24.0,
                                  matchTextDirection: true,
                                ),
                                studentNotifications.unreadNotifications! > 0
                                    ? Container(
                                        width: 15,
                                        height: 15,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: brown,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Text(
                                          studentNotifications
                                              .unreadNotifications
                                              .toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                      )
                                    : SizedBox()
                              ])),
                      IconButton(
                        onPressed: () => ui.setDashboardPage(3),
                        icon: Center(
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: brown,
                            backgroundImage: NetworkImage(
                              '$baseUrl/${student.avatar}',
                              headers: {
                                'cache-control': 'max-age=0, must-revalidate'
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                    elevation: 0,
                  ),
                  body: SafeArea(
                    minimum: EdgeInsets.all(10.0),
                    child: [
                      new HomePage(),
                      new CoursesPage(),
                      new FeaturedCoursesPage(),
                      new UserProfilePage(),
                    ][ui.dashboardPage],
                  ),
                  drawer: Container(
                    width: screen(context).width * 0.6,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Drawer(
                      semanticLabel: "Side Navigation Bar",
                      child: SingleChildScrollView(
                          child: Column(
                        children: <Widget>[
                          SizedBox(height: 40),
                          Container(
                            alignment: Alignment.topRight,
                            margin: EdgeInsets.only(right: 10.0),
                            child: backButton(
                              context,
                              padding: 10,
                              radius: 12.0,
                            ),
                          ),
                          SizedBox(height: 20),
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: brown,
                            backgroundImage: NetworkImage(
                              '$baseUrl/${student.avatar}',
                              headers: {
                                'cache-control': 'max-age=0, must-revalidate'
                              },
                            ),
                          ),
                          Text("${student.firstname} ${student.lastname}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18.0,
                                  color: darkgrey)),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 1.5, horizontal: 15),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                color: brown),
                            child: Text(
                              "${studentStats.takenCourses} of ${studentStats.allCourses}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 20),
                          sideBarItem(
                              "assets/imgs/icons/sidebar_home_icon.svg", "Home",
                              () {
                            ui.setDashboardPage(0);
                          }),
                          sideBarItem(
                              "assets/imgs/icons/sidebar_video_icon.svg",
                              "Tutorial", () {
                            ui.setDashboardPage(1);
                          }),
                          sideBarItem(
                              "assets/imgs/icons/message_icon.svg", "Forum",
                              () {
                            Navigator.pushNamed(context, '/forums');
                          }, width: 20),
                          // sideBarItem("assets/imgs/icons/settings_icon.svg", "Settings",
                          //     () {
                          //   Navigator.pushNamed(context, '/settings');
                          // }),
                          sideBarItem("assets/imgs/icons/contactus_icon.svg",
                              "Contact Us", () {
                            Navigator.pushNamed(context, '/contactus');
                          }),
                          sideBarItem(
                              "assets/imgs/icons/signout_icon.svg", "Sign Out",
                              () {
                            student.signout();
                            Navigator.popUntil(
                                context, ModalRoute.withName('/'));
                            Navigator.pushNamed(context, '/welcome_page');
                          }),
                        ],
                      )),
                    ),
                  ),

                  // bottom navigation bar
                  bottomNavigationBar: BottomNavigationBar(
                    selectedItemColor: Colors.white,
                    currentIndex: ui.dashboardPage,
                    iconSize: 20.0,
                    onTap: (int index) {
                      ui.setDashboardPage(index);
                    },
                    items: [
                      bottomNavBarItem(
                          'Home', 'assets/imgs/icons/home_icon.svg'),
                      bottomNavBarItem(
                          'Courses', 'assets/imgs/icons/courses_icon.svg'),
                      bottomNavBarItem(
                          'Featured', 'assets/imgs/icons/video_icon.svg'),
                      bottomNavBarItem(
                          'Profile', 'assets/imgs/icons/user_icon.svg'),
                    ],
                  ));
            });
          });
        });
      });
    });
  }

  ListTile sideBarItem(String asset, String title, Function callback,
      {double? width}) {
    return ListTile(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              asset,
              width: width,
              matchTextDirection: true,
            ),
            SizedBox(width: 20),
            Text(title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: darkgrey, fontSize: 14.0)),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 14, color: brown),
        onTap: () {
          Navigator.pop(context);
          callback();
          // Navigator.pushNamed(context, route);
        });
  }

  BottomNavigationBarItem bottomNavBarItem(String label, String asset) {
    return BottomNavigationBarItem(
      backgroundColor: brown,
      label: label,
      icon: SvgPicture.asset(
        asset,
        matchTextDirection: true,
      ),
    );
  }
}
